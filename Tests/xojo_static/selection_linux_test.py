"""Static test: selection Linux sans MouseMove prealable + FormsWindow stable.

Cause racine:
- SelectAndDrag/MultipleSelect/Selectionner MouseDown dependent de
  CurrentHighlightedShape, pose uniquement par MouseMove. Sous Linux GTK
  MouseMove rare => clic = no-op.
- FormsWindow Paint repositionne left/top a chaque paint => boucle WM Linux.
- setParams sans Show/Visible explicite => fenetre derriere / non reactive.
"""
from pathlib import Path

SELECT_DRAG = Path("Operation Classes/SelectAndDrag Operations/SelectAndDragOperation.xojo_code")
MULTI = Path("Operation Classes/MultipleSelect Operations/MultipleSelectOperation.xojo_code")
SELECTIONNER = Path("Operation Classes/Selectionner.xojo_code")
FORMS = Path("Windows/Formswindow.xojo_window")


def _extract_method(text: str, sig: str) -> str:
    in_m = False
    body = []
    for line in text.splitlines():
        if not in_m and line.strip().startswith("Sub " + sig):
            in_m = True
            body = []
            continue
        if in_m:
            if line.strip() == "End Sub":
                break
            body.append(line)
    return "\n".join(body)


def test_selectdrag_mousedown_hit_test_fallback():
    body = _extract_method(SELECT_DRAG.read_text(encoding="utf-8"), "MouseDown(")
    assert body.strip(), "SelectAndDrag: MouseDown introuvable"
    assert "CurrentHighlightedShape = nil" in body or "currenthighlightedshape = nil" in body.lower()
    low = body.lower()
    assert "getshape(p)" in low or "findobject(p)" in low, \
        "SelectAndDrag.MouseDown: aucun fallback HitTest quand highlight nil"


def test_multipleselect_mousedown_hit_test_fallback():
    body = _extract_method(MULTI.read_text(encoding="utf-8"), "MouseDown(")
    assert body.strip(), "MultipleSelect: MouseDown introuvable"
    low = body.lower()
    assert "ifcurrenthighlightedshape=nilthen" in low.replace(" ", ""), \
        "MultipleSelect.MouseDown: garde nil attendue"
    assert "getshape(p)" in low or "findobject(p)" in low, \
        "MultipleSelect.MouseDown: aucun fallback HitTest, early-return sec"


def test_selectionner_mousedown_hit_test_fallback():
    body = _extract_method(SELECTIONNER.read_text(encoding="utf-8"), "MouseDown(")
    assert body.strip(), "Selectionner: MouseDown introuvable"
    low = body.lower()
    assert "getshape(p)" in low or "findobject(p)" in low, \
        "Selectionner.MouseDown: currentshape=currenthighlightedshape sans fallback"


def test_formswindow_paint_no_reposition():
    text = FORMS.read_text(encoding="utf-8")
    in_paint = False
    body = []
    for line in text.splitlines():
        if "Sub Paint(" in line:
            in_paint = True
            body = []
            continue
        if in_paint:
            if line.strip() == "End Sub":
                break
            body.append(line)
    joined = "\n".join(body)
    low = joined.lower()
    assert "left=" not in low.replace(" ", "") and "top=" not in low.replace(" ", ""), \
        "FormsWindow.Paint repositionne left/top => boucle paint/move sous Linux"


def test_formswindow_setparams_shows_window():
    body = _extract_method(FORMS.read_text(encoding="utf-8"), "setParams(")
    assert body.strip(), "FormsWindow: setParams introuvable"
    low = body.lower()
    assert "visible = true" in low or ".show" in low, \
        "FormsWindow.setParams: aucun Show/Visible explicite, fragile GTK3"


if __name__ == "__main__":
    test_selectdrag_mousedown_hit_test_fallback()
    test_multipleselect_mousedown_hit_test_fallback()
    test_selectionner_mousedown_hit_test_fallback()
    test_formswindow_paint_no_reposition()
    test_formswindow_setparams_shows_window()
    print("OK: selection linux guards present")
