"""Static nil-guard test for issue #51.

Crash chain: WorkWindow.PushButton1_Pressed -> WorkWindow.Annuler
-> Operation.Annuler -> WindContent.UndoLastOperation
-> AppliquerTsf.UndoOperation -> NilObjectException.

Crash dump: `$tsf : nil`, `$i : 0`. `tsf = s.tsfi.item(num)` returns
nil when the stored NumTSF index is stale (Liste.element returns nil
out of bounds), then `tsf.removeconstructioninfos(s)` dereferences nil.
"""

from pathlib import Path

APPLIQUER = Path("Transformation classes/AppliquerTsf.xojo_code")


def extract_method(text: str, marker: str, end_marker: str = "#tag EndMethod") -> str:
    start = text.index(marker)
    end = text.index(end_marker, start)
    return text[start:end]


def undo_body() -> str:
    return extract_method(
        APPLIQUER.read_text(encoding="utf-8"), "Sub UndoOperation(Temp as XMLElement)"
    )


def test_undo_guards_nil_tsf():
    body = undo_body()
    assert "tsf = s.tsfi.item(num)" in body
    assert "tsf.removeconstructioninfos(s)" in body
    assert "if tsf <> nil then" in body, "UndoOperation: missing tsf nil guard"
    assert body.index("if tsf <> nil then") < body.index(
        "tsf.removeconstructioninfos(s)"
    ), "UndoOperation: tsf guard must precede removeconstructioninfos"


def test_undo_guards_nil_shape():
    body = undo_body()
    assert "s = objects.getshape(n)" in body
    assert "if s <> nil then" in body, "UndoOperation: missing shape nil guard"
    assert body.index("if s <> nil then") < body.index(
        "CurrentContent.removeobject s"
    ), "UndoOperation: shape guard must precede removeobject"

def test_undo_guards_nil_selectform():
    body = undo_body()
    assert "s = SelectForm(EL)" in body
    assert "if s <> nil and s.tsfi <> nil then" in body, "UndoOperation: missing SelectForm/tsfi nil guard"
    assert body.index("if s <> nil and s.tsfi <> nil then") < body.index(
        "tsf = s.tsfi.item(num)"
    ), "UndoOperation: head guard must precede tsfi.item"


if __name__ == "__main__":
    test_undo_guards_nil_tsf()
    test_undo_guards_nil_shape()
    print("OK: all #51 undo nil guards present")
