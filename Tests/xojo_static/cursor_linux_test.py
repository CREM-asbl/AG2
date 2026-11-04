"""Spec #71 cursor Linux: assignations MouseCursor non gardees.

Erreurs runtime Xojo non fatales sous Linux a l'ouverture de TextWindow :
  Common/ClassLib/window.cpp:1092 / cursor->GetGdkCursor().Get()
Cause : `can.mousecursor = cross | whitecross` dans WorkWindow.setcross
assigne un curseur custom potentiellement Nil sous GTK Linux
(ressource curseur absente) -> dereference nil cote runtime.

Fix attendu : setcross garde chaque curseur custom (nil check +
fallback System.Cursors.StandardPointer + DebugLog), comportement
Windows/macOS inchange.
"""
from pathlib import Path
import pathlib

WORK = Path("Windows/WorkWindow.xojo_window")


def setcross_body() -> str:
    text = WORK.read_text(encoding="utf-8")
    low = text.lower()
    start = low.index("sub setcross()")
    end = low.index("end sub", start)
    return text[start:end]


def test_setcross_guards_custom_cursors():
    body = setcross_body()
    low = body.lower()
    assert "can.mousecursor = cross" in low or "can.mousecursor= cross" in low, \
        "setcross: assignation cross introuvable"
    assert "cross <> nil" in low or "cross is not nil" in low or \
        "nil" in low and "cross" in low, \
        "setcross: curseur custom 'cross' assigne sans nil check (GetGdkCursor Linux)"
    assert "whitecross <> nil" in low or "whitecross is not nil" in low, \
        "setcross: curseur custom 'whitecross' assigne sans nil check"
    assert "standardpointer" in low, \
        "setcross: pas de fallback StandardPointer si curseur custom nil"


def test_setcross_bypasses_custom_cursors_on_linux():
    body = setcross_body()
    low = body.lower()
    assert "#if targetlinux" in low, \
        "setcross: pas de bypass TargetLinux (nil check insuffisant: handle GDK nul sous Linux)"
    linux_block = low.split("#if targetlinux", 1)[1].split("#endif", 1)[0]
    assert "standardpointer" in linux_block, \
        "setcross: bloc TargetLinux sans fallback StandardPointer"
    assert "cross" not in linux_block.replace("standardpointer", "").replace(
        "curseur", "").replace("custom", "") or \
        "can.mousecursor = cross" not in linux_block, \
        "setcross: bloc TargetLinux assigne encore curseur custom"


TEXT = pathlib.Path("Windows/TextWindow.xojo_window")
WIND = pathlib.Path("Other Classes/WindContent.xojo_code")

def test_textwindow_forces_standard_pointer_on_linux():
    text = TEXT.read_text(encoding="utf-8")
    low = text.lower()
    assert "ef.mousecursor" in low, "TextWindow: aucun EF.MouseCursor (I-beam GTK implicite)"
    assert "#if targetlinux" in low, "TextWindow: pas de garde TargetLinux pour curseur EF"
    idx = low.find("#if targetlinux")
    block = low[idx:idx + 2000]
    assert "ef.mousecursor" in block and "standardpointer" in block, "TextWindow: bloc TargetLinux sans EF fallback"

def test_wait_cursors_guarded_on_linux():
    for path in [WIND, WORK]:
        text = pathlib.Path(path).read_text(encoding="utf-8")
        low = text.lower()
        if "cursors.wait" not in low:
            continue
        assert "#if targetlinux" in low, "Wait non garde TargetLinux"
        assert "standardpointer" in low, "pas de fallback StandardPointer pour Wait Linux"


if __name__ == "__main__":
    test_setcross_guards_custom_cursors()
    test_setcross_bypasses_custom_cursors_on_linux()
    test_textwindow_forces_standard_pointer_on_linux()
    test_wait_cursors_guarded_on_linux()
    print("OK: setcross cursor guards")
