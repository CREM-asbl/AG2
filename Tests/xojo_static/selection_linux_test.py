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
SELECT_OP = Path("Operation Classes/SelectOperation/SelectOperation.xojo_code")
FORMS = Path("Windows/Formswindow.xojo_window")
WORK = Path("Windows/WorkWindow.xojo_window")
SHAPE_CONSTR = Path("Operation Classes/MultipleSelect Operations/ShapeConstruction.xojo_code")


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
    # Ordre critique sous Linux GTK (highlight souvent nil sans MouseMove) :
    # le fallback GetShape(p) doit preceder la garde `isa modifier` sinon
    # Modifier.MouseDown early-return avant HitTest => clic = no-op.
    fb = low.find("getshape(p)")
    if fb < 0:
        fb = low.find("findobject(p)")
    guard = low.find("isa modifier")
    assert 0 <= fb < guard, \
        "SelectAndDrag.MouseDown: fallback HitTest apres garde modifier => clic Modifier inoperant sous Linux"


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


def test_selectoperation_mousedown_hit_test_fallback():
    body = _extract_method(SELECT_OP.read_text(encoding="utf-8"), "MouseDown(")
    assert body.strip(), "SelectOperation: MouseDown introuvable"
    low = body.lower()
    assert "getshape(p)" in low or "findobject(p)" in low, \
        "SelectOperation.MouseDown: unselectall+return sans fallback => clic bouton no-op sous Linux"

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


def test_formswindow_action_restores_canvas_focus():
    text = FORMS.read_text(encoding="utf-8")
    in_action = False
    body = []
    for line in text.splitlines():
        if line.strip().startswith("Sub Action("):
            in_action = True
            body = []
            continue
        if in_action:
            if line.strip() == "End Sub":
                break
            body.append(line)
    joined = "\n".join(body).lower()
    assert "mycanvas1.setfocus" in joined.replace(" ", "") or "can.setfocus" in joined.replace(" ", ""), \
        "FormsWindow.Action: aucun SetFocus canvas apres Close => focus perdu sous Linux GTK"


def test_formswindow_bouton_mousedown_consumes_linux():
    text = FORMS.read_text(encoding="utf-8")
    in_md = False
    body = []
    for line in text.splitlines():
        if line.strip().startswith("Function MouseDown("):
            in_md = True
            body = []
            continue
        if in_md:
            if line.strip() == "End Function":
                break
            body.append(line)
    joined = "\n".join(body)
    low = joined.lower()
    assert "targetlinux" in low and "return true" in low, \
        "FormsWindow.Bouton.MouseDown: return false sous Linux => press/release ignores GTK"


def test_workwindow_mouvbut_pressed_canvas_focus():
    text = WORK.read_text(encoding="utf-8")
    in_event = False
    body = []
    for line in text.splitlines():
        if "Sub Pressed(index as Integer)" in line:
            in_event = True
            body = []
            continue
        if in_event:
            if line.strip() == "End Sub":
                break
            body.append(line)
    joined = "\n".join(body).lower()
    assert "can.setfocus" in joined.replace(" ", ""), \
        "WorkWindow.MouvBut.Pressed: SetFocus sur Self au lieu de can => focus canvas perdu Linux"


def test_shapeconstruction_mousedown_fixecoord():
    body = _extract_method(SHAPE_CONSTR.read_text(encoding="utf-8"), "MouseDown(")
    assert body.strip(), "ShapeConstruction: MouseDown introuvable"
    assert "fixecoord" in body.lower(), \
        "ShapeConstruction.MouseDown: pas de Fixecoord => coordonnees perimees sans MouseMove Linux"


MODIFIER = Path("Operation Classes/SelectAndDrag Operations/Modifier.xojo_code")


def test_modifier_mousedown_locks_shape_selection():
    body = _extract_method(MODIFIER.read_text(encoding="utf-8"), "MouseDown(")
    assert body.strip(), "Modifier: MouseDown introuvable"
    low = body.lower()
    assert "super.mousedown(p)" in low.replace(" ", ""), \
        "Modifier.MouseDown: super.MouseDown manquant"
    assert "selection" in low, \
        "Modifier.MouseDown: aucun verrouillage selection quand testfinished=false => clic forme = no-op Linux"
    assert "refreshtitle" in low, \
        "Modifier.MouseDown: refreshtitle manquant apres verrouillage selection"


if __name__ == "__main__":
    test_selectdrag_mousedown_hit_test_fallback()
    test_multipleselect_mousedown_hit_test_fallback()
    test_selectionner_mousedown_hit_test_fallback()
    test_selectoperation_mousedown_hit_test_fallback()
    test_formswindow_paint_no_reposition()
    test_formswindow_setparams_shows_window()
    test_formswindow_action_restores_canvas_focus()
    test_formswindow_bouton_mousedown_consumes_linux()
    test_workwindow_mouvbut_pressed_canvas_focus()
    test_shapeconstruction_mousedown_fixecoord()
    test_modifier_mousedown_locks_shape_selection()
    print("OK: selection linux guards present")
