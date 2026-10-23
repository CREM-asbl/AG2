"""Static side-index guard test for issue #50.

Crash chain: ShapeConstruction.AdjustMagnetism -> Point.adjustinter
-> Intersec.Addpoint -> Point.PutOn(s) -> OutOfBoundsException.
Root cause family: `k = s.pointonside(bpt)` returns -1 when off-border,
then `s.getside(k)` / `GetBibSide(k)` index OOB, or nil `dr` deref.
"""

from pathlib import Path

POINT = Path("Shape Classes/Shapes/Point.xojo_code")
BIB = Path("Calculation classes/BiBPoint.xojo_code")
INTERSEC = Path("Listes/Intersec Classes/Intersec.xojo_code")
LACET = Path("Shape Classes/Lacets/Lacet.xojo_code")
SHAPE = Path("Shape Classes/Shapes/Shape.xojo_code")


def extract_method(text: str, marker: str, end_marker: str = "#tag EndMethod") -> str:
    start = text.index(marker)
    end = text.index(end_marker, start)
    return text[start:end]


def assert_guard_before(body: str, guard: str, access: str, method: str):
    assert guard in body, f"{method}: missing guard `{guard}`"
    assert access in body, f"{method}: access `{access}` missing?"
    assert body.index(guard) < body.index(access), (
        f"{method}: guard `{guard}` must precede `{access}`"
    )


def test_puton_guards_side_index():
    body = extract_method(POINT.read_text(encoding="utf-8"), "Sub PutOn(s as shape)")
    assert_guard_before(body, "k = s.pointonside(bpt)", "s.getside(k)", "PutOn(s)")
    assert "k = -1" in body or "k < 0" in body or "k > -1" in body or "k >= 0" in body, (
        "PutOn(s): missing k=-1 check after pointonside"
    )
    assert "dr = nil" in body or "dr <> nil" in body or "dr = s.getside" in body, (
        "PutOn(s): getside result unchecked"
    )


def test_specialputon_nil_bib_guard():
    bib = BIB.read_text(encoding="utf-8")
    droite = extract_method(bib, "Function ComputeDroiteFirstIntersect(S as Shape, k as integer")
    assert "dr = nil" in droite or "dr <> nil" in droite, (
        "ComputeDroiteFirstIntersect(k): missing nil dr guard before dr.firstp"
    )
    circle = extract_method(bib, "Function ComputeCircleFirstIntersect(S as Shape, k as integer")
    assert "dr = nil" in circle or "dr <> nil" in circle, (
        "ComputeCircleFirstIntersect(k): missing nil dr guard before dr.firstp"
    )


def test_nearest_branch_memory_clamps_k():
    body = extract_method(INTERSEC.read_text(encoding="utf-8"), "Function nearest(pt as point")
    assert "then k = 0" in body, "nearest: missing k=0 clamp"
    # second clamp must target k alone, not repeat h condition verbatim twice
    first = body.index("then h = 0")
    second = body.index("then k = 0")
    assert first != second, "nearest: h/k clamps collapsed"
    between = body[first:second]
    assert "k < 0" in between or "k > ncol" in between, (
        "nearest: second clamp must test k bounds"
    )


def test_lacet_getside_bounds_first():
    body = extract_method(LACET.read_text(encoding="utf-8"), "Function GetSide(i as integer)")
    # Xojo `and` does not short-circuit: bounds must be a nested if, not reordered `and`
    assert_guard_before(body, "i < npts", "coord.curved(i)", "Lacet.GetSide")


def test_shape_getbibside_bounds():
    body = extract_method(SHAPE.read_text(encoding="utf-8"), "Function GetBibSide(i as integer)")
    assert "i > -1" in body or "i >= 0" in body or "i < 0" in body, (
        "Shape.GetBibSide: missing lower-bound guard before coord.tab(i)"
    )
    assert "npts" in body or "ubound" in body or "taille" in body, (
        "Shape.GetBibSide: missing upper-bound guard before coord.tab(i)"
    )


def test_puton_variants_reject_minus_one():
    text = POINT.read_text(encoding="utf-8")
    bande = extract_method(text, "Sub PutOnBande(s as Bande)")
    assert "-1" in bande, "PutOnBande: missing -1 guard before GetBibSide(numside(n))"
    secteur = extract_method(text, "Sub PutOnSecteur(s as secteur)")
    assert "-1" in secteur, "PutOnSecteur: missing -1 guard before Points(numside(n)/2+1)"


def test_compute_firstintersect_point_overloads_guard():
    bib = BIB.read_text(encoding="utf-8")
    droite_p = extract_method(bib, "Function ComputeDroiteFirstIntersect(S as Shape, P as Point)")
    assert "-1" in droite_p, (
        "ComputeDroiteFirstIntersect(P): missing -1 check after PointOnSide"
    )
    assert "BiB = nil" in droite_p or "Bib = nil" in droite_p, (
        "ComputeDroiteFirstIntersect(P): missing nil BiB guard (Bande/Secteur)"
    )
    assert "if r1 = 1000" in droite_p, (
        "ComputeDroiteFirstIntersect(P): Secteur must test r1, not r"
    )
    circle_p = extract_method(bib, "Function ComputeCircleFirstIntersect(S as Shape, P as Point)")
    assert "-1" in circle_p, (
        "ComputeCircleFirstIntersect(P): missing -1 check after pointonside"
    )


def test_puton_bipoint_circle_polyg_reject_minus_one():
    text = POINT.read_text(encoding="utf-8")
    for marker in (
        "Sub PutOnBiPoint(s as Bipoint)",
        "Sub PutOnCircle(s as circle)",
        "Sub PutOnPolyg(pol as Polygon)",
    ):
        body = extract_method(text, marker)
        assert "n = -1" in body or "n < 0" in body, (
            f"{marker}: missing n=-1 guard after getposition"
        )


if __name__ == "__main__":
    test_puton_guards_side_index()
    test_specialputon_nil_bib_guard()
    test_nearest_branch_memory_clamps_k()
    test_lacet_getside_bounds_first()
    test_shape_getbibside_bounds()
    test_puton_variants_reject_minus_one()
    test_compute_firstintersect_point_overloads_guard()
    test_puton_bipoint_circle_polyg_reject_minus_one()
    print("OK: all #50 side-index guards present")
