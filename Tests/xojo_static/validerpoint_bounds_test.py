"""Static bounds-guard test for issue #49.

Xojo has no test runner here, so this script statically verifies that
every unguarded array index in the crash chain
Point.UpdateShape -> updateconstructedpoints -> Point.UpdateShape
-> Intersec.validerpoint is guarded against OutOfBoundsException.
"""

from pathlib import Path

INTERSEC = Path("Listes/Intersec Classes/Intersec.xojo_code")
POINT = Path("Shape Classes/Shapes/Point.xojo_code")


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


def test_validerpoint_bounds_guards():
    text = INTERSEC.read_text(encoding="utf-8")
    body = extract_method(text, "Sub validerpoint(pt as point")
    assert_guard_before(body, "i > nlig or j > ncol", "bptinters(i,j)", "validerpoint")
    assert_guard_before(body, "i < 0 or j < 0", "bptinters(i,j)", "validerpoint")


def test_replacer_bounds_guards():
    text = INTERSEC.read_text(encoding="utf-8")
    p1 = extract_method(text, "Sub replacerphase1(pt as point)")
    assert_guard_before(p1, "h > nlig or k > ncol", "val(h,k)", "replacerphase1")
    p2 = extract_method(text, "Sub replacerphase2(pt as point)")
    assert_guard_before(p2, "h > nlig or k > ncol", "bezet(h,k)", "replacerphase2")
    assert_guard_before(p2, "i1 > nlig or j1 > ncol", "val(i1,j1)", "replacerphase2")


def test_nearest_addpoint_locatepoint_guards():
    text = INTERSEC.read_text(encoding="utf-8")
    near = extract_method(text, "Function nearest(pt as point")
    assert_guard_before(near, "h > nlig or k > ncol", "val(h,k)", "nearest")
    add = extract_method(text, "Sub Addpoint(p as point)")
    assert_guard_before(add, "i1 > nlig or j1 > ncol", "bezet(i1,j1)", "Addpoint")
    loc = extract_method(text, "Function locatepoint(p as BasicPoint)")
    assert_guard_before(loc, "i1 > nlig or j1 > ncol", "bezet(i1,j1)", "locatepoint")
    st = extract_method(text, "Sub setlocation(p as point")
    assert_guard_before(st, "i > nlig or j > ncol", "bptinters(i,j)", "setlocation")


def test_point_location_data_guards():
    text = POINT.read_text(encoding="utf-8")
    upd = extract_method(text, "Sub UpdateShape()")
    assert_guard_before(upd, "ubound(location) >= 0", "location(0)", "UpdateShape")
    ucp = extract_method(text, "Sub updateconstructedpoints()")
    assert_guard_before(
        ucp, "ubound(s.constructedby.data) >= 0",
        "s.constructedBy.data(0)", "updateconstructedpoints",
    )


if __name__ == "__main__":
    test_validerpoint_bounds_guards()
    test_replacer_bounds_guards()
    test_nearest_addpoint_locatepoint_guards()
    test_point_location_data_guards()
    print("OK: all #49 bounds guards present")
