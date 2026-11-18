"""PR1 scope lock: subfigupdate inline + hasMatrix nil-safe, sweeps at base shape.

PR1 keeps: inlined select dispatch (no helper frame), hasMatrix nil-safe
nested guards, #if DebugBuild counters.
PR1 excludes: qqDone dedup, UpdatePtsSur overlap guard, Updateshapes(M) hoisting.
"""

from pathlib import Path

FIGURE = Path("Figures classes/Figure.xojo_code")


def extract_method(text: str, marker: str, end_marker: str = "#tag EndMethod") -> str:
    start = text.index(marker)
    end = text.index(end_marker, start)
    return text[start:end]


def test_pr1_subfigupdate_inline_nil_safe_no_qqdone():
    text = FIGURE.read_text(encoding="utf-8")
    body = extract_method(text, "Function subfigupdate() As Boolean")
    # Inlined select dispatch, zero helper frame
    assert "select case auto" in body
    assert "Function helper_getTransformationMatrix" not in text
    assert "M = helper_getTransformationMatrix()" not in body
    # hasMatrix nil-safe nested guards (Xojo-safe, no And/Or short-circuit)
    assert "hasMatrix" in body
    assert "M <> nil" in body
    assert "M.v1 <> nil" in body
    # PR1 excludes qqDone dedup: unconditional single QQupdateshapes fallback
    assert "qqDone" not in body
    assert "if not qqDone" not in body


def test_pr1_sweeps_base_shape_counters_kept():
    text = FIGURE.read_text(encoding="utf-8")
    # UpdatePtsSur at base shape: plain p.transform(M), no overlap guard
    sur = extract_method(text, "Sub UpdatePtsSur(M as Matrix)")
    assert "p.transform(M)" in sur
    assert "not p.modified" not in sur, "PR1 excludes UpdatePtsSur overlap guard"
    assert "allparentsqcq" not in sur, "PR1 excludes UpdatePtsSur overlap guard"
    # Updateshapes(M) at base shape: no nShapes/cur hoisting
    m = extract_method(text, "Sub Updateshapes(M as Matrix)")
    assert "shapes.item(i).updateshape(M)" in m
    assert "nShapes" not in m, "PR1 excludes Updateshapes(M) hoisting"
    assert "cur as shape" not in m, "PR1 excludes Updateshapes(M) hoisting"
    # Phase1 DebugBuild counters kept on both sweeps
    assert "dbgUpdateshapesMCalls" in m
    assert "dbgUpdatePtsSurCalls" in sur

if __name__ == "__main__":
    test_pr1_subfigupdate_inline_nil_safe_no_qqdone()
    test_pr1_sweeps_base_shape_counters_kept()
    print("OK: PR1 scope (inline + hasMatrix + base sweeps + counters)")
