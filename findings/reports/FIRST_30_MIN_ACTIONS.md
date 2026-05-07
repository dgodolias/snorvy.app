# First 30 Minutes — D13 Bloki Action Card

_For the Greek solo dev. Right after reading EXECUTIVE_SUMMARY.md. Total clock time: 30 minutes. All actions $0._

---

## Minute 0-5: AADE Taxisnet account check

**Why first**: AADE production app registration (the 5-10 day lead-time blocker) requires an active Taxisnet account on the dev's personal/business AFM.

**Steps:**
1. Go to **https://www1.aade.gr/** → click **"Είσοδος Χρηστών"** (top-right)
2. Click **"Σύνδεση μέσω TAXISnet"** (the orange button)
3. Login with your existing Taxisnet credentials (the ones you use for E1 / ΦΠΑ filings)
4. **If login works**: ✅ proceed. **If not**: go to https://www1.aade.gr/saadeapps2/bookmark/regUserAct (Εγγραφή Νέου Χρήστη), register with AFM + ΑΜΚΑ + email; activation code arrives by post in 5-7 days (this is the ONLY blocking dependency for D13 — start it now)
5. Once logged in, navigate to **myAADE → Μητρώο & Επικοινωνία → Στοιχεία Επιχείρησης** and confirm KAD code 62.01.21 (software development) is registered. If not, file Δ211 to add it (free, 1 day).

**Output**: Note your Taxisnet username + AFM in a password manager. Do NOT proceed to API registration until activation is confirmed.

---

## Minute 5-10: Cloudflare Worker signup

**Why**: Bloki's $0 backend constraint depends on Cloudflare Workers free tier (100K req/day). Verified architecture: 1670 MAU × ~30 calls/mo = 50K req/mo (≈50% of one DAY'S free quota at 10× growth).

**Steps:**
1. Go to **https://dash.cloudflare.com/sign-up** → register with the Greek dev's primary email (NOT a throwaway — this becomes the ops email for Bloki backend)
2. Verify email → 2FA setup with authenticator app (mandatory for production deploys)
3. Click **"Workers & Pages"** in left nav → **"Create application"** → **"Hello World" template** (don't deploy anything yet, just confirm dashboard works)
4. Confirm the **Free plan** badge shows: 100,000 requests/day, 10ms CPU/request, 128MB memory — sufficient for AADE proxy
5. Bookmark the **API Tokens** page: https://dash.cloudflare.com/profile/api-tokens (you'll generate a deploy token in W1)

**Output**: Cloudflare account live, free tier confirmed, deploy-token URL bookmarked.

---

## Minute 10-20: Domain registration + landing page reservation

**Why**: `bloki.gr` is the canonical name. Domain anchors (a) ASO contact-link credibility, (b) AADE app registration form requires a public-facing URL, (c) accountant TikTokers will ask "where can I link?".

**Steps:**
1. Go to **https://www.papaki.gr/domain-search** (Greek registrar, Greek-IBAN-friendly billing) OR **https://www.namecheap.com** (€10/yr but USD billing)
2. Search **bloki.gr** — if available, register for **2 years (~€22)** with WhoisGuard
3. **Fallbacks if `bloki.gr` is taken** (in priority order): `blokiapp.gr` → `bloki.eu` → `getbloki.gr` → `bloki-app.gr`
4. Set DNS: A-record `@` → 1.1.1.1 (Cloudflare placeholder), CNAME `www` → `@`. Will be replaced by Cloudflare Pages in W5.
5. **Add the domain to Cloudflare** (free): Cloudflare Dashboard → "Add a Site" → enter domain → free plan → update nameservers at Papaki to Cloudflare's (provided in Cloudflare onboarding flow)
6. Reserve handles: **@blokiapp** on Twitter/X, Instagram, TikTok (even if not used immediately — squat protection)

**Output**: Domain owned, Cloudflare DNS-managed, social handles parked.

---

## Minute 20-30: Trademark + Play Store listing reservation

**Why**: "Bloki" is generic-sounding (μπλοκάκι = freelancer's invoice book), but EUIPO trademark + Play Store handle reservation prevents Epsilon Smart or any opportunist from preempting the name 3 weeks into the build.

### Trademark search (EUIPO TMview, free)

1. Go to **https://www.tmdn.org/tmview/** — the official EUIPO + national TM search
2. Search term: **"BLOKI"** (uppercase) → Filters: Territory = Greece + EUIPO + Cyprus, Status = Active
3. Check classes:
   - **Class 9** (software, mobile apps) — must be clear
   - **Class 42** (SaaS, cloud services) — must be clear
4. **If clear in classes 9+42**: ✅ proceed (file actual application in W3, ~€850 EU-wide or ~€140 GR-only — included in d13 Y1 hard cost)
5. **If conflict found**: Pivot to **"Blokio"** (diminutive form) or **"Bloki+"** as plan B
6. **Cross-check Greek OBI**: https://www.obi.gr/el/ → "Αναζήτηση Σήματος" → same search (national-only TMs sometimes don't sync to TMview)

### Play Store + App Store handle reservation

7. **Google Play Console**: If Greek dev account already paid (€23 one-time), reserve app name → "Bloki — myDATA Τιμολόγηση" → save as draft (no listing required yet)
8. **App Store Connect**: If Apple Dev Program already paid (€114/yr), App Store Connect → "My Apps" → "+" → "New App" → Bundle ID `gr.bloki.app` → reserve name "Bloki — myDATA"
9. **If dev accounts NOT yet paid**: defer until W1 (Apple takes 24-48h, Google takes 2-3 days for verification — this is fine for the W7 launch timeline)

**Output**: Trademark conflict-cleared (or fallback name picked), Play Store + App Store names reserved as drafts.

---

## After this 30 minutes — what's next

- **Same day (May 7)**: Submit AADE production app registration via myAADE → Εγκαταστάσεις & Εφαρμογές → ΑΑΔΕ Web API. Form requires: app name, public URL (`bloki.gr`), description, expected traffic. The 5-10 biz day clock STARTS when this submits.
- **Tomorrow (May 8)**: Reach out to 5 Greek accountant TikTokers (DM template in `findings/raw/d13_build_playbook.md`)
- **Day 3 (May 9)**: Flutter scaffold commit, Drift schema draft, RevenueCat trial account
- **Day 4 (May 10)**: Cloudflare Worker boilerplate (proxy stub) + AADE sandbox creds wait
- **Monday May 11**: Week 1 starts — first AADE sandbox invoice POST attempt

---

## Tools needed (all free or already-paid)

| Tool | Cost | URL |
|---|---|---|
| Taxisnet account | €0 | https://www1.aade.gr/ |
| Cloudflare Workers | €0 (free tier) | https://dash.cloudflare.com/sign-up |
| Domain `bloki.gr` | €11/yr | https://www.papaki.gr/ |
| EUIPO TM search | €0 | https://www.tmdn.org/tmview/ |
| Greek OBI TM search | €0 | https://www.obi.gr/el/ |
| Google Play Console | €23 one-time | https://play.google.com/console |
| Apple Developer | €114/yr | https://developer.apple.com/programs/ |
| Flutter SDK | €0 | https://docs.flutter.dev/get-started/install |
| RevenueCat (IAP) | €0 (<€2.5k MTR) | https://www.revenuecat.com |

---

_Once these 30 minutes are done, the AADE registration clock is ticking and the build is unblockable. Open `findings/reports/EXECUTIVE_SUMMARY.md` next for the 7-week plan, or `findings/raw/d13_build_playbook.md` for daily standup-level detail._
