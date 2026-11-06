"""Spec #75: curseurs custom cross/whitecross supprimes (obsolètes).

Contexte : viseur précision canvas redondant avec highlight/entourage.
Sous Linux : handle GDK nul -> window.cpp:1092. Suppression totale :
StandardPointer partout, ressources curseurs retirees du projet.
"""
import pathlib
import re

ROOT = pathlib.Path(".")
WORK = pathlib.Path("Windows/WorkWindow.xojo_window")
PROJ = pathlib.Path("AG.xojo_project")

CODE_GLOBS = ("*.xojo_window", "*.xojo_code", "*.xojo_project")
WORD = re.compile(r"(?i)\b(cross|whitecross|setcross)\b")


def _code_files():
    files = []
    for pattern in CODE_GLOBS:
        files.extend(ROOT.rglob(pattern))
    return [f for f in files if ".git" not in f.parts]


def test_no_custom_cursor_reference_in_code():
    offenders = []
    for path in _code_files():
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        for i, line in enumerate(text.splitlines(), 1):
            if WORD.search(line):
                offenders.append(f"{path}:{i}: {line.strip()}")
    assert not offenders, (
        "references cross/whitecross/setcross restantes:\n" + "\n".join(offenders)
    )


def test_no_cursor_resource_in_project():
    text = PROJ.read_text(encoding="utf-8")
    assert WORD.search(text) is None, "AG.xojo_project contient encore Cursor=cross/whitecross"


def test_no_cursor_cur_file():
    curs = list(pathlib.Path("Resources").glob("*.cur"))
    assert curs == [], f"fichiers .cur restants: {curs}"


def test_canvas_uses_standard_pointer():
    text = WORK.read_text(encoding="utf-8")
    low = text.lower()
    assert "can.mousecursor = system.cursors.standardpointer" in low, \
        "WorkWindow: aucun can.MouseCursor = StandardPointer"
    assert "mycanvas1.mousecursor = system.cursors.standardpointer" in low, \
        "WorkWindow: aucun MyCanvas1.MouseCursor = StandardPointer"


CUSTOM = pathlib.Path("Windows/CustomCanvas1.xojo_code")


def test_no_textwindow_afficher_in_refreshbackground_linux():
    """RefreshBackground must NOT call TextWindow.Afficher on Linux.

    Each EF.Text assignment inside Afficher triggers GTK to realise
    the DesktopTextArea I-beam cursor.  Under Xwayland the GDK handle
    for I-beam can be NULL → window.cpp:1092 on every mouse-move.
    The Activated handler already updates the text when the user
    explicitly focuses TextWindow, so the RefreshBackground path is
    unnecessary on Linux.
    """
    text = CUSTOM.read_text(encoding="utf-8")
    # Extract only the Linux conditional block inside RefreshBackground
    # The TargetLinux block must NOT contain TextWindow.Afficher
    in_refresh = False
    in_linux_block = False
    depth = 0
    offending = []
    for i, line in enumerate(text.splitlines(), 1):
        stripped = line.strip()
        if "Sub RefreshBackground" in line:
            in_refresh = True
        if in_refresh and stripped == "End Sub":
            in_refresh = False
        if in_refresh and "#If TargetLinux" in line:
            in_linux_block = True
            depth = 1
            continue
        if in_linux_block:
            if stripped.startswith("#If "):
                depth += 1
            if stripped in ("#Endif", "#EndIf", "#End If"):
                depth -= 1
                if depth == 0:
                    in_linux_block = False
                    continue
            if stripped.startswith("#Else"):
                if depth == 1:
                    in_linux_block = False
                    continue
            if "TextWindow.Afficher" in line:
                offending.append(f"CustomCanvas1.xojo_code:{i}: {stripped}")
    assert not offending, (
        "RefreshBackground still calls TextWindow.Afficher inside "
        "#If TargetLinux block — causes window.cpp:1092 on hover:\n"
        + "\n".join(offending)
    )


def test_no_mtextrefresh_set_in_mousemove_linux():
    """MouseMove must not set mTextRefresh on Linux.

    Setting mTextRefresh=True on every MouseMove causes
    RefreshBackground to call TextWindow.Afficher on the next paint,
    triggering the GDK cursor error.  Since RefreshBackground no
    longer calls Afficher on Linux, the flag set is dead code.
    """
    text = CUSTOM.read_text(encoding="utf-8")
    in_mousemove = False
    in_linux = False
    depth = 0
    offending = []
    for i, line in enumerate(text.splitlines(), 1):
        stripped = line.strip()
        if "Sub MouseMove" in line:
            in_mousemove = True
        if in_mousemove and stripped == "End Sub":
            in_mousemove = False
        if in_mousemove and "#If TargetLinux" in line:
            in_linux = True
            depth = 1
            continue
        if in_linux:
            if stripped.startswith("#If "):
                depth += 1
            if stripped in ("#Endif", "#EndIf", "#End If"):
                depth -= 1
                if depth == 0:
                    in_linux = False
                    continue
            if stripped.startswith("#Else"):
                if depth == 1:
                    in_linux = False
                    continue
            if "mTextRefresh" in line:
                offending.append(f"CustomCanvas1.xojo_code:{i}: {stripped}")
    assert not offending, (
        "MouseMove sets mTextRefresh inside #If TargetLinux — "
        "dead code after RefreshBackground fix:\n"
        + "\n".join(offending)
    )


def test_workwindow_opening_forces_standard_pointer_linux():
    """WorkWindow.Opening must force StandardPointer on Linux before show.

    WorkWindow (and its canvas children) are realised during Show.  Under
    Xwayland a nil/default cursor handle can be NULL -> window.cpp:1092.
    Forcing StandardPointer in Opening (Linux-only) before maximize/Show
    avoids the GDK cursor error on the first paint/hover.
    """
    text = WORK.read_text(encoding="utf-8")
    in_opening = False
    body = []
    for line in text.splitlines():
        if "Sub Opening()" in line:
            in_opening = True
            body = []
            continue
        if in_opening:
            if line.strip() == "End Sub":
                break
            body.append(line)
    joined = "\n".join(body)
    assert "#If TargetLinux" in joined, \
        "WorkWindow.Opening: aucun bloc #If TargetLinux"
    assert "StandardPointer" in joined, \
        "WorkWindow.Opening: aucun curseur StandardPointer force sous Linux"

def test_workwindow_opening_cursor_not_on_nil_can_linux():
    """can is nil until InitParams(); forcing can.MouseCursor before is a crash.

    Regression guard for issue #71: `can` (global CustomCanvas1) is nil at
    startup and only assigned in InitParams() (`can = mycanvas1`).  The
    Linux cursor-forcing block must therefore run AFTER InitParams(), or
    guard `can` against nil, so `can.MouseCursor` is never dereferenced
    on a nil reference.  DebugLog must come after the forced cursor.
    """
    text = WORK.read_text(encoding="utf-8")
    in_opening = False
    body = []
    for line in text.splitlines():
        if "Sub Opening()" in line:
            in_opening = True
            body = []
            continue
        if in_opening:
            if line.strip() == "End Sub":
                break
            body.append(line)
    low = "\n".join(body).lower()
    can_idx = low.find("can.mousecursor")
    assert can_idx != -1, "WorkWindow.Opening: aucun can.MouseCursor force sous Linux"
    init_idx = low.find("initparams()")
    has_nil_guard = any(g in low[:can_idx] for g in (
        "if can <> nil", "if can<>nil", "if can <> nil then", "if can<>nil then",
    ))
    assert (init_idx != -1 and init_idx < can_idx) or has_nil_guard, (
        "WorkWindow.Opening: can.MouseCursor est force avant InitParams() "
        "et sans garde nil -> crash window.cpp:1092"
    )
    debug_idx = low.find("ag2: workwindow opening cursor forced")
    assert debug_idx == -1 or debug_idx > can_idx, \
        "WorkWindow.Opening: DebugLog doit venir apres le forçage du curseur"

if __name__ == "__main__":
    test_no_custom_cursor_reference_in_code()
    test_no_cursor_resource_in_project()
    test_no_cursor_cur_file()
    test_canvas_uses_standard_pointer()
    test_no_textwindow_afficher_in_refreshbackground_linux()
    test_no_mtextrefresh_set_in_mousemove_linux()
    test_workwindow_opening_forces_standard_pointer_linux()
    test_workwindow_opening_cursor_not_on_nil_can_linux()
    print("OK: custom cursors removed")
