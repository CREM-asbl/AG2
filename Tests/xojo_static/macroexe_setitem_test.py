"""Static regression tests for MacroExe.SetItem initialization."""

from pathlib import Path

BASE = Path(__file__).resolve().parent.parent.parent
MACROEXE = BASE / "Macros Classes/MacroExe.xojo_code"


def extract_method(text: str, marker: str, end_marker: str = "#tag EndMethod") -> str:
    low = text.lower()
    start = low.find(marker.lower())
    assert start != -1, f"method marker not found: {marker!r}"
    end = low.find(end_marker.lower(), start)
    assert end != -1, f"end marker not found after: {marker!r}"
    return text[start:end]


def test_setitem_initializes_missing_construction_info_before_appending():
    text = MACROEXE.read_text(encoding="utf-8")
    body = extract_method(text, "Function SetItem(s as shape) As Boolean").lower()

    ensure_info = body.find("if mac.macinf = nil then")
    create_info = body.find("mac.macinf = new macconstructioninfo(mac)")
    append_real = body.find("mac.macinf.realinit.append s.id")
    append_side = body.find("mac.macinf.realinitside.append side")
    advance = body.find("return true")

    assert ensure_info != -1
    assert ensure_info < create_info < append_real < append_side < advance
    assert "macinfo = mac.macinf" in body
