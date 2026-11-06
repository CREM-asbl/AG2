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


def test_workwindow_opening_no_mousecursor_assignment_linux():
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
    offending = [l for l in body if re.search(r"(?i)\\.mousecursor\\s*=", l)]
    assert not offending, (
        "WorkWindow.Opening: assignation MouseCursor interdite avant realisation:\\n"
        + "\\n".join(offending)
    )
    low = joined.lower()
    assert "initparams()" in low
    assert "updatemenu" in low
    assert "newcontent(false)" in low
    assert 'System.DebugLog("AG2: WorkWindow opening")' in joined

def test_workwindow_opening_forces_window_cursor_linux():
    """Spec #71: WorkWindow force Self.MouseCursor des Opening (Linux).

    Log --no-splash: crash window.cpp:1092 juste apres "WorkWindow
    visible", sans TextWindow impliquee. WorkWindow n'a aucun
    Self.MouseCursor explicite ni handler Activated : sous Xwayland le
    curseur GDK de la fenetre est NULL au premier realize/survol apres
    maximize -> GetGdkCursor().Get() explose. Forcer StandardPointer
    dans Opening (avant maximize) donne a la fenetre un curseur GDK
    valide des sa realisation.
    """
    body = _extract_event_body("Windows/WorkWindow.xojo_window", "Opening")
    linux = _extract_linux_block(body)
    assert re.search(r"(?i)Self\.MouseCursor\s*=\s*System\.Cursors\.StandardPointer", linux), \
        "WorkWindow.Opening Linux: Self.MouseCursor=StandardPointer requis avant maximize"
    m_cur = re.search(r"(?i)Self\.MouseCursor", linux)
    m_max = re.search(r"(?i)\bmaximize\b", body)
    assert m_cur and m_max, "Opening: curseur Linux + maximize attendus"
    assert linux.index(m_cur.group(0)) < body.lower().index("maximize"), \
        "Opening: forcer le curseur AVANT maximize"

def test_workwindow_activated_forces_cursor_linux():
    """Spec #71: WorkWindow.Activated re-force le curseur (Linux).

    Garde-fou si le curseur fenetre est reinitialise entre Opening et
    la premiere activation (maximize/Resized/realize tardif).
    """
    body = _extract_event_body("Windows/WorkWindow.xojo_window", "Activated")
    assert body.strip(), "WorkWindow: handler Activated manquant"
    linux = _extract_linux_block(body)
    assert re.search(r"(?i)Self\.MouseCursor\s*=\s*System\.Cursors\.StandardPointer", linux), \
        "WorkWindow.Activated Linux: Self.MouseCursor=StandardPointer requis"

def test_workwindow_resized_forces_cursor_linux():
    """Spec #71: WorkWindow.Resized re-force curseur fenetre + canvas (Linux).

    Log manuel: Failure window.cpp:1092 suit toujours un Resized
    post-Activated (maximize -> realize tardif). Le premier survol
    souris interroge le curseur GDK entre realize et Activated :
    forcer StandardPointer dans Resized (apres realisation) couvre
    cette fenetre. MyCanvas1 inclus car survol canvas = meme requete.
    """
    body = _extract_event_body("Windows/WorkWindow.xojo_window", "Resized")
    assert body.strip(), "WorkWindow: handler Resized manquant"
    linux = _extract_linux_block(body)
    assert re.search(r"(?i)Self\.MouseCursor\s*=\s*System\.Cursors\.StandardPointer", linux), \
        "WorkWindow.Resized Linux: Self.MouseCursor=StandardPointer requis"
    assert re.search(r"(?i)MyCanvas1\.MouseCursor\s*=\s*System\.Cursors\.StandardPointer", linux), \
        "WorkWindow.Resized Linux: MyCanvas1.MouseCursor=StandardPointer requis"

def _extract_event_body(path, event_name):
    text = pathlib.Path(path).read_text(encoding="utf-8")
    in_event = False
    body = []
    for line in text.splitlines():
        if f"Sub {event_name}()" in line:
            in_event = True
            body = []
            continue
        if in_event:
            if line.strip() == "End Sub":
                break
            body.append(line)
    return "\n".join(body)

def _extract_linux_block(body):
    lines = body.splitlines()
    in_linux = False
    depth = 0
    block = []
    for line in lines:
        stripped = line.strip()
        if not in_linux and "#If TargetLinux" in line:
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
            if stripped.startswith("#Else") and depth == 1:
                in_linux = False
                continue
            block.append(line)
    return "\n".join(block)

def test_textwindow_opening_linux_no_mousecursor_before_realization():
    body = _extract_event_body("Windows/TextWindow.xojo_window", "Opening")
    linux = _extract_linux_block(body)
    offending = [l for l in linux.splitlines() if re.search(r"(?i)mousecursor\s*=", l)]
    assert not offending, (
        "TextWindow.Opening: MouseCursor assigne avant realisation sous Linux "
        "-> window.cpp:1092:\n" + "\n".join(offending)
    )
    assert "EF.AllowSpellChecking = False" in linux
    assert 'System.DebugLog("textwindow opening spellcheck off")' in linux

def test_textwindow_activated_linux_forces_ef_mousecursor():
    body = _extract_event_body("Windows/TextWindow.xojo_window", "Activated")
    linux = _extract_linux_block(body)
    assert "EF.MouseCursor = System.Cursors.StandardPointer" in linux, (
        "TextWindow.Activated: EF.MouseCursor non force apres realisation"
    )

def test_workwindow_mouvbut_pressed_cursor_guarded_linux():
    text = WORK.read_text(encoding="utf-8")
    in_event = False
    body = []
    for line in text.splitlines():
        if "Sub Pressed(index as Integer)" in line:
            in_event = True
            body = []
            continue
        if in_event:
            if line.strip() == "End Sub":
                break
            body.append(line)
    in_guard = False
    depth = 0
    offending = []
    for line in body:
        stripped = line.strip()
        if stripped.startswith("#If Not TargetLinux"):
            in_guard = True
            depth = 1
            continue
        if in_guard:
            if stripped.startswith("#If "):
                depth += 1
            if stripped in ("#Endif", "#EndIf", "#End If"):
                depth -= 1
                if depth == 0:
                    in_guard = False
                    continue
            if stripped.startswith("#Else") and depth == 1:
                in_guard = False
                continue
        if re.search(r"(?i)can\.mousecursor\s*=\s*System\.Cursors\.StandardPointer", stripped):
            if not in_guard:
                offending.append(stripped)
    assert not offending, (
        "WorkWindow.MouvBut.Pressed: can.MouseCursor non garde sous Linux:\n"
        + "\n".join(offending)
    )

def test_textwindow_afficher_cursor_assignments_guarded_linux():
    body = _extract_event_body("Windows/TextWindow.xojo_window", "Afficher")
    linux = _extract_linux_block(body)
    total = len(re.findall(r"(?i)EF\.MouseCursor\s*=", body))
    guarded = len(re.findall(r"(?i)EF\.MouseCursor\s*=", linux))
    assert total == guarded and total >= 2, (
        f"TextWindow.Afficher: {total} assignations MouseCursor, "
        f"{guarded} gardees sous Linux"
    )

def test_workwindow_opening_no_setfocus_linux():
    body = _extract_event_body("Windows/WorkWindow.xojo_window", "Opening")
    offending = [l for l in body.splitlines() if re.search(r"(?i)\bsetfocus\b", l)]
    assert not offending, (
        "WorkWindow.Opening: SetFocus au demarrage sous Linux:\n"
        + "\n".join(offending)
    )

def test_textwindow_opening_no_setfocus_linux():
    body = _extract_event_body("Windows/TextWindow.xojo_window", "Opening")
    offending = [l for l in body.splitlines() if re.search(r"(?i)\bsetfocus\b", l)]
    assert not offending, (
        "TextWindow.Opening: SetFocus au demarrage sous Linux:\n"
        + "\n".join(offending)
    )

if __name__ == "__main__":
    test_no_custom_cursor_reference_in_code()
    test_no_cursor_resource_in_project()
    test_no_cursor_cur_file()
    test_canvas_uses_standard_pointer()
    test_no_textwindow_afficher_in_refreshbackground_linux()
    test_no_mtextrefresh_set_in_mousemove_linux()
    test_workwindow_opening_no_mousecursor_assignment_linux()
    test_workwindow_opening_forces_window_cursor_linux()
    test_workwindow_activated_forces_cursor_linux()
    test_textwindow_opening_linux_no_mousecursor_before_realization()
    print("OK: custom cursors removed")
