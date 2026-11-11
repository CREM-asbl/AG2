"""Static test: FormsWindow integrated as embedded palette in WorkWindow.

No floating Window: FormsWindow must be a DesktopContainer embedded in
WorkWindow, with no Show/Close/Self.SetFocus calls (invalid on containers
and cause of the WSLg/X11 floating-window bug).
"""

from pathlib import Path

FORMS = Path("Windows/Formswindow.xojo_window")
WORK = Path("Windows/WorkWindow.xojo_window")
CONFIG = Path("Windows/ConfigWindow.xojo_window")


def test_forms_is_desktop_container():
    text = FORMS.read_text(encoding="utf-8")
    assert "Begin DesktopContainer Formswindow" in text
    assert "Begin DesktopWindow Formswindow" not in text


def test_no_floating_window_calls():
    text = FORMS.read_text(encoding="utf-8")
    lines = text.splitlines()
    for i, line in enumerate(lines, start=1):
        s = line.strip()
        assert s != "Show", f"line {i}: bare Show (floating Window call)"
        assert s != "Close", f"line {i}: bare Close (floating Window call)"
        assert s != "Self.SetFocus", f"line {i}: Self.SetFocus invalid on container"


def test_action_hides_via_visible():
    text = FORMS.read_text(encoding="utf-8")
    assert "Visible = False" in text
    assert "WorkWindow.MyCanvas1.SetFocus" in text


def test_adaptive_height_preserved():
    text = FORMS.read_text(encoding="utf-8")
    assert "newH" in text
    assert "contentSig" in text
    assert "height = newH" in text


def test_embedded_in_workwindow():
    text = WORK.read_text(encoding="utf-8")
    assert "Begin Formswindow FormsWindow" in text


def test_config_uses_relative_coords():
    text = CONFIG.read_text(encoding="utf-8")
    assert "WorkWindow.FormsWindow.setParams(1, index, true)" in text
    assert "WorkWindow.Left +" not in text
    for line in text.splitlines():
        if "FormsWindow" in line:
            assert "SetFocus" not in line, line


if __name__ == "__main__":
    test_forms_is_desktop_container()
    test_no_floating_window_calls()
    test_action_hides_via_visible()
    test_adaptive_height_preserved()
    test_embedded_in_workwindow()
    test_config_uses_relative_coords()
    print("OK: FormsWindow integrated palette guards present")
