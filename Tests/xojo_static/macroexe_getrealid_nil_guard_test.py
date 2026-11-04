"""Static guard test for issue #72 (MacroExe replay crash).

Crash chain: MultipleSelectOperation.MouseDown -> MacroExe.DoOperation ->
MacroExe.ExecuteMacro -> MacroExe.CreateObject -> ShapeConstruction.Constructor ->
MExe.GetRealId -> RuntimeException "ID not found".

A macro referencing an unknown MacId (skipped/unsupported op, out-of-order
ref, init not SetItem'd) must not raise; replay must skip that shape safely.
"""

from pathlib import Path

BASE = Path(__file__).resolve().parent.parent.parent
MACROEXE = BASE / "Macros Classes/MacroExe.xojo_code"
SHAPECONST = BASE / "Operation Classes/MultipleSelect Operations/ShapeConstruction.xojo_code"
PARAPERP = BASE / "Operation Classes/MultipleSelect Operations/ParaperpConstruction.xojo_code"
DIVIDE = BASE / "Operation Classes/MultipleSelect Operations/Divide.xojo_code"
DUPLICATE = BASE / "Operation Classes/SelectAndDrag Operations/Duplicate.xojo_code"
GCCONST = BASE / "Operation Classes/SelectOperation/GCConstruction.xojo_code"
PROLONGER = BASE / "Operation Classes/SelectOperation/Prolonger.xojo_code"
INTERSEC = BASE / "Listes/Intersec Classes/Intersec.xojo_code"
APPLIQUERTSF = BASE / "Transformation classes/AppliquerTsf.xojo_code"
FIXPCONST = BASE / "Transformation classes/FixPConstruction.xojo_code"

def extract_method(text: str, marker: str, end_marker: str = "#tag EndMethod") -> str:
    low = text.lower()
    start = low.find(marker.lower())
    if start == -1:
        raise AssertionError(f"method marker not found: {marker!r}")
    end = low.find(end_marker.lower(), start)
    if end == -1:
        raise AssertionError(f"end marker not found after method: {marker!r}")
    return text[start:end]

def _body(path: Path, marker: str) -> str:
    assert path.is_file(), f"missing source file: {path}"
    return extract_method(path.read_text(encoding="utf-8"), marker).lower()

def assert_guard_before_deref(body: str, guard: str, derefs: list, method: str) -> None:
    g = body.find(guard)
    assert g != -1, f"{method}: missing guard {guard!r}"
    hits = [(d, p) for d in derefs for p in [body.find(d)] if p != -1]
    assert hits, f"{method}: no deref marker found"
    first = min(p for _, p in hits)
    assert g < first, f"{method}: guard {guard!r} must precede first deref"

def assert_skip_after(body: str, guard: str, method: str, window: int = 300) -> None:
    pos = body.find(guard)
    assert pos != -1, f"{method}: missing guard {guard!r}"
    tail = body[pos:pos + window]
    assert "continue" in tail or "return" in tail, f"{method}: guard {guard!r} needs continue/return skip"


def test_getrealid_returns_minus1_on_unknown():
    body = extract_method(
        MACROEXE.read_text(encoding="utf-8"), "Function GetRealId(n as integer) as integer"
    ).lower()
    assert "if idx = -1 then" in body
    assert "return -1" in body
    assert "raise new runtimeexception" not in body


def test_getrealside_returns_minus1_on_unknown():
    body = extract_method(
        MACROEXE.read_text(encoding="utf-8"), "Function GetRealSide(n as integer) as integer"
    ).lower()
    assert "if idx = -1 then" in body
    assert "return -1" in body


def test_createobject_guards_unknown_refs():
    body = extract_method(
        MACROEXE.read_text(encoding="utf-8"), "Sub CreateObject(EL as XMLElement"
    ).lower()
    assert "if el = nil then" in body
    assert "if el0 = nil then" in body
    assert "if el1 = nil then" in body
    assert "if rid = -1 then" in body
    assert "if createdshape = nil then" in body


def test_shapeconstruction_guards_unknown_id():
    body = extract_method(
        SHAPECONST.read_text(encoding="utf-8"), "Sub Constructor(Mexe as MacroExe"
    ).lower()
    assert "if mexe = nil then" in body
    assert "if el0 = nil then" in body
    assert "if el1 = nil then" in body
    assert "if rid = -1 then" in body
    assert "if sh = nil then" in body
    assert "if pt = nil then" in body

def _assert_replay_guards(path, marker):
    body = extract_method(path.read_text(encoding="utf-8"), marker).lower()
    assert "if rid = -1 then" in body, path
    assert "return" in body, path

def test_paraperp_guards_unknown_id():
    _assert_replay_guards(PARAPERP, "Sub Constructor(Mexe as MacroExe")

def test_divide_guards_unknown_id():
    _assert_replay_guards(DIVIDE, "Sub Constructor(Mexe as MacroExe")

def test_duplicate_guards_unknown_id():
    _assert_replay_guards(DUPLICATE, "Sub Constructor(MExe as MacroExe")

def test_gcconstruction_guards_unknown_id():
    _assert_replay_guards(GCCONST, "Sub Constructor(MExe as MacroExe")

def test_prolonger_guards_unknown_id():
    _assert_replay_guards(PROLONGER, "Sub Constructor(MExe as MacroExe")

def test_intersec_guards_unknown_id():
    _assert_replay_guards(INTERSEC, "Sub Constructor(MExe as MacroExe")

def test_appliquertsf_guards_unknown_id():
    _assert_replay_guards(APPLIQUERTSF, "Sub Constructor(Mexe as MacroExe")

def test_fixpconstruction_guards_unknown_id():
    _assert_replay_guards(FIXPCONST, "Sub Constructor(MExe as MacroExe")

def test_createobject_guards_post_construction_derefs():
    body = extract_method(
        MACROEXE.read_text(encoding="utf-8"), "Sub CreateObject(EL as XMLElement"
    ).lower()
    assert "copies.count > 0" in body
    assert "createdshapes.count > 0" in body
    assert ".tsf <> nil" in body or ".tsf<>nil" in body

def test_createtransfo_guards_unknown_refs():
    body = _body(MACROEXE, "Sub CreateTransfo(EL as XMLElement")
    assert "if el = nil then" in body
    assert "if el0 = nil then" in body
    assert "if rid = -1 then" in body
    assert "if supp = nil then" in body

def test_execute_macro_guards_temp_el_nil():
    body = _body(MACROEXE, "Sub ExecuteMacro(Temp as XMLElement")
    assert_guard_before_deref(body, "if temp = nil then", ["temp.childcount", "temp.child("], "ExecuteMacro")
    assert_guard_before_deref(body, "if el = nil then", ["el.name"], "ExecuteMacro")
    assert_skip_after(body, "if temp = nil then", "ExecuteMacro")
    assert_skip_after(body, "if el = nil then", "ExecuteMacro")

def test_createifmacs_guards_temp_el_nil():
    body = _body(MACROEXE, "Sub CreateIfMacs(Temp as XMLElement")
    assert_guard_before_deref(body, "if temp = nil then", ["temp.childcount", "temp.child("], "CreateIfMacs")
    assert_guard_before_deref(body, "if el = nil then", ["el.name"], "CreateIfMacs")

def test_createifmacobject_guards_el_childcount():
    body = _body(MACROEXE, "Sub CreateIfMacObject(EL as XMLElement")
    assert_guard_before_deref(body, "if el = nil then", ["el.child("], "CreateIfMacObject")
    assert "if el.childcount < 2 then" in body or "if el.childcount<2 then" in body
    assert_guard_before_deref(body, "if el0 = nil then", ['el0.getattribute("id")', "el0.getattribute"], "CreateIfMacObject")
    assert_guard_before_deref(body, "if el1 = nil then", ["new infomac"], "CreateIfMacObject")

def test_createobject_obinit_loop_guards_el02():
    body = _body(MACROEXE, "Sub CreateObject(EL as XMLElement")
    assert "if el02 = nil then" in body
    assert_skip_after(body, "if el02 = nil then", "CreateObject")
    assert_guard_before_deref(body, "if el01 = nil then", ["el01.childcount", "el01.child("], "CreateObject")

def test_createobject_second_loop_guards_el01():
    body = _body(MACROEXE, "Sub CreateObject(EL as XMLElement")
    pos = body.find("for i = 0 to el0.childcount-1")
    assert pos != -1, "CreateObject: second EL0 loop not found"
    tail = body[pos:pos + 800]
    assert "if el01 = nil then" in tail
    assert "real.append -1" in tail
    assert "continue" in tail or "return" in tail

def test_intersec_guard_order_and_currentcontent():
    body = _body(INTERSEC, "Sub Constructor(MExe as MacroExe")
    assert "if currentcontent = nil then" in body
    assert_guard_before_deref(body, "if mexe = nil then", ["mexe.getrealid"], "Intersec")
    assert_guard_before_deref(body, "if el1 = nil then", ["el1.firstchild", "el1.child("], "Intersec")
    ob = body.find("ob = currentcontent.theobjects")
    gm = body.find("if mexe = nil then")
    ge = body.find("if el1 = nil then")
    go = body.find("if ob = nil then")
    assert ob != -1 and gm != -1 and ge != -1 and go != -1
    assert gm < ob and ge < ob, "Intersec: ob assignment must come after MExe/EL1 guards"

def test_shapeconstruction_loop_guards_childcount():
    body = _body(SHAPECONST, "Sub Constructor(Mexe as MacroExe")
    assert "if el = nil then" in body
    pos = body.find("for i = 0 to currentshape.ncpts-1")
    assert pos != -1, "ShapeConstruction: ncpts loop not found"
    tail = body[pos:pos + 900]
    assert "el.childcount" in tail
    assert "if el.child(i) = nil then" in tail or "xelement(el.child(i)) = nil" in tail or "elchild = nil" in tail

def test_prolonger_validates_side_before_dooperation():
    body = _body(PROLONGER, "Sub Constructor(MExe as MacroExe")
    assert "if rid = -1 then" in body
    assert "if selectedside = -1 then" in body
    g = body.find("if selectedside = -1 then")
    d = body.find("dooperation")
    assert g != -1 and d != -1 and g < d

def test_debuglog_on_skips():
    for marker in ("Sub ExecuteMacro(Temp as XMLElement", "Sub CreateObject(EL as XMLElement", "Sub CreateTransfo(EL as XMLElement"):
        body = _body(MACROEXE, marker)
        assert "system.debuglog" in body, f"{marker}: missing System.DebugLog skip trace"

def test_sentinel_minus1_kept_with_check():
    body = _body(MACROEXE, "Function GetRealSide(n as integer) as integer")
    assert "if idx = -1 then" in body
    assert "return -1" in body
    pro = _body(PROLONGER, "Sub Constructor(MExe as MacroExe")
    assert "if selectedside = -1 then" in pro

if __name__ == "__main__":
    test_getrealid_returns_minus1_on_unknown()
    test_getrealside_returns_minus1_on_unknown()
    test_createobject_guards_unknown_refs()
    test_shapeconstruction_guards_unknown_id()
    test_paraperp_guards_unknown_id()
    test_divide_guards_unknown_id()
    test_duplicate_guards_unknown_id()
    test_gcconstruction_guards_unknown_id()
    test_prolonger_guards_unknown_id()
    test_intersec_guards_unknown_id()
    test_appliquertsf_guards_unknown_id()
    test_fixpconstruction_guards_unknown_id()
    test_createobject_guards_post_construction_derefs()
    test_createtransfo_guards_unknown_refs()
    test_execute_macro_guards_temp_el_nil()
    test_createifmacs_guards_temp_el_nil()
    test_createifmacobject_guards_el_childcount()
    test_createobject_obinit_loop_guards_el02()
    test_createobject_second_loop_guards_el01()
    test_intersec_guard_order_and_currentcontent()
    test_shapeconstruction_loop_guards_childcount()
    test_prolonger_validates_side_before_dooperation()
    test_debuglog_on_skips()
    test_sentinel_minus1_kept_with_check()
    print("OK")
