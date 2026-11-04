"""Spec #71 splash Linux: objectif, contrats, acceptance.

Objectif: sous Linux/DISPLAY virtuel sans entree, l'app reste sur
initWindow.ShowModal (bloquant par design) sans log, sans WorkWindow.
Contrats:
- InitWindow.Opening ne doit appeler aucune methode inexistante
  (LabelVersion.Text, pas setString qui n'existe sur aucun Label).
- App.Opening supporte --no-splash (non-interactif): saute ShowModal,
  positionne quiet, log via DebugLog, continue vers ChargerConfig +
  WorkWindow.Show.
- Progression splash tracee par DebugLog (avant/apres) pour diagnostic.
Acceptance: ce fichier passe, les 87 tests existants restent verts.
"""
from pathlib import Path

APP = Path("Other Classes/App.xojo_code")
INIT = Path("Windows/InitWindow.xojo_window")


def opening_body() -> str:
    text = APP.read_text(encoding="utf-8")
    low = text.lower()
    start = low.index("sub opening()")
    end = low.index("#tag endevent", start)
    return text[start:end].lower()


def test_initwindow_version_label_uses_text():
    text = INIT.read_text(encoding="utf-8").lower()
    assert "setstring" not in text, \
        "InitWindow.Opening: setString n'existe pas sur Label, utiliser .Text"
    assert "labelversion.text" in text, \
        "InitWindow.Opening: doit assigner LabelVersion.Text"


def test_opening_supports_no_splash_bypass():
    body = opening_body()
    assert "--no-splash" in body, \
        "Opening: doit supporter le token exact --no-splash"
    assert "showmodal" in body
    assert body.index("--no-splash") < body.index("showmodal"), \
        "Opening: --no-splash doit etre detecte avant ShowModal"
    assert "quiet" in body, \
        "Opening: bypass doit positionner quiet"
    assert "chargerconfig" in body and "workwindow.show" in body
    assert body.index("showmodal") < body.index("chargerconfig"), \
        "Opening: ChargerConfig/WorkWindow.Show doivent suivre le splash"


def test_opening_logs_splash_progress():
    body = opening_body()
    assert body.count("system.debuglog") >= 2, \
        "Opening: doit tracer la progression splash via DebugLog"
    assert "splash" in body, \
        "Opening: logs splash manquants (avant/apres ShowModal)"


if __name__ == "__main__":
    test_initwindow_version_label_uses_text()
    test_opening_supports_no_splash_bypass()
    test_opening_logs_splash_progress()
    print("OK: initwindow flow")
