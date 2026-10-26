"""Static nil-guard test for Shape.Swap (montrer-cacher, issue #44)."""

from pathlib import Path

SHAPE = Path("Shape Classes/Shapes/Shape.xojo_code")
REPERE = Path("Shape Classes/Shapes/Repere.xojo_code")

def extract_method(text, marker, end_marker="#tag EndMethod"):
    start = text.index(marker)
    end = text.index(end_marker, start)
    return text[start:end]

def test_swap_nil_guards():
    text = SHAPE.read_text(encoding="utf-8")
    body = extract_method(text, "Sub Swap()")
    assert "if childs(i) = nil then" in body
    assert "Continue For" in body
    assert "\n\t\t      continue\n" not in body
    assert "childs(i).parents <> nil" not in body
    assert "constructedshapes <> nil" not in body
    assert "macconstructedshapes <> nil" not in body
    assert "if s <> nil then" in body
    assert "if s.getindexpoint(childs(i)) <> -1 then" in body
    assert "ubound(s.constructedshapes) <> -1" in body
    assert "ubound(s.macconstructedshapes) <> -1" in body
    assert "if t and childs(i).pointsur <> nil then" in body

def test_repere_hidden_not_forced():
    text = REPERE.read_text(encoding="utf-8")
    ctor = extract_method(text, "Sub Constructor(ol as ObjectsList, El as XMLElement)")
    assert "Hidden = true" not in ctor
    xml = extract_method(text, "Function XMLPutInContainer(Doc as XMLDocument) As XMLElement")
    assert 'if Hidden then' in xml

if __name__ == "__main__":
    test_swap_nil_guards()
    test_repere_hidden_not_forced()
    print("OK")