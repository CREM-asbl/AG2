"""Static nil-guard test for issue #68 (NilObjectException on file open).

Crash chain: WorkWindow.OpenFile -> Ouvrir.Constructor(FolderItem) ->
Ouvrir.ChargerPreferencesEtObjets(XMLElement, FolderItem) ->
WindContent.ChargerObjets(XMLElement). A nil XMLElement / FolderItem /
missing shape reference must not raise NilObjectException.
"""

from pathlib import Path

OUVRIR = Path("Operation Classes/Ouvrir.xojo_code")
WINDCONTENT = Path("Other Classes/WindContent.xojo_code")
WORKWINDOW = Path("Windows/WorkWindow.xojo_window")


def extract_method(text: str, marker: str, end_marker: str = "#tag EndMethod") -> str:
    start = text.lower().index(marker.lower())
    end = text.lower().index(end_marker.lower(), start)
    return text[start:end].lower()


def test_ouvrir_constructor_guards():
    text = OUVRIR.read_text(encoding="utf-8")
    body = extract_method(text, "Sub Constructor(f as folderitem)")
    assert "if f = nil then" in body
    assert "documentelement = nil" in body
    assert "firstchild = nil" in body
    assert "if currentcontent = nil then" in body


def test_charger_preferences_et_objets_guards():
    text = OUVRIR.read_text(encoding="utf-8")
    body = extract_method(text, "Private Sub ChargerPreferencesEtObjets")
    assert "if rootelement = nil then" in body


def test_charger_objets_guards():
    text = WINDCONTENT.read_text(encoding="utf-8")
    body = extract_method(text, "Sub ChargerObjets(FAG as XMLElement)")
    assert "if fag = nil then" in body
    assert "if theobjects = nil then" in body
    assert "if shua <> nil then" in body
    assert "shua.aire" in body
    assert body.index("if shua <> nil then") < body.index("shua.aire")
    assert "if dr <> nil then" in body
    assert "dr.longueur" in body
    assert body.index("if dr <> nil then") < body.index("dr.longueur")


def test_charger_prefs_guards():
    text = WINDCONTENT.read_text(encoding="utf-8")
    body = extract_method(text, "Sub ChargerPrefs(FAG as XMLElement, f as folderitem)")
    assert "if fag = nil then" in body
    assert "if f = nil then" in body
    assert "if obj = nil then" in body
    assert "if can = nil then" in body


def test_openfile_guards():
    text = WORKWINDOW.read_text(encoding="utf-8")
    body = extract_method(text, "Sub OpenFile(f as Folderitem)")
    assert "if f = nil then" in body
    assert "if currentcontent = nil then" in body


if __name__ == "__main__":
    test_ouvrir_constructor_guards()
    test_charger_preferences_et_objets_guards()
    test_charger_objets_guards()
    test_charger_prefs_guards()
    test_openfile_guards()
    print("OK")
