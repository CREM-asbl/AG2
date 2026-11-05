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
    assert "self.mousecursor" in block, "TextWindow Opening: Self.MouseCursor non force (realisation GTK curseur fenetre nil)"

def test_wait_cursors_guarded_on_linux():
    for path in [WIND, WORK]:
        text = pathlib.Path(path).read_text(encoding="utf-8")
        low = text.lower()
        if "cursors.wait" not in low:
            continue
        assert "#if targetlinux" in low, "Wait non garde TargetLinux"
        assert "standardpointer" in low, "pas de fallback StandardPointer pour Wait Linux"

def test_textwindow_reasserts_cursor_post_show():
    text = TEXT.read_text(encoding="utf-8")
    low = text.lower()
    assert "sub activated()" in low, "TextWindow: pas d'event Activated (curseur pre-show jamais reaffirme)"
    blk = low.split("sub activated()", 1)[1].split("end sub", 1)[0]
    assert "#if targetlinux" in blk, "Activated: pas de garde TargetLinux"
    assert "standardpointer" in blk, "Activated: pas de fallback StandardPointer"
    assert "self.mousecursor" in blk, "Activated: Self.MouseCursor non force"
    assert "ef.mousecursor" in blk, "Activated: EF.MouseCursor non reaffirme"

def test_textwindow_defers_afficher_post_show_on_linux():
    text = TEXT.read_text(encoding="utf-8")
    low = text.lower()
    assert "maffiche" in low, "TextWindow: pas de flag mAffiche (Afficher pre-show realise I-beam GDK nul)"
    opening = low.split("sub opening()", 1)[1].split("end sub", 1)[0]
    assert "afficher" not in opening.replace("#else", "").split("#if targetlinux")[0] or \
        "#else" in opening, "TextWindow Opening: Afficher appele pre-show sans garde Linux"
    activated = low.split("sub activated()", 1)[1].split("end sub", 1)[0]
    assert "afficher" in activated and "maffiche" in activated, \
        "TextWindow Activated: Afficher non differe post-show"


if __name__ == "__main__":
    test_setcross_guards_custom_cursors()
    test_setcross_bypasses_custom_cursors_on_linux()
    test_textwindow_forces_standard_pointer_on_linux()
    test_wait_cursors_guarded_on_linux()
    test_textwindow_reasserts_cursor_post_show()
    print("OK: setcross cursor guards")

CUST = pathlib.Path("Windows/CustomCanvas1.xojo_code")

def test_afficher_reasserts_cursor_after_text_assign_on_linux():
    text = TEXT.read_text(encoding="utf-8")
    low = text.lower()
    start = low.index("sub afficher()")
    body = low[start:low.index("end sub", start)]
    last_text = body.rfind("ef.text")
    last_cursor = body.rfind("ef.mousecursor")
    assert last_text != -1 and last_cursor != -1, "Afficher: EF.Text ou EF.MouseCursor introuvable"
    assert last_cursor > last_text, \
        "Afficher: EF.MouseCursor force AVANT dernier EF.Text (GTK re-realise I-beam nul au survol canvas)"
    tail = body[last_text:]
    assert "#if targetlinux" in tail and "standardpointer" in tail, \
        "Afficher: pas de re-force StandardPointer TargetLinux apres assignations EF.Text"

def test_paint_does_not_refresh_textwindow_unconditionally():
    text = CUST.read_text(encoding="utf-8")
    low = text.lower()
    assert "textwindow.afficher" in low, "CustomCanvas1: appel TextWindow.Afficher introuvable"
    idx = low.find("textwindow.afficher")
    seg = low[max(0, idx-600):idx]
    assert "mtextrefresh" in seg or "besoin" in seg or "dirty" in seg or "refresh" in seg.split("if")[-1], \
        "CustomCanvas1.Paint: TextWindow.Afficher appele a chaque frame (re-realise curseur GTK nul au survol)"

def test_afficher_early_return_reasserts_cursor_on_linux():
    text = TEXT.read_text(encoding="utf-8")
    low = text.lower()
    start = low.index("sub afficher()")
    body = low[start:low.index("end sub", start)]
    assert "if sc <> nil" in body, "Afficher: garde early-return sc<>nil introuvable"
    early = body.split("if sc <> nil", 1)[1].split("end if", 1)[0]
    assert "ef.text" in early and "return" in early, \
        "Afficher: early-return sc<>nil sans EF.Text (site inattendu)"
    assert "#if targetlinux" in early and "standardpointer" in early, \
        "Afficher: early-return sc<>nil assigne EF.Text sans re-force StandardPointer TargetLinux (GDK nul :147-149)"
    assert "ef.mousecursor" in early, \
        "Afficher: early-return sc<>nil sans EF.MouseCursor (I-beam realise au show/survol)"
