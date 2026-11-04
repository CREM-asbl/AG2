"""Spec #71 --no-splash segfault: bypass skips modal init.

Modal path sets via InitWindow clicks: Config.setMenu+save, Config.user/
username/pwok, PopupMenu selection. Bypass (--no-splash) jumps straight to
ChargerConfig + WorkWindow.Show, so WorkWindow.Opening/InitParams/NewContent
run with defaults only. Crash suspects (verified in code):

- InitParams uses screen(0).width/height unguarded -> headless Linux
  (ScreenCount=0) raises OutOfBounds/NilObject before CreateWindow.
- Opening chains MenuMenus.Child("EditMenu").Child("EditCopy") unguarded.
- NewContent chains MenuBar.Child("Fenetres") unguarded (x2 + AddMenu).
- CopyMenuBar chains menubar.Child("PrefsMenu")... unguarded.
- GetMenuItem chains MenuMenus.Child().Child() unguarded (Configuration
  twin is guarded, WorkWindow copy is not).
- MyCanvas.Readdblclicktime (called by MyCanvas.Open at window show):
  gtk_settings_get_default() can return nil headless; g_object_get(nil,..)
  dereferences NULL -> SIGSEGV (matches RC139 ~2.7s after "splash skipped").
- MyCanvas.Resize uses Screen(0).Depth unguarded.
- Bypass never sets Config.user/username/Menu defaults (modal does).

Acceptance: this file passes, 47 existing tests stay green.
"""
from pathlib import Path

APP = Path("Other Classes/App.xojo_code")
WORK = Path("Windows/WorkWindow.xojo_window")
CANVAS = Path("Windows/MyCanvas.xojo_code")


def block(path: Path, marker: str) -> str:
    text = path.read_text(encoding="utf-8")
    low = text.lower()
    start = low.index(marker.lower())
    ends = [
        idx
        for end in ("#tag endmethod", "#tag endevent")
        if (idx := low.find(end, start)) != -1
    ]
    if not ends:
        raise AssertionError(f"no block end after {marker!r}")
    return text[start:min(ends)].lower()


def test_initparams_guards_nil_screen():
    body = block(WORK, "Sub InitParams()")
    assert "screen(0)" in body
    assert "screencount" in body, \
        "InitParams: screen(0) sans guard ScreenCount -> headless crash"


def test_opening_guards_nil_menu():
    body = block(WORK, "Sub Opening()")
    assert "editcopy" in body
    assert body.count("<> nil") >= 1 or " = nil" in body, \
        "Opening: MenuBar/MenuMenus.Child chaine sans nil guard"


def test_newcontent_guards_nil_fenetres():
    body = block(WORK, "Sub NewContent(")
    assert "fenetres" in body
    assert "<> nil" in body or "= nil" in body, \
        "NewContent: MenuBar.Child(Fenetres) sans nil guard"


def test_copymenubar_guards_nil_prefs():
    body = block(WORK, "Sub CopyMenuBar()")
    assert "prefsmenu" in body
    assert "<> nil" in body or "= nil" in body, \
        "CopyMenuBar: menubar.Child(PrefsMenu)... sans nil guard"


def test_getmenuitem_guards_nil():
    body = block(WORK, "Function GetMenuItem(")
    assert "child(" in body
    assert "nil" in body, \
        "GetMenuItem: MenuMenus.Child().Child() sans nil guard"


def test_readdblclicktime_guards_nil_gtk():
    body = block(CANVAS, "Sub Readdblclicktime()")
    assert "gtk_settings_get_default" in body
    assert "nil" in body, \
        "Readdblclicktime: gtk_settings_get_default() peut rendre nil headless"


def test_nosplash_sets_config_defaults():
    body = block(APP, "Sub Opening()")
    assert "--no-splash" in body
    assert "splash skipped" in body
    assert "config.username" in body or "setuser" in body, \
        "Bypass: doit fixer Config.user/username defaults (modal le fait)"


if __name__ == "__main__":
    test_initparams_guards_nil_screen()
    test_opening_guards_nil_menu()
    test_newcontent_guards_nil_fenetres()
    test_copymenubar_guards_nil_prefs()
    test_getmenuitem_guards_nil()
    test_readdblclicktime_guards_nil_gtk()
    test_nosplash_sets_config_defaults()
    print("OK: nosplash crash guards")
