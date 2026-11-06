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


if __name__ == "__main__":
    test_no_custom_cursor_reference_in_code()
    test_no_cursor_resource_in_project()
    test_no_cursor_cur_file()
    test_canvas_uses_standard_pointer()
    print("OK: custom cursors removed")
