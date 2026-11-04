"""Static guard test for issue #72 (MacroExe replay crash).

Crash chain: MultipleSelectOperation.MouseDown -> MacroExe.DoOperation ->
MacroExe.ExecuteMacro -> MacroExe.CreateObject -> ShapeConstruction.Constructor ->
MExe.GetRealId -> RuntimeException "ID not found".

A macro referencing an unknown MacId (skipped/unsupported op, out-of-order
ref, init not SetItem'd) must not raise; replay must skip that shape safely.
"""

from pathlib import Path

MACROEXE = Path("Macros Classes/MacroExe.xojo_code")
SHAPECONST = Path("Operation Classes/MultipleSelect Operations/ShapeConstruction.xojo_code")
PARAPERP = Path("Operation Classes/MultipleSelect Operations/ParaperpConstruction.xojo_code")
DIVIDE = Path("Operation Classes/MultipleSelect Operations/Divide.xojo_code")
DUPLICATE = Path("Operation Classes/SelectAndDrag Operations/Duplicate.xojo_code")
GCCONST = Path("Operation Classes/SelectOperation/GCConstruction.xojo_code")
PROLONGER = Path("Operation Classes/SelectOperation/Prolonger.xojo_code")
INTERSEC = Path("Listes/Intersec Classes/Intersec.xojo_code")
APPLIQUERTSF = Path("Transformation classes/AppliquerTsf.xojo_code")
FIXPCONST = Path("Transformation classes/FixPConstruction.xojo_code")


def extract_method(text: str, marker: str, end_marker: str = "#tag EndMethod") -> str:
    start = text.lower().index(marker.lower())
    end = text.lower().index(end_marker.lower(), start)
    return text[start:end]


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
    body = extract_method(
        MACROEXE.read_text(encoding="utf-8"), "Sub CreateTransfo(EL as XMLElement"
    ).lower()
    assert "if el = nil then" in body
    assert "if el0 = nil then" in body
    assert "if rid = -1 then" in body
    assert "if supp = nil then" in body

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
    print("OK")
