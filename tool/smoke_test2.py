"""Verify talk heatmap toggle on the History screen."""

import sys
from playwright.sync_api import sync_playwright

URL = "http://localhost:8765"


def main() -> int:
    errors: list[str] = []
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        ctx = browser.new_context(viewport={"width": 412, "height": 915})
        page = ctx.new_page()
        page.on("pageerror", lambda exc: errors.append(f"PAGE ERROR: {exc}"))

        page.goto(URL, wait_until="domcontentloaded", timeout=120_000)
        page.wait_for_selector("flt-glass-pane, flutter-view, flt-scene-host", timeout=120_000)
        page.wait_for_timeout(4_000)

        # Click History
        page.mouse.click(206, 865)
        page.wait_for_timeout(2_500)

        # Click "Talk heatmap" chip — approximate x=275, y=170
        page.mouse.click(275, 170)
        page.wait_for_timeout(1_500)
        page.screenshot(path="C:/Users/demosgod/Desktop/PROJECTS/snorvy.app/tool/smoke_history_talk.png")
        print("Saved talk heatmap screenshot")

        # Click a day in the past (e.g. cell at row=2, col=4 -> approx x=255, y=350)
        page.mouse.click(255, 350)
        page.wait_for_timeout(1_500)
        page.screenshot(path="C:/Users/demosgod/Desktop/PROJECTS/snorvy.app/tool/smoke_history_day_select.png")
        print("Saved day-select screenshot")

        # Click prev month arrow at top-left
        page.mouse.click(75, 130)
        page.wait_for_timeout(1_500)
        page.screenshot(path="C:/Users/demosgod/Desktop/PROJECTS/snorvy.app/tool/smoke_history_prev_month.png")
        print("Saved prev-month screenshot")

        browser.close()

    print("\n--- page errors ---")
    for err in errors:
        print(err)
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
