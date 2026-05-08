from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw


ROOT = Path(__file__).resolve().parents[1]
BRAND_LOGO = ROOT / "assets" / "brand" / "snorvy_logo.png"

DEEP = (10, 13, 23, 255)


ANDROID_SIZES = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}


def main() -> None:
    source = build_launcher_icon(1024)
    play_store_source = build_launcher_icon(512, rounded=False)

    write_png(play_store_source, ROOT / "playstore" / "icon-512.png")

    for directory, size in ANDROID_SIZES.items():
        target = source.resize((size, size), Image.Resampling.LANCZOS)
        write_png(
            target,
            ROOT
            / "android"
            / "app"
            / "src"
            / "main"
            / "res"
            / directory
            / "ic_launcher.png",
        )

    write_png(source.resize((192, 192), Image.Resampling.LANCZOS), ROOT / "web" / "icons" / "Icon-192.png")
    write_png(source.resize((512, 512), Image.Resampling.LANCZOS), ROOT / "web" / "icons" / "Icon-512.png")
    write_png(maskable_icon(source, 192), ROOT / "web" / "icons" / "Icon-maskable-192.png")
    write_png(maskable_icon(source, 512), ROOT / "web" / "icons" / "Icon-maskable-512.png")
    write_png(source.resize((32, 32), Image.Resampling.LANCZOS), ROOT / "web" / "favicon.png")


def build_launcher_icon(size: int, *, rounded: bool = True) -> Image.Image:
    image = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)

    if rounded:
        rounded_rectangle(draw, (0, 0, size, size), radius=size * 0.22, fill=DEEP)
    else:
        draw.rectangle((0, 0, size, size), fill=DEEP)

    logo = Image.open(BRAND_LOGO).convert("RGBA")
    logo.thumbnail((int(size * 0.78), int(size * 0.78)), Image.Resampling.LANCZOS)
    offset = ((size - logo.width) // 2, (size - logo.height) // 2)
    image.alpha_composite(logo, offset)

    return image


def maskable_icon(source: Image.Image, size: int) -> Image.Image:
    canvas = Image.new("RGBA", (size, size), DEEP)
    inner = source.resize((int(size * 0.78), int(size * 0.78)), Image.Resampling.LANCZOS)
    offset = ((size - inner.width) // 2, (size - inner.height) // 2)
    canvas.alpha_composite(inner, offset)
    return canvas


def rounded_rectangle(
    draw: ImageDraw.ImageDraw,
    bounds: tuple[int, int, int, int],
    radius: float,
    fill: tuple[int, int, int, int],
) -> None:
    draw.rounded_rectangle(bounds, radius=int(radius), fill=fill)


def write_png(image: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    image.save(path, "PNG", optimize=True)


if __name__ == "__main__":
    main()
