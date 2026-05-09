"""Smoke test the Snorvy web build at http://localhost:8765."""

import sys
from playwright.sync_api import sync_playwright

URL = "http://localhost:8765"


def main() -> int:
    errors: list[str] = []
    console_logs: list[str] = []
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        ctx = browser.new_context(viewport={"width": 412, "height": 915})
        page = ctx.new_page()

        page.on("console", lambda msg: console_logs.append(f"[{msg.type}] {msg.text}"))
        page.on("pageerror", lambda exc: errors.append(f"PAGE ERROR: {exc}"))

        print("Navigating to", URL)
        page.goto(URL, wait_until="domcontentloaded", timeout=120_000)

        # Flutter web takes a while; wait for the canvas/glasspane to appear
        try:
            page.wait_for_selector("flt-glass-pane, flutter-view, flt-scene-host", timeout=120_000)
        except Exception as e:
            print("Flutter shell never appeared:", e)

        page.wait_for_timeout(4_000)
        page.screenshot(path="C:/Users/demosgod/Desktop/PROJECTS/snorvy.app/tool/smoke_tonight.png")
        print("Saved tonight screenshot")

        # Try semantics-based selectors. Flutter web exposes ARIA for nav items.
        # Enable semantics by sending a tap on a known location to wake them up.
        # We click bottom nav 'History' item by viewport coordinates as fallback.
        # Bottom nav vertical center ~ y=865 of 915. 3 items, x positions ~78/206/334.
        try:
            page.wait_for_timeout(1_000)
            page.mouse.click(206, 865)
            print("Clicked History tab area")
        except Exception as e:
            print("Click failed:", e)

        page.wait_for_timeout(3_000)
        page.screenshot(path="C:/Users/demosgod/Desktop/PROJECTS/snorvy.app/tool/smoke_history.png")
        print("Saved history screenshot")

        # Click somewhere in the calendar middle area
        try:
            page.mouse.click(206, 320)
            page.wait_for_timeout(1_500)
            page.screenshot(path="C:/Users/demosgod/Desktop/PROJECTS/snorvy.app/tool/smoke_history_day.png")
            print("Saved history day-tap screenshot")
        except Exception as e:
            print("Calendar tap failed:", e)

        browser.close()

    print("\n--- console logs (filtered) ---")
    for log in console_logs:
        lower = log.lower()
        if any(
            k in lower
            for k in (
                "error",
                "exception",
                "renderflex",
                "assertion",
                "flutter:",
                "rangeerror",
                "═",
            )
        ):
            print(log)

    print("\n--- page errors ---")
    for err in errors:
        print(err)

    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
