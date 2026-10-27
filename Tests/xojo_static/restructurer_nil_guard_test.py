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
    # s2 nil / constructedby nil must be skipped before dereference
    assert "s2 = nil or s2.constructedby = nil" in body
    # s1 (constructedby.shape) may itself be nil -> s1.fig would crash
    assert "s1 = nil" in body
    # figs involved may be nil (GetPosition is nil-safe, setconstructedby is not)
    assert "s1.fig = nil or s2.fig = nil" in body
    # guards must precede the dereference
    assert body.index("s2.constructedby = nil") < body.index(
        "s1 = s2.constructedby.shape"
    )


if __name__ == "__main__":
    test_restructurer_nil_guards()
    print("OK")
