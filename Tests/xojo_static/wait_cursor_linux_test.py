"""Spec #71: aucun curseur Wait non garde sur Linux.

Contexte : window.cpp:1092 Failure Condition cursor->GetGdkCursor().Get()
apres WorkWindow resized/activated, exit 0 precoce. Strace WSLg montre
que le theme curseur Adwaita (theme d'icones, sans repertoire cursors/)
ne fournit aucun curseur GDK : meme StandardPointer echoue si le theme
systeme est casse. Le seul levier code restant est d'eliminer tout
curseur non-Standard (Wait/horloge) sur Linux : ces curseurs sont les
premiers a manquer dans les themes minimaux, et chaque assignation
pre-realize ou sur hot-path risque le handle GDK nul.

Regle : toute assignation `*.MouseCursor = [System.]cursors.wait`
doit etre dans une branche non-Linux (#If Not TargetLinux) ou
remplacee par StandardPointer sous #If TargetLinux. Win/mac inchanges.
"""
import pathlib
import re

ROOT = pathlib.Path(".")
WAIT = re.compile(r"(?i)\.mousecursor\s*=\s*(system\.cursors\.wait|system\.cursors\.wait\b)")


def _xojo_files():
    files = []
    for pattern in ("*.xojo_window", "*.xojo_code"):
        files.extend(ROOT.rglob(pattern))
    return [f for f in files if ".git" not in f.parts]


def _unguarded_wait_sets(text):
    """Lignes Wait qui s'executent sous Linux (hors garde Not TargetLinux)."""
    skip_stack = []
    offending = []
    for i, line in enumerate(text.splitlines(), 1):
        s = line.strip()
        if s.startswith("#If Not TargetLinux"):
            skip_stack.append(True)
            continue
        if s.startswith("#If TargetLinux"):
            skip_stack.append(False)
            continue
        if s.startswith("#If "):
            skip_stack.append(skip_stack[-1] if skip_stack else False)
            continue
        if s.startswith("#Else"):
            if skip_stack:
                skip_stack[-1] = not skip_stack[-1]
            continue
        if s in ("#Endif", "#EndIf", "#End If"):
            if skip_stack:
                skip_stack.pop()
            continue
        if WAIT.search(line):
            if not any(skip_stack):
                offending.append((i, s))
    return offending


def test_no_unguarded_wait_cursor_on_linux():
    offenders = []
    for path in _xojo_files():
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        for lineno, line in _unguarded_wait_sets(text):
            offenders.append(f"{path}:{lineno}: {line}")
    assert not offenders, (
        "curseur Wait non garde sous Linux -> handle GDK nul "
        "(window.cpp:1092) si theme minimal :\n" + "\n".join(offenders)
    )
