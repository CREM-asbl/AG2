import re
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parent.parent.parent
MACROEXE = (ROOT / "Macros Classes" / "MacroExe.xojo_code").read_text(encoding="utf-8-sig")
SHAPE_CONSTRUCTION = (
    ROOT / "Operation Classes" / "MultipleSelect Operations" / "ShapeConstruction.xojo_code"
).read_text(encoding="utf-8-sig")


def method(source, name):
    match = re.search(
        rf"\b(?:Sub|Function)\s+{re.escape(name)}\b.*?\n\s*End\s+(?:Sub|Function)\b",
        source,
        re.IGNORECASE | re.DOTALL,
    )
    assert match, f"Méthode Xojo introuvable : {name}"
    return match.group(0)


@pytest.mark.parametrize("method_name", ["CreateIfMacObject", "CreateObject"])
def test_macro_operation_accepts_form_without_optional_parameter_element(method_name):
    body = method(MACROEXE, method_name)

    assert not re.search(r"EL\.ChildCount\s*<\s*2", body, re.IGNORECASE), (
        f"{method_name} abandonne une opération non-point valide qui ne contient "
        "que l'élément Form sérialisé par ShapeConstruction.ToMac"
    )
    assert re.search(
        r"If\s+EL\.ChildCount\s*>\s*1\s+Then\s+"
        r"EL1\s*=\s*XMLElement\(EL\.Child\(1\)\)\s+End\s+If",
        body,
        re.IGNORECASE,
    ), f"{method_name} doit lire le second enfant seulement lorsqu'il existe"
    assert not re.search(
        r"If\s+EL1\s*=\s*nil\s+Then.*?Return\s+End\s+If",
        body,
        re.IGNORECASE | re.DOTALL,
    ), f"{method_name} ne doit pas exiger EL1 : InfoMac accepte EL1 = nil"


def test_nonpoint_shapeconstruction_replay_does_not_require_parameter_element():
    constructor = re.search(
        r"Sub\s+Constructor\(Mexe\s+as\s+MacroExe.*?\n\s*End\s+Sub\b",
        SHAPE_CONSTRUCTION,
        re.IGNORECASE | re.DOTALL,
    )
    assert constructor, "Constructeur de rejeu ShapeConstruction introuvable"
    body = constructor.group(0)
    setup = body.split("fa = val", 1)[0]
    point_on_object = body.split("if fo = 1 then", 1)[1].split("else", 1)[0]

    assert not re.search(r"If\s+EL1\s*=\s*nil\s+Then", setup, re.IGNORECASE), (
        "Le rejeu d'une forme non-point n'utilise jamais EL1 et ne doit pas "
        "abandonner avant la reconstruction de ses points"
    )
    assert re.search(
        r"If\s+EL1\s*=\s*nil\s+Then.*?Return.*?End\s+If.*?"
        r"EL\s*=\s*XMLElement\(EL1\.Child\(0\)\)",
        point_on_object,
        re.IGNORECASE | re.DOTALL,
    ), "Le garde EL1 doit rester juste avant EL1.Child(0) pour un point sur objet"


def test_nonpoint_shapeconstruction_writes_only_one_direct_form_child():
    body = method(SHAPE_CONSTRUCTION, "ToMac")
    nonpoint_branch = body.split("else", 1)[1].split("if currentshape.pointe then", 1)[0]

    assert re.search(
        r"Temp\s*=\s*CurrentShape\.XMLPutIdInContainer\(Doc\)",
        nonpoint_branch,
        re.IGNORECASE,
    )
    assert re.search(r"EL\.AppendChild\s+Temp", nonpoint_branch, re.IGNORECASE)
    assert nonpoint_branch.count("EL.AppendChild") == 1
