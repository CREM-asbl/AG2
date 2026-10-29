"""Static bounds-guard test for issue #61 (Shape.AddToFigure OOB)."""

from pathlib import Path

FIGURE = Path("Figures classes/Figure.xojo_code")
SHAPE = Path("Shape Classes/Shapes/Shape.xojo_code")


def extract_method(text, marker, end_marker="#tag EndMethod"):
    start = text.index(marker)
    end = text.index(end_marker, start)
    return text[start:end]


def test_fusionsubfigs_guards():
    text = FIGURE.read_text(encoding="utf-8")
    body = extract_method(text, "Function fusionsubfigs")
    assert "if p = nil then" in body
    assert "p.pointsur.count >= 2" in body
    assert "(p.forme = 2) and (f2.shapes.getposition(p.pointsur.item(0))" not in body


def test_phase0_nil_guards():
    text = FIGURE.read_text(encoding="utf-8")
    body = extract_method(text, "Sub Phase0choixpointsfixes")
    assert body.count("if p = nil then") >= 2
    assert "Continue For" in body
    assert "p.pointsur.count >= 2" in body


def test_addtofigure_nil_fallback():
    text = SHAPE.read_text(encoding="utf-8")
    body = extract_method(text, "Sub AddToFigure(ff as figure, idf as integer)")
    assert "fig = List0.concat" in body
    assert "if fig = nil then" in body


if __name__ == "__main__":
    test_fusionsubfigs_guards()
    test_phase0_nil_guards()
    test_addtofigure_nil_fallback()
    print("OK")
