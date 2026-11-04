"""Spec #71 --no-splash gspell: TextWindow.EF.Text.Set crash sous Linux.

Chaine: WorkWindow.Resized -> CustomCanvas1.RefreshBackground
-> TextWindow.Afficher (si Visible) -> EF.Text.Set repetes ->
libgspell gtk_text_buffer_set_text -> SIGSEGV si backend
enchant/hunspell absent. EF a AllowSpellChecking=True.

Fix: spell-check OFF (design + guard runtime Linux), modal intact.
"""
from pathlib import Path

TEXT = Path("Windows/TextWindow.xojo_window")


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


def ef_block() -> str:
    text = TEXT.read_text(encoding="utf-8")
    low = text.lower()
    start = low.index("begin desktoptextarea ef")
    end = low.index("\n   end", start)
    return text[start:end]


def test_ef_spellchecking_off_by_default():
    for line in ef_block().splitlines():
        if "allowspellchecking" in line.lower():
            assert "false" in line.lower(), \
                "EF: AllowSpellChecking doit etre False (gspell segfault Linux)"
            return
    raise AssertionError("EF: ligne AllowSpellChecking introuvable")


def test_afficher_disables_spellcheck_on_linux():
    body = block(TEXT, "Sub Afficher()")
    assert "targetlinux" in body, "Afficher: pas de garde TargetLinux"
    assert "allowspellchecking" in body, \
        "Afficher: spell-check non coupe avant Text.Set"


def test_opening_disables_spellcheck_on_linux():
    body = block(TEXT, "Sub Opening()")
    assert "targetlinux" in body, "Opening: pas de garde TargetLinux"
    assert "allowspellchecking" in body, "Opening: spell-check non coupe"


if __name__ == "__main__":
    test_ef_spellchecking_off_by_default()
    test_afficher_disables_spellcheck_on_linux()
    test_opening_disables_spellcheck_on_linux()
    print("OK: nosplash gspell guards")
