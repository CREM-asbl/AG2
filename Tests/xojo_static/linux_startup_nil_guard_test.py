"""Static startup-guard test for issue #71.

Linux symptom: Xojo runtime quits silently (exit 0, 0.2s, no window,
no CreateWindow) on minimal/headless systems. Startup chain
App.Opening -> InitFolders -> new Configuration runs before any window:

- InitFolders dereferences SpecialFolder.Documents without a nil guard.
  On headless Linux (no xdg-user-dirs, no ~/Documents) Documents is nil,
  so .Child raises NilObjectException. App.UnhandledException swallows it
  (CurrentContent is nil at startup -> return true), app exits 0 silent.
- Configuration.Constructor/Save dereference app.DocFolder without a nil
  guard, same silent-quit path when InitFolders bailed out early.
- Dictionnaire.getXML dereferences app.DctFolder without a nil guard.
- No --help/--version short-circuit exists: CLI probes run the full GUI
  path, so the smoke test sees exit 0 and wrongly reports PASS.
- Smoke test only checks exit code, never output content, so a silent
  quit is indistinguishable from a healthy --help.
"""

from pathlib import Path

APP = Path("Other Classes/App.xojo_code")
CONFIG = Path("Other Classes/Configuration.xojo_code")
DICO = Path("Other Classes/Dictionnaire.xojo_code")
SMOKE = Path("tools-packaging/test-linux-smoke.ps1")


def extract_block(text: str, marker: str) -> str:
    low = text.lower()
    start = low.index(marker.lower())
    for end_marker in ("#tag endevent", "#tag endmethod"):
        end = low.find(end_marker.lower(), start)
        if end != -1:
            return text[start:end].lower()
    raise AssertionError(f"no block end after {marker!r}")


def opening_body() -> str:
    return extract_block(APP.read_text(encoding="utf-8"), "Sub Opening()")

def unhandled_body() -> str:
    return extract_block(APP.read_text(encoding="utf-8"), "Function UnhandledException(")

def method_body(path: Path, marker: str) -> str:
    return extract_block(path.read_text(encoding="utf-8"), marker)


def initfolders_body() -> str:
    return extract_block(APP.read_text(encoding="utf-8"), "Sub InitFolders()")


def test_opening_short_circuits_cli_before_gui():
    body = opening_body()
    assert "system.commandline" in body, \
        "Opening: missing --help/--version short-circuit via System.CommandLine"
    assert "initwindow.showmodal" in body
    assert body.index("system.commandline") < body.index("initwindow.showmodal"), \
        "Opening: CLI short-circuit must run before initWindow.ShowModal"


def test_initfolders_guards_nil_documents():
    body = initfolders_body()
    assert "specialfolder.documents" in body
    assert "if basedocs = nil then" in body or "if basedocs=nil then" in body, \
        "InitFolders: missing nil guard with fallback when Documents is nil"
    assert "specialfolder.applicationdata" in body, \
        "InitFolders: missing ApplicationData fallback for headless Linux"


def test_configuration_constructor_guards_nil_docfolder():
    text = CONFIG.read_text(encoding="utf-8")
    body = extract_block(text, "Sub Constructor()")
    assert "app.docfolder = nil" in body, \
        "Configuration.Constructor: missing nil DocFolder guard"


def test_configuration_save_guards_nil_docfolder():
    text = CONFIG.read_text(encoding="utf-8")
    body = extract_block(text, "Sub Save()")
    assert "app.docfolder = nil" in body, \
        "Configuration.Save: missing nil DocFolder guard"


def test_dictionnaire_getxml_guards_nil_dctfolder():
    text = DICO.read_text(encoding="utf-8")
    body = extract_block(text, "Function getXML(")
    assert "app.dctfolder = nil" in body, \
        "Dictionnaire.getXML: missing nil DctFolder guard"


def test_smoke_rejects_silent_quit():
    text = SMOKE.read_text(encoding="utf-8")
    assert "SMOKE-KO-silent" in text, \
        "smoke: must FAIL on empty --help output (silent quit), not just exit code"
    assert "help.log" in text.lower() or "stdout" in text.lower(), \
        "smoke: must capture stdout/stderr content, not just exit code"

def test_opening_uses_exact_cli_token_and_stdout():
    body = opening_body()
    assert 'indexof("--help")' not in body, \
        "Opening: IndexOf substring match risks false positives (e.g. --helpful); use exact token"
    assert "split" in body, \
        "Opening: must split System.CommandLine into exact tokens"
    assert "print(" in body or "stdout" in body, \
        "Opening: --help/--version must write to stdout (Print/StdOut), not only System.DebugLog"

def test_unhandled_exception_parent_nil_guard():
    body = unhandled_body()
    assert "specialfolder.documents" in body
    assert ".parent" in body
    assert "if f <> nil then" in body, \
        "UnhandledException: must nil-guard Documents folder before .Parent/.Name"

def test_unhandled_exception_not_silent_at_startup():
    body = unhandled_body()
    assert "currentcontent = nil" in body or "currentcontent=nil" in body
    assert "return false" in body, \
        "UnhandledException: startup error with CurrentContent nil must return false (non-zero exit), not swallow with return true"

def test_initfolders_child_nil_guards():
    body = extract_block(APP.read_text(encoding="utf-8"), "Sub InitFolders()")
    assert "ensurefolder" in body or body.count("= nil") >= 3, \
        "InitFolders: each Child() result must be nil-guarded (or via EnsureFolder helper)"

def test_dictionnaire_no_msgbox_headless():
    text = DICO.read_text(encoding="utf-8")
    body = extract_block(text, "Function getXML(")
    assert "msgbox" not in body, \
        "Dictionnaire.getXML: MsgBox blocks headless; use System.DebugLog instead"

def test_app_dicodispo_guards_nil():
    body = method_body(APP, "Function DicoDispo(")
    assert "dctfolder = nil" in body, \
        "App.DicoDispo: missing nil DctFolder guard"

def test_configuration_chargerconfig_guards_nil():
    body = method_body(CONFIG, "Sub ChargerConfig()")
    assert "menusfolder = nil" in body, \
        "Configuration.ChargerConfig: missing nil MenusFolder guard"

def test_configuration_save_guards_nil_first():
    body = method_body(CONFIG, "Sub Save()")
    assert "app.docfolder = nil" in body
    guard_idx = body.find("app.docfolder = nil")
    build_idx = body.find("new xmldocument")
    assert guard_idx != -1 and (build_idx == -1 or guard_idx < build_idx), \
        "Configuration.Save: nil DocFolder guard must run before building XML"


if __name__ == "__main__":
    test_opening_short_circuits_cli_before_gui()
    test_initfolders_guards_nil_documents()
    test_configuration_constructor_guards_nil_docfolder()
    test_configuration_save_guards_nil_docfolder()
    test_dictionnaire_getxml_guards_nil_dctfolder()
    test_smoke_rejects_silent_quit()
    test_opening_uses_exact_cli_token_and_stdout()
    test_unhandled_exception_parent_nil_guard()
    test_unhandled_exception_not_silent_at_startup()
    test_initfolders_child_nil_guards()
    test_dictionnaire_no_msgbox_headless()
    test_app_dicodispo_guards_nil()
    test_configuration_chargerconfig_guards_nil()
    test_configuration_save_guards_nil_first()
    print("OK: all #71 Linux startup guards present")
