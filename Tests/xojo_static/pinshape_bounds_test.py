"""Static bounds test for Lacet.pInShape OutOfBounds (ray/circle intersections)."""
from pathlib import Path
LACET = Path("Shape Classes/Lacets/Lacet.xojo_code")
def extract_method(text, marker, end_marker="#tag EndMethod"):
    s = text.index(marker); e = text.index(end_marker, s); return text[s:e]
def test_pinshape_bounds_bp():
    body = extract_method(LACET.read_text(encoding="utf-8"), "Function pInShape(P as BasicPoint)")
    assert "for j = 1 downto 0" not in body, "hardcoded 1..0 OOB when bp<2"
    assert "for j = n-1 downto 0" not in body, "n-1 loop OOB after nil removal"
    assert body.count("for j = UBound(bp) downto 0") >= 2, "both loops must use UBound(bp)"
if __name__ == "__main__":
    test_pinshape_bounds_bp(); print("OK")
