"""Static test: FormsWindow hidden init + refreshContent nil-guards.

Bug1: palette must stay empty/hidden until family selection.
Bug2: refreshContent/setParams must nil-guard all accesses.
"""

from pathlib import Path

FORMS = Path("Windows/Formswindow.xojo_window")
WORK = Path("Windows/WorkWindow.xojo_window")


def forms_text() -> str:
    return FORMS.read_bytes().decode("utf-8")


def block(text: str, start_marker: str) -> str:
    low = text.lower()
    s = low.index(start_marker.lower())
    for end in ("#tag endmethod", "#tag endevent"):
        e = low.find(end, s)
        if e != -1:
            return text[s:e].lower()
    raise AssertionError(f"no block end after {start_marker!r}")


def test_header_preserved_container_embedded():
    t = forms_text()
    assert t.splitlines()[0].strip() == "#tag DesktopWindow"
    assert "Begin DesktopContainer Formswindow" in t
    assert "Begin DesktopWindow Formswindow" not in t
    assert "#tag EndDesktopWindow" in t
    assert "#tag EndDesktopContainer" not in t
    assert "ImplicitInstance" in t


def test_initial_state_empty_hidden():
    t = forms_text()
    assert '"Untitled"' not in t, "Untitled caption leaks visible buttons at startup"
    assert "InitialValue=\"Untitled\"" not in t
    assert "InitialValue=\"\"" in t
    assert "InitialValue=\"False\"" in t


def test_refreshcontent_nil_guards():
    b = block(forms_text(), "Sub refreshContent()")
    assert "if dico = nil or config = nil then" in b
    assert "if kit < 0 or kit > 1 then" in b
    assert "if kit = 0 and (fam < 0 or fam > 3) then" in b
    assert "if kit = 1 and (fam < 0 or fam > 7) then" in b
    assert "if bouton(i) <> nil then" in b
    assert "currentcontent <> nil and currentcontent.thegrid <> nil" in b
    assert "config.stdfamilies(fam, i) <> nil" in b


def test_setparams_contentsig_textsize_reset_guards():
    t = forms_text()
    s = block(t, "Sub setParams(")
    assert "if config = nil or dico = nil then" in s
    assert "if workwindow = nil then" in s
    assert "workwindow.tools = nil or workwindow.stdbox = nil" in s
    assert "if k < 0 or k > 1 then" in s
    c = block(t, "Function contentSig(")
    assert "if config = nil then" in c
    assert "if n > 10 then n = 10" in c
    u = block(t, "Sub updateTextSize()")
    assert "if config = nil then" in u
    assert "if bouton(i) <> nil then" in u
    r = block(t, "Sub reset(")
    assert "if workwindow = nil or config = nil then" in r
    assert "if workwindow.stdoutil(fam) = nil then" in r


def test_action_hides_without_floating_calls():
    t = forms_text()
    a = block(t, "Sub Action(")
    assert "if currentcontent = nil then" in a
    assert "if currentcontent.theobjects <> nil then" in a
    assert "if workwindow.mycanvas1 <> nil then" in a
    assert "visible = false" in a


def test_host_embed_stays_hidden_until_selection():
    t = WORK.read_bytes().decode("utf-8")
    assert "Begin Formswindow FormsWindow" in t
    assert "FormsWindow.Visible = False" in t


if __name__ == "__main__":
    test_header_preserved_container_embedded()
    test_initial_state_empty_hidden()
    test_refreshcontent_nil_guards()
    test_setparams_contentsig_textsize_reset_guards()
    test_action_hides_without_floating_calls()
    test_host_embed_stays_hidden_until_selection()
    print("OK: FormsWindow hidden init + nil guards present")
