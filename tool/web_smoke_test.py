from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path

from PIL import Image, ImageStat
from playwright.sync_api import TimeoutError as PlaywrightTimeoutError
from playwright.sync_api import sync_playwright


@dataclass(frozen=True)
class Viewport:
    name: str
    width: int
    height: int


VIEWPORTS = (
    Viewport("mobile", 393, 852),
    Viewport("tablet", 820, 1180),
    Viewport("desktop", 1280, 900),
)

BAD_CONSOLE_PATTERNS = (
    "another exception was thrown",
    "exception caught by",
    "overflowed by",
    "renderflex overflowed",
    "uncaught",
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Run Snorvy browser smoke checks against a served Flutter web build.",
    )
    parser.add_argument("--base-url", required=True)
    parser.add_argument(
        "--output-dir",
        default="build/web-smoke",
        help="Directory where screenshots and diagnostics are written.",
    )
    parser.add_argument("--headed", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    failures: list[str] = []
    screenshots: list[Path] = []

    with sync_playwright() as playwright:
        browser = playwright.chromium.launch(
            headless=not args.headed,
            args=[
                "--use-fake-device-for-media-stream",
                "--use-fake-ui-for-media-stream",
            ],
        )

        for viewport in VIEWPORTS:
            viewport_dir = output_dir / viewport.name
            viewport_dir.mkdir(parents=True, exist_ok=True)
            messages: list[tuple[str, str]] = []
            context = browser.new_context(
                viewport={"width": viewport.width, "height": viewport.height},
                device_scale_factor=1,
                has_touch=viewport.name == "mobile",
                is_mobile=viewport.name == "mobile",
            )
            context.grant_permissions(["microphone"], origin=args.base_url)
            page = context.new_page()
            page.on("console", lambda msg: messages.append((msg.type, msg.text)))
            page.on("pageerror", lambda exc: messages.append(("pageerror", str(exc))))

            try:
                page.goto(args.base_url, wait_until="domcontentloaded", timeout=60000)
                page.wait_for_load_state("load", timeout=30000)
                page.wait_for_selector(
                    "flutter-view, flt-glass-pane, canvas",
                    timeout=30000,
                )
                page.evaluate(
                    "document.querySelector('flt-semantics-placeholder')?.click()"
                )
                page.wait_for_timeout(500)
                wait_for_text(page, "No saved audio events yet", timeout=20000)

                screenshots.append(
                    capture(page, viewport_dir, "01-tonight", failures)
                )

                if viewport.name == "mobile":
                    exercise_mobile_flow(page, viewport, viewport_dir, failures, screenshots)
            except Exception as exc:
                failures.append(f"{viewport.name}: browser smoke failed: {exc}")
            finally:
                failures.extend(console_failures(viewport.name, messages))
                context.close()

        browser.close()

    print("Browser smoke screenshots:")
    for screenshot in screenshots:
        print(f"  {screenshot}")

    if failures:
        print("\nBrowser smoke failures:")
        for failure in failures:
            print(f"  - {failure}")
        return 1

    print("Browser smoke passed.")
    return 0


def exercise_mobile_flow(
    page,
    viewport: Viewport,
    viewport_dir: Path,
    failures: list[str],
    screenshots: list[Path],
) -> None:
    tap_nav(page, viewport, "Settings", 2)
    page.wait_for_timeout(800)
    screenshots.append(capture(page, viewport_dir, "02-settings", failures))

    if not click_text(page, "Add manual sleep log"):
        page.mouse.click(viewport.width / 2, 526)
    page.wait_for_timeout(800)
    screenshots.append(capture(page, viewport_dir, "03-manual-log-sheet", failures))

    if not click_text(page, "Save log"):
        page.mouse.click(viewport.width / 2, viewport.height - 64)
    page.wait_for_timeout(800)

    tap_nav(page, viewport, "History", 1)
    page.wait_for_timeout(1000)
    screenshots.append(capture(page, viewport_dir, "04-history-after-log", failures))

    if not click_label(page, "Delete night"):
        page.mouse.click(viewport.width - 48, 430)
    page.wait_for_timeout(600)
    screenshots.append(capture(page, viewport_dir, "05-delete-confirm", failures))

    if not click_text(page, "Delete"):
        page.mouse.click(viewport.width - 82, viewport.height / 2 + 118)
    page.wait_for_timeout(900)
    screenshots.append(capture(page, viewport_dir, "06-history-after-delete", failures))

    tap_nav(page, viewport, "Tonight", 0)
    page.wait_for_timeout(600)
    screenshots.append(capture(page, viewport_dir, "07-back-tonight", failures))


def click_text(page, text: str, timeout: int = 1400) -> bool:
    escaped = re.escape(text)
    candidates = [
        page.get_by_role("button", name=re.compile(escaped, re.IGNORECASE)).first,
        page.get_by_text(text, exact=False).first,
    ]
    for locator in candidates:
        try:
            locator.click(timeout=timeout)
            return True
        except PlaywrightTimeoutError:
            continue
        except Exception:
            continue
    return False


def wait_for_text(page, text: str, timeout: int = 8000) -> None:
    try:
        page.get_by_text(text, exact=False).first.wait_for(
            state="visible",
            timeout=timeout,
        )
    except Exception as exc:
        raise AssertionError(f'Expected visible text "{text}"') from exc


def click_label(page, label: str, timeout: int = 1200) -> bool:
    try:
        page.get_by_label(label).first.click(timeout=timeout)
        return True
    except Exception:
        return False


def tap_nav(page, viewport: Viewport, label: str, index: int) -> None:
    page.mouse.click((index + 0.5) * viewport.width / 3, viewport.height - 42)
    page.wait_for_timeout(300)


def capture(page, output_dir: Path, name: str, failures: list[str]) -> Path:
    path = output_dir / f"{name}.png"
    page.screenshot(path=str(path), full_page=False)
    assert_rendered(path, failures)
    return path


def assert_rendered(path: Path, failures: list[str]) -> None:
    image = Image.open(path).convert("RGB")
    sample = image.resize((96, 96))
    stat = ImageStat.Stat(sample)
    average_stddev = sum(stat.stddev) / len(stat.stddev)
    colors = sample.getcolors(maxcolors=10000)
    color_count = len(colors) if colors is not None else 10000

    if average_stddev < 4 or color_count < 12:
        failures.append(
            f"{path}: screenshot looks blank "
            f"(stddev={average_stddev:.2f}, colors={color_count})"
        )


def console_failures(viewport_name: str, messages: list[tuple[str, str]]) -> list[str]:
    failures: list[str] = []
    for message_type, text in messages:
        normalized = text.lower()
        if message_type == "error" or any(
            pattern in normalized for pattern in BAD_CONSOLE_PATTERNS
        ):
            if "favicon" in normalized:
                continue
            failures.append(f"{viewport_name}: console {message_type}: {text}")
    return failures


if __name__ == "__main__":
    sys.exit(main())
