"""Static nil-guard test for Figure.restructurer (issue #39).

NilObjectException in Figure.restructurer via FigsList.restructurer <-
Delete.DoOperation <- Delete.MouseDown. Debug vars: $i = 0..2, $t = True,
$tsf empty. Crash site: `s1 = s2.constructedby.shape` dereferences nil
`s2.constructedby` (shapes added to tsf.constructedshapes without a
ConstructionInfo, e.g. type-0 paraperp path).
"""

from pathlib import Path

FIGURE = Path("Figures classes/Figure.xojo_code")
MARKER_START = "Sub restructurer()"
MARKER_END = "#tag EndMethod"


def extract_restructurer(text: str) -> str:
    start = text.index(MARKER_START)
    end = text.index(MARKER_END, start)
    return text[start:end]


def test_restructurer_nil_guards():
    text = FIGURE.read_text(encoding="utf-8")
    body = extract_restructurer(text)

    assert "s2.constructedby.shape" in body, "crash site missing"
    # Xojo `or`/`and` do not short-circuit: guards must be nested ifs,
    # one condition per line, before any dereference.
    assert "s2 = nil or" not in body, "s2 guard uses `or`: still derefs nil"
    assert "s1 = nil or" not in body, "s1 guard uses `or`: still derefs nil"
    for guard in (
        "if s2 = nil then",
        "if s2.constructedby = nil then",
        "if s1 = nil then",
        "if s1.fig = nil then",
        "if s2.fig = nil then",
    ):
        assert guard in body, f"missing guard `{guard}`"
    # guards must precede the dereference
    assert body.index("if s2 = nil then") < body.index(
        "s1 = s2.constructedby.shape"
    )
    assert body.index("if s2.constructedby = nil then") < body.index(
        "s1 = s2.constructedby.shape"
    )
    assert body.index("if s1 = nil then") < body.index("s1.fig")


if __name__ == "__main__":
    test_restructurer_nil_guards()
    print("OK")
