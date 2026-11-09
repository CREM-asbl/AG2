"""Spec #71: TextWindow EF realised with default I-beam under Linux.

Manual log: "textwindow opening spellcheck off" then
window.cpp:1092 cursor->GetGdkCursor().Get() -- crash before Activated.
Root cause: showing TextWindow realises DesktopTextArea EF with its
default I-beam cursor; under Xwayland the I-beam GDK handle is NULL.
Activated forces StandardPointer too late (post-realisation).

Fix contract (Linux-only): Opening hides EF before realisation,
Activated forces StandardPointer then re-shows EF before Afficher.
"""
import pathlib
import re

TEXT = pathlib.Path("Windows/TextWindow.xojo_window")


def _event_body(event_name):
    text = TEXT.read_text(encoding="utf-8")
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


def _linux_block(body):
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


def test_opening_hides_ef_before_realisation_linux():
    linux = _linux_block(_event_body("Opening"))
    assert re.search(r"(?i)EF\.Visible\s*=\s*False", linux), \
        "TextWindow.Opening Linux: EF doit etre cache avant realisation " \
        "(I-beam GDK nul -> window.cpp:1092)"


def test_activated_reshows_ef_after_cursor_force_linux():
    linux = _linux_block(_event_body("Activated"))
    m_cursor = re.search(
        r"(?i)EF\.MouseCursor\s*=\s*System\.Cursors\.StandardPointer", linux)
    m_show = re.search(r"(?i)EF\.Visible\s*=\s*True", linux)
    assert m_cursor and m_show, \
        "TextWindow.Activated Linux: forcer curseur puis re-afficher EF"
    assert m_cursor.start() < m_show.start(), \
        "Activated: EF.Visible=True doit suivre le forcage curseur"
