"""Static regression test for MacroExe.GetShape selection flow.

Issue #81: Macro execution remained stuck in object selection mode because
MacroExe.GetShape had premature nil-guards (`if operation = nil`, `if visible = nil`)
placed BEFORE `sh = operation.getshape(p)`.
Since `visible` is a property populated only inside `Operation.GetShape(p)`
(`visible = Objects.findobject(p)`), checking `visible = nil` before the call
caused GetShape to always return nil, preventing SetItem, NextItem, and FinishedSelecting
from ever being reached.
"""

from pathlib import Path

BASE = Path(__file__).resolve().parent.parent.parent
MACROEXE = BASE / "Macros Classes/MacroExe.xojo_code"


def extract_method(text: str, marker: str, end_marker: str = "#tag EndMethod") -> str:
    low = text.lower()
    start = low.find(marker.lower())
    if start == -1:
        raise AssertionError(f"method marker not found: {marker!r}")
    end = low.find(end_marker.lower(), start)
    if end == -1:
        raise AssertionError(f"end marker not found after method: {marker!r}")
    return text[start:end]


def test_macroexe_getshape_calls_super_before_visible_checks():
    text = MACROEXE.read_text(encoding="utf-8")
    body = extract_method(text, "Function GetShape(p as BasicPoint) As shape").lower()

    # Must NOT have premature guards before calling operation.getshape(p)
    assert "if operation = nil" not in body, "operation is class name, not an instance variable"
    
    op_call = body.find("operation.getshape(p)")
    assert op_call != -1, "GetShape must call operation.getshape(p)"

    # visible checks must only occur AFTER operation.getshape(p)
    first_visible = body.find("visible")
    assert first_visible > op_call, "visible is populated by operation.getshape(p), so checks must follow it"

    # Must reset invalid iobj to avoid OutOfBoundsException after visremove
    assert "iobj = 0" in body
    assert "sh = visible.item(iobj)" in body
