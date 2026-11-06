"""Issue #71 post-splash runtime error: MsgBox + unguarded ChargerConfig.

Constat: splash clique OK (modal ferme, "splash click avant close" logge),
mais erreur runtime restante avant WorkWindow visible. Chaine post-modale
App.Opening -> Config.ChargerConfig -> ChargerStdForms contient :

- MsgBox TooManyFiles(...) si nstdfam > 4 : modale synchrone interdite
  headless/WSLg, crash Linux. Doit passer par DebugLog sous TargetLinux,
  MsgBox conserve hors Linux (pas de regression Win/mac).
- App.Opening appelle ChargerConfig sans Try/Catch : toute RuntimeException
  (XML menu/std corrompu, dossier manquant) remonte a UnhandledException
  avec CurrentContent=nil -> "AG2 fatal" puis sortie. Sous Linux, tracer
  et continuer sur Menu_AC par defaut.

Contrats:
- ChargerStdForms : branche #If TargetLinux -> DebugLog, #Else -> MsgBox.
- App.Opening post-modal : Try/Catch autour de ChargerConfig sous Linux,
  fallback Menu_AC + DebugLog, chaine (ObjectsList, WorkWindow.Show)
  preservee.
"""

from pathlib import Path

APP = Path("Other Classes/App.xojo_code")
CONFIG = Path("Other Classes/Configuration.xojo_code")


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


def stdforms_body() -> str:
    return extract_block(CONFIG.read_text(encoding="utf-8"), "Sub ChargerStdForms(")


def test_stdforms_msgbox_linux_guarded():
    body = stdforms_body()
    assert "msgbox" in body, "ChargerStdForms: MsgBox Win/mac attendu conserve"
    assert "#if targetlinux" in body, \
        "ChargerStdForms: MsgBox doit etre garde par #If TargetLinux"
    linux_branch = body.split("#if targetlinux", 1)[1]
    assert "system.debuglog" in linux_branch, \
        "ChargerStdForms: branche Linux doit tracer via DebugLog"
    linux_only = linux_branch.split("#else", 1)[0] if "#else" in linux_branch else linux_branch
    assert "msgbox" not in linux_only, \
        "ChargerStdForms: pas de MsgBox dans la branche Linux (headless crash)"


def test_opening_postmodal_chargerconfig_guarded():
    body = opening_body()
    post = body[body.index("showmodal"):]
    assert "chargerconfig" in post
    assert "try" in post and "catch" in post, \
        "Opening post-modal: ChargerConfig doit etre en Try/Catch (Linux)"
    assert "menu_ac" in post, \
        "Opening post-modal: fallback Menu_AC par defaut en cas d'erreur"
    for step in ("apres objectslist", "workwindow"):
        assert step in post, \
            f"Opening: chaine post-modale preservee, etape manquante: {step}"


if __name__ == "__main__":
    test_stdforms_msgbox_linux_guarded()
    test_opening_postmodal_chargerconfig_guarded()
    print("OK: post-modal guards")
