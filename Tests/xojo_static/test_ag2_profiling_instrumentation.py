"""Static test verifying Phase A profiling instrumentation is present in the hotspots.

Instrumentation is wrapped in #if DebugBuild ... #endif, so it is compiled out of
Release builds and does not change runtime behavior outside DebugBuild.
"""

from pathlib import Path

FIGURE = Path("Figures classes/Figure.xojo_code")
POINT = Path("Shape Classes/Shapes/Point.xojo_code")
OBJECTS = Path("Listes/ObjectsList.xojo_code")


def method_body(path: Path, marker: str, end_marker: str = "#tag EndMethod") -> str:
    text = path.read_text(encoding="utf-8")
    start = text.index(marker)
    end = text.index(end_marker, start)
    return text[start:end]


def test_figure_subfigupdate_instrumented():
    body = method_body(FIGURE, "Function subfigupdate() As Boolean")
    assert "#if DebugBuild then" in body
    assert "dbgSubfigUpdateCalls" in body
    assert "dbgSubfigUpdateTime" in body
    assert "Microseconds" in body
    assert 'System.DebugLog "AG2 profile Figure.subfigupdate' in body


def test_point_updateshape_instrumented():
    body = method_body(POINT, "Sub UpdateShape()")
    assert "#if DebugBuild then" in body
    assert "dbgPointUpdateShapeCalls" in body
    assert "dbgPointUpdateShapeTime" in body
    assert "Microseconds" in body
    assert 'System.DebugLog "AG2 profile Point.UpdateShape' in body


def test_objectslist_getshape_instrumented():
    body = method_body(OBJECTS, "Function GetShape(id as integer) As shape")
    assert "#if DebugBuild then" in body
    assert "dbgObjectsListGetShapeCalls" in body
    assert "dbgObjectsListGetShapeTime" in body
    assert "Microseconds" in body
    assert 'System.DebugLog "AG2 profile ObjectsList.GetShape' in body


if __name__ == "__main__":
    test_figure_subfigupdate_instrumented()
    test_point_updateshape_instrumented()
    test_objectslist_getshape_instrumented()
    print("OK: Phase A profiling instrumentation present in all hotspots")
