from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter


ROOT = Path(__file__).resolve().parents[1]

DEEP = (10, 58, 52, 255)
TEAL = (29, 132, 116, 255)
MINT = (143, 246, 220, 255)
CREAM = (249, 247, 241, 255)
AMBER = (255, 198, 102, 255)


ANDROID_SIZES = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}


def main() -> None:
    source = draw_icon(1024)
    play_store_source = draw_icon(1024, rounded=False)

    write_png(source, ROOT / "assets" / "brand" / "snorvy-icon-1024.png")
    write_png(
        play_store_source.resize((512, 512), Image.Resampling.LANCZOS),
        ROOT / "playstore" / "icon-512.png",
    )

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


def draw_icon(size: int, *, rounded: bool = True) -> Image.Image:
    scale = size / 1024
    image = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)

    if rounded:
        rounded_rectangle(draw, (0, 0, size, size), radius=220 * scale, fill=DEEP)
    else:
        draw.rectangle((0, 0, size, size), fill=DEEP)

    for offset, alpha in ((-150, 50), (120, 36), (330, 24)):
        glow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        glow_draw = ImageDraw.Draw(glow)
        glow_draw.ellipse(
            rect(
                120 + offset,
                120,
                760 + offset,
                760,
                scale,
            ),
            fill=(143, 246, 220, alpha),
        )
        image.alpha_composite(glow.filter(ImageFilter.GaussianBlur(58 * scale)))

    draw = ImageDraw.Draw(image)

    draw_moon(draw, scale)
    draw_microphone(draw, scale)
    draw_waves(draw, scale)
    draw_spark(draw, scale)

    return image


def draw_moon(draw: ImageDraw.ImageDraw, scale: float) -> None:
    draw.ellipse(rect(234, 185, 440, 391, scale), fill=CREAM)
    draw.ellipse(rect(306, 142, 500, 338, scale), fill=DEEP)


def draw_microphone(draw: ImageDraw.ImageDraw, scale: float) -> None:
    draw.rounded_rectangle(
        rect(392, 280, 632, 620, scale),
        radius=int(118 * scale),
        fill=MINT,
    )
    draw.rounded_rectangle(
        rect(462, 338, 562, 540, scale),
        radius=int(50 * scale),
        fill=DEEP,
    )
    draw.rounded_rectangle(
        rect(498, 570, 526, 705, scale),
        radius=int(14 * scale),
        fill=MINT,
    )
    draw.rounded_rectangle(
        rect(410, 690, 614, 736, scale),
        radius=int(23 * scale),
        fill=MINT,
    )


def draw_waves(draw: ImageDraw.ImageDraw, scale: float) -> None:
    stroke = int(34 * scale)
    for x, height in ((292, 88), (352, 140), (672, 140), (732, 88)):
        draw.rounded_rectangle(
            rect(x, 466 - height / 2, x + 32, 466 + height / 2, scale),
            radius=int(16 * scale),
            fill=TEAL,
        )
    draw.arc(rect(265, 376, 455, 566, scale), 125, 235, fill=MINT, width=stroke)
    draw.arc(rect(569, 376, 759, 566, scale), -55, 55, fill=MINT, width=stroke)


def draw_spark(draw: ImageDraw.ImageDraw, scale: float) -> None:
    points = [
        (760, 214),
        (790, 274),
        (850, 304),
        (790, 334),
        (760, 394),
        (730, 334),
        (670, 304),
        (730, 274),
    ]
    draw.polygon([(int(x * scale), int(y * scale)) for x, y in points], fill=AMBER)


def maskable_icon(source: Image.Image, size: int) -> Image.Image:
    canvas = Image.new("RGBA", (size, size), DEEP)
    inner = source.resize((int(size * 0.78), int(size * 0.78)), Image.Resampling.LANCZOS)
    offset = ((size - inner.width) // 2, (size - inner.height) // 2)
    canvas.alpha_composite(inner, offset)
    return canvas


def rect(x1: float, y1: float, x2: float, y2: float, scale: float) -> tuple[int, int, int, int]:
    return (
        int(round(x1 * scale)),
        int(round(y1 * scale)),
        int(round(x2 * scale)),
        int(round(y2 * scale)),
    )


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
