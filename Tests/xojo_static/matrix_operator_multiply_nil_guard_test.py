"""Static nil-guard test for Matrix.Operator_Multiply (issue #82)."""

from pathlib import Path

BASE = Path(__file__).resolve().parent.parent.parent
MATRIX = BASE / "Matrices classes/Matrix.xojo_code"
TRANSFORMATION = BASE / "Transformation classes/Transformation.xojo_code"

def extract_method(text: str, marker: str, end_marker: str = "#tag EndMethod") -> str:
    start = text.index(marker)
    end = text.index(end_marker, start)
    return text[start:end]

def test_matrix_operator_multiply_basicpoint_guards_nil():
    text = MATRIX.read_text(encoding="utf-8")
    body = extract_method(text, "Function Operator_Multiply(v as BasicPoint) As BasicPoint")
    assert "if v = nil then" in body, "Operator_Multiply(BasicPoint): missing v nil guard"
    assert body.index("if v = nil then") < body.index("return new BasicPoint")
    assert "if v1 = nil then" in body, "Operator_Multiply(BasicPoint): missing v1 nil guard"
    assert "if v2 = nil then" in body, "Operator_Multiply(BasicPoint): missing v2 nil guard"
    assert "if v3 = nil then" in body, "Operator_Multiply(BasicPoint): missing v3 nil guard"

def test_transformation_appliquerextrectrl_guards_nil_extre():
    text = TRANSFORMATION.read_text(encoding="utf-8")
    body = extract_method(text, "Sub AppliquerExtreCtrl(s1 as shape, s2 as shape)")
    assert "if M = nil then" in body, "AppliquerExtreCtrl: missing M nil guard"
    assert "if s1.coord.extre(i) <> nil then" in body, "AppliquerExtreCtrl: missing extre nil guard"

if __name__ == "__main__":
    test_matrix_operator_multiply_basicpoint_guards_nil()
    test_transformation_appliquerextrectrl_guards_nil_extre()
    print("OK: issue #82 nil guards present")
