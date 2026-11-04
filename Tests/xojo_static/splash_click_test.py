"""Issue #71 splash-click Linux: exception vide post-close modal.

Constat verifie (build 11:58): splash modal PASS, clic bouton -> exception
non geree a message vide, "splash closed" jamais logge, Config.ChargerConfig
/ ObjectsList / WorkWindow.Show jamais atteints, hang apres "AG2 fatal:".
Donc l'exception se produit DANS PushButton1.Action (setMenu/save) ou dans
le teardown modal, et la branche startup de UnhandledException ne loggue que
error.Message (vide) -> aucune piste.

Contrats:
- PushButton1.Action trace chaque etape via DebugLog, isole setMenu/save
  dans try/catch avec log d'erreur, defaut Menu_AC si texte vide, log
  avant close. Modal intact (ShowModal/close conserves).
- App.Opening trace le retour modal etape par etape (avant/apres
  ChargerConfig, apres ObjectsList, WorkWindow visible).
- Config.setMenu garde le defaut Menu_AC sur texte vide.
- UnhandledException branche startup (CurrentContent nil) loggue type
  d'exception + numero d'erreur, pas seulement Message.
- Pas de Print() (DebugLog only). Tokens CLI exacts via Split(" ").
"""

from pathlib import Path

APP = Path("Other Classes/App.xojo_code")
INIT = Path("Windows/InitWindow.xojo_window")
CONFIG = Path("Other Classes/Configuration.xojo_code")


def extract_block(text: str, marker: str) -> str:
    low = text.lower()
    start = low.index(marker.lower())
    for end_marker in ("#tag endevent", "#tag endmethod", "#tag endevents"):
        end = low.find(end_marker.lower(), start)
        if end != -1:
            return text[start:end].lower()
    raise AssertionError(f"no block end after {marker!r}")


def opening_body() -> str:
    return extract_block(APP.read_text(encoding="utf-8"), "Sub Opening()")


def unhandled_body() -> str:
    return extract_block(APP.read_text(encoding="utf-8"), "Function UnhandledException(")


def pushbutton1_body() -> str:
    return extract_block(INIT.read_text(encoding="utf-8"), "#tag Events PushButton1")


def setmenu_body() -> str:
    return extract_block(CONFIG.read_text(encoding="utf-8"), "Sub setMenu(")


def test_pushbutton1_logs_steps_and_catches():
    body = pushbutton1_body()
    assert "system.debuglog" in body, \
        "PushButton1.Action: doit tracer les etapes via DebugLog"
    assert body.count("system.debuglog") >= 3, \
        "PushButton1.Action: logs avant/apres setMenu/save + avant close requis"
    assert "try" in body and "catch" in body, \
        "PushButton1.Action: setMenu/save doivent etre isoles en try/catch"
    assert "menu_ac" in body, \
        "PushButton1.Action: defaut Menu_AC si PopupMenu1.Text vide"
    assert "avant close" in body, \
        "PushButton1.Action: doit logguer avant close (dernier point trace)"
    assert "close" in body, \
        "PushButton1.Action: modal intact, close conserve"


def test_opening_postmodal_step_logs():
    body = opening_body()
    post = body[body.index("showmodal"):]
    for step in ("avant chargerconfig", "apres chargerconfig",
                 "apres objectslist", "workwindow"):
        assert step in post, \
            f"Opening: etape post-modal manquante: {step}"
    assert post.count("system.debuglog") >= 4, \
        "Opening: retour modal trace etape par etape via DebugLog"


def test_setmenu_defaults_empty_to_menu_ac():
    body = setmenu_body()
    assert 'm = ""' in body and "menu_ac" in body, \
        'setMenu: texte vide -> defaut Menu_AC requis'


def test_unhandled_startup_logs_type_not_only_message():
    body = unhandled_body()
    assert "currentcontent = nil" in body or "currentcontent=nil" in body
    assert "gettype" in body or "fullname" in body, \
        "UnhandledException startup: doit logguer le type d'exception (Message seul est vide)"
    assert "errornumber" in body, \
        "UnhandledException startup: doit logguer le numero d'erreur"


def test_no_print_in_click_path():
    for body, name in ((pushbutton1_body(), "PushButton1.Action"),
                       (opening_body(), "App.Opening")):
        assert "print(" not in body, \
            f"{name}: pas de Print(), DebugLog only (Desktop: Print inexistant)"


def test_cli_exact_tokens():
    body = opening_body()
    assert 'split(" ")' in body, \
        "Opening: tokens CLI exacts via Split (pas de IndexOf substring)"
    assert "--no-splash" in body


if __name__ == "__main__":
    test_pushbutton1_logs_steps_and_catches()
    test_opening_postmodal_step_logs()
    test_setmenu_defaults_empty_to_menu_ac()
    test_unhandled_startup_logs_type_not_only_message()
    test_no_print_in_click_path()
    test_cli_exact_tokens()
    print("OK: splash click path")
