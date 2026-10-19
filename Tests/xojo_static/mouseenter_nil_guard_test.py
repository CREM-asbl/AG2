"""Static nil-guard test for WorkWindow.PushButton1_MouseEnter.

Xojo has no test runner in this environment, so this script statically
verifies that every potentially-nil dereference in the MouseEnter handler
is guarded against NilObjectException (issue #52).
"""

from pathlib import Path

WINDOW = Path("Windows/WorkWindow.xojo_window")
MARKER_START = "\t\tSub MouseEnter()"
MARKER_END = "\tEnd Sub"


def extract_mouseenter(text: str) -> str:
    start = text.index(MARKER_START)
    end = text.index(MARKER_END, start)
    return text[start:end]


def test_mouseenter_nil_guards():
    text = WINDOW.read_text(encoding="utf-8")
    handler = extract_mouseenter(text)

    # currentcontent nil guard
    assert "if currentcontent = nil then" in handler
    # currentoperation nil guard
    assert "if currentcontent.currentoperation <> nil then" in handler
    # currentshape nil guard
    assert "if currentcontent.currentoperation.currentshape <> nil then" in handler
    # currentop zero guard
    assert "if currentcontent.currentop = 0  then" in handler
    # OpToCancel nil guard
    assert "if  EL = nil then" in handler
    # EL1 nil guard
    assert "if  EL1 = nil then" in handler
    # EL2 nil guard (issue #52 fix: EL2.firstchild when EL2 = nil)
    assert "if EL2 <> nil then" in handler
    # EL3 nil guard
    assert "if EL3 <> nil then" in handler
    # selshape nil guard
    assert "if selshape <> nil then" in handler
    # s nil guard
    assert "if s <> nil then" in handler

    # Ensure EL2.firstchild is only reached inside the EL2 <> nil guard
    el2_lines = [l for l in handler.splitlines() if "EL2.firstchild" in l]
    assert el2_lines, "EL2.firstchild dereference missing"
    for line in el2_lines:
        assert line.lstrip().startswith("EL3 = XMLElement(EL2.firstchild)"), line
    assert handler.index("if EL2 <> nil then") < handler.index("EL2.firstchild")

    print("OK: all nil guards present in PushButton1_MouseEnter")


if __name__ == "__main__":
    test_mouseenter_nil_guards()
