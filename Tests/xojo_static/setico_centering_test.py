"""Static centering test for WorkWindow.SetIco polygon branch (issue #42).

Xojo has no test runner in this environment, so this script statically
verifies that the polygon-icon centering formula in SetIco centers every
bounding box (including stars with ury > 0) instead of assuming ury = 0.

Doubling model (Paint does `g.drawobject ico, ico.x, ico.y`):
  center = 2*pos + taille*(dl + ur)/2 must equal button center (h/2, h/2).
"""

from pathlib import Path

WINDOW = Path("Windows/WorkWindow.xojo_window")
SETICO_START = "Sub SetIco(Fam as integer, Form As integer)"
POLY_MARKER = "cas des polygonestd"
CIRCLE_MARKER = "cas des cerclesstd"

# (dlx, dly, urx, ury) unrotated bounding boxes from .std resources.
BOXES = {
    "Carre": (0.0, -1.0, 1.0, 0.0),
    "E4": (0.0, -0.5, 1.366, 0.866),
    "E5": (0.0, -0.588, 1.618, 0.951),
    "E6": (0.0, -0.289, 1.0, 0.866),
    "E8": (-0.707, -2.414, 1.707, 0.0),
}


def extract_polygon_branch(text: str) -> str:
    start = text.index(SETICO_START)
    poly = text.index(POLY_MARKER, start)
    circle = text.index(CIRCLE_MARKER, poly)
    return text[poly:circle]


def test_setico_polygon_centering():
    text = WINDOW.read_text(encoding="utf-8")
    branch = extract_polygon_branch(text)

    # dlx correction must be unconditional (stars can have dlx >= 0).
    assert "if dlx < 0" not in branch.replace("  ", " ").lower() or \
        "if dlx < 0 then" not in branch, \
        "dlx correction still conditional on dlx < 0"
    assert "-dlx*taille" in branch.replace(" ", ""), \
        "x formula missing unconditional -dlx*taille correction"

    # y must subtract (center) instead of adding haut.
    flat = branch.replace(" ", "")
    assert "(h-haut*taille)/4" in flat, \
        "y formula must center: (h-haut*taille)/4"
    assert "-dly*taille" in flat, \
        "y formula missing -dly*taille correction"

    # Numeric check: doubling-model center must equal button center.
    h = 50.0
    for name, (dlx, dly, urx, ury) in BOXES.items():
        larg = urx - dlx
        haut = ury - dly
        taille = 0.8 * h / max(larg, haut)
        x = (h - larg * taille) / 4 - dlx * taille / 2
        y = (h - haut * taille) / 4 - dly * taille / 2
        cx = 2 * x + taille * (dlx + urx) / 2
        cy = 2 * y + taille * (dly + ury) / 2
        assert abs(cx - h / 2) < 1e-9, f"{name}: cx={cx}"
        assert abs(cy - h / 2) < 1e-9, f"{name}: cy={cy}"

    print("OK: SetIco polygon branch centers all bounding boxes")


if __name__ == "__main__":
    test_setico_polygon_centering()
