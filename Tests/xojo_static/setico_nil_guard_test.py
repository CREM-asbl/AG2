"""Static nil-guard test for WorkWindow.SetIco startup crash.

SetIco is called from StdOutil.Opening per canvas before window Opening
completes, and from StdBoxRefresh covering all 4 families. At startup
Config, canvases, .std spec entries, stdcolor/Bordercolor entries, and
the embedded FormsWindow may still be nil -> NilObjectException.
"""

from pathlib import Path

WINDOW = Path("Windows/WorkWindow.xojo_window")


def method_body(text: str, marker: str) -> str:
    start = text.index(marker)
    end = text.index("#tag EndMethod", start)
    return text[start:end]


def event_body(text: str, start_marker: str, occurrence: int = 0) -> str:
    idx = -1
    for _ in range(occurrence + 1):
        idx = text.index(start_marker, idx + 1)
    end = text.index("#tag EndEvent", idx)
    return text[idx:end]


def test_setico_guards():
    body = method_body(WINDOW.read_text(encoding="utf-8"),
                       "Sub SetIco(Fam as integer, Form As integer)")
    assert "if Config = nil then" in body
    assert "if StdOutil(Fam) = nil then" in body
    assert "Fam < 0 or Fam > 3" in body
    assert "if specs = nil then" in body
    assert "if h <= 0 then" in body
    assert "if ico(fam) = nil then" in body
    assert "if Config.Bordercolor <> nil then" in body


def test_moved_guards_formswindow():
    text = WINDOW.read_text(encoding="utf-8")
    body = event_body(text, "Sub Moved()")
    assert "if FormsWindow <> nil then" in body


def test_stdbox_refresh_guards():
    body = method_body(WINDOW.read_text(encoding="utf-8"), "Sub StdBoxRefresh()")
    assert "if Config = nil then" in body
    assert "if StdBox = nil then" in body
    assert "if StdOutil(i) <> nil then" in body


def test_libbox_refresh_guards():
    body = method_body(WINDOW.read_text(encoding="utf-8"), "Sub LibBoxRefresh()")
    assert "if Config = nil then" in body
    assert "if LibBox = nil then" in body
    assert "if LibOutils(i) <> nil then" in body


def test_paint_guards_nil_ico():
    text = WINDOW.read_text(encoding="utf-8")
    body = event_body(text, "Sub Paint(index as Integer, g As Graphics, areas() As Rect)")
    assert "if Config = nil then" in body
    assert "index < 0 or index > 3" in body
    assert "elseif ico(index) <> nil then" in body


def test_header_and_embed_intact():
    text = WINDOW.read_text(encoding="utf-8")
    forms = Path("Windows/Formswindow.xojo_window").read_text(encoding="utf-8")
    assert text.startswith("#tag DesktopWindow")
    assert "Begin DesktopContainer Formswindow" in forms
    assert "Begin Formswindow FormsWindow" in text
