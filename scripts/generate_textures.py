"""Generate placeholder PNG textures for Galactic Rim."""
from pathlib import Path

try:
    from PIL import Image, ImageDraw
except ImportError:
    import subprocess
    import sys

    subprocess.check_call([sys.executable, "-m", "pip", "install", "pillow", "-q"])
    from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent.parent / "GalacticRim" / "Common" / "Textures"

TEXTURES = {
    "Things/Item/Equipment/WeaponRanged/GR_HoldoutBlaster.png": ((64, 64), (90, 110, 140)),
    "Things/Item/Equipment/WeaponRanged/GR_PulseRifle.png": ((96, 64), (70, 90, 120)),
    "Things/Apparel/GR_JediInspiredRobe.png": ((64, 64), (180, 160, 90)),
    "Things/Apparel/GR_AuthorityTrooperCuirass.png": ((64, 64), (120, 125, 135)),
    "Things/Projectile/GR_BlasterBolt.png": ((16, 16), (120, 220, 255)),
    "Things/Projectile/GR_PulseBolt.png": ((16, 16), (255, 160, 80)),
    "UI/Abilities/GR_ForcePush.png": ((64, 64), (100, 180, 255)),
    "Things/Pawn/Animal/GR_PackBeast/GR_PackBeast_north.png": ((128, 128), (160, 150, 130)),
    "Things/Pawn/Animal/GR_PackBeast/GR_PackBeast_south.png": ((128, 128), (150, 140, 120)),
    "Things/Pawn/Animal/GR_PackBeast/GR_PackBeast_east.png": ((128, 128), (155, 145, 125)),
    "Things/Pawn/Animal/GR_PackBeast/GR_PackBeast_west.png": ((128, 128), (155, 145, 125)),
}


def draw_placeholder(size, color):
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    margin = max(2, min(size) // 8)
    draw.rounded_rectangle(
        (margin, margin, size[0] - margin, size[1] - margin),
        radius=6,
        fill=(*color, 255),
        outline=(255, 255, 255, 200),
        width=2,
    )
    return img


def main():
    for rel, (size, color) in TEXTURES.items():
        path = ROOT / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        draw_placeholder(size, color).save(path)
        print(f"Wrote {path}")


if __name__ == "__main__":
    main()
