# Vob Squash — ChatGPT image prompts for App Store / Play Store

Use these prompts in ChatGPT (DALL·E / image generation). For best results, **attach reference screenshots** from the running app or from `assets/images/` (especially `home_dark_mode.png`) and say: *"Match the attached app's visual style."*

---

## Brand & design system (paste into every prompt)

```
App name: Vob Squash 
Platform: iOS / Android mobile app, dark mode only
Style: Premium dark sports-club app. Material Design 3. Soft glass-like background with subtle glowing orbs — not heavy blur.

Colors (use exactly):
- Background: #1F1F1F (charcoal)
- Cards / surfaces: #3E4145 (semi-transparent dark grey)
- Primary accent (buttons, dock): #28D6F5 (bright cyan)
- Secondary accent: #0B8091 (teal)
- Success / fixtures accent: #00C59D (green-teal)
- Warning / admin accent: #FF8C41 (orange)
- Calculator accent: #CB5FA5 (magenta)
- Text primary: #FFFFFF
- Text secondary: #B0C9C2 (muted sage-grey)
- Booked courts: royal blue, forest green, burnt orange (three courts)

UI patterns:
- 16px rounded corners on cards
- 4px colored left accent stripe on list rows and section headers
- Floating bottom navigation dock with 3px cyan-to-teal gradient stripe along the top edge
- Dock tabs: Home, Bookings, Fixtures, Ladders, Profile (with small circular avatar on Profile)
- Bold sans-serif typography (Roboto / SF Pro style), heavy weight for titles
- Tennis / squash icon in cyan when no logo is shown
- No light mode — always dark UI
```

---

## App Store screenshot sizes (reference)

| Use | Size (px) | Aspect |
|-----|-----------|--------|
| iPhone 6.7" (required) | 1290 × 2796 | ~9:19.5 |
| iPhone 6.5" | 1284 × 2778 | ~9:19.5 |
| iPhone 5.5" | 1242 × 2208 | 9:16 |
| iPad Pro 12.9" | 2048 × 2732 | 3:4 |
| Google Play feature graphic | 1024 × 500 | ~2:1 |

ChatGPT may not hit exact pixels — generate at high resolution, then crop/resize in Figma, Canva, or App Store Connect.

---

## Master style suffix (append to any prompt below)

```
Photorealistic iPhone 15 Pro device frame optional. Clean marketing composition. No watermarks, no stock-photo people unless specified. Professional App Store screenshot quality. Dark charcoal background with soft cyan and teal ambient glow. Text must be legible and spelled correctly.
```

---

## Prompt 1 — Hero / feature screenshot (Home)

```
Create an App Store promotional image for a squash club member app called "Vob Squash".

Show a modern iPhone displaying the home screen:
- Dark background (#1F1F1F) with soft cyan (#28D6F5) and teal (#0B8091) radial glow orbs behind the UI
- Top: full-width event banner carousel with rounded corners (24px), showing a club social or tournament photo
- Middle: booking heatmap card — a small calendar/month grid showing court availability
- Section "Play" with two rows: "Bookings" (cyan left accent bar) and "Fixtures" (green-teal accent)
- Section "Club" with rows: "Ladders", "Members", "Calculator" — each with a thin colored left accent stripe
- Bottom: floating dock navigation — Home, Bookings, Fixtures, Ladders, Profile — with cyan-to-teal gradient line on top of the dock

Outside the phone (optional marketing overlay):
Headline: "Your club. One app."
Subheadline: "Book courts. View fixtures. Stay connected."

[Paste brand & design system block above]
[Append master style suffix]
```

---

## Prompt 2 — Bookings

```
Create an App Store screenshot for "Vob Squash" showing the court booking screen on a dark iPhone mockup.

Inside the app UI:
- Date selector at top
- Three squash courts displayed as a grid or list
- Booked time slots filled with solid colors: Court 1 blue, Court 2 green, Court 3 orange
- Available slots shown as dark grey cells on #3E4145 cards
- Cyan (#28D6F5) accent for selected date and primary buttons
- Bottom dock with "Bookings" tab highlighted (cyan underline)

Marketing text overlay beside or below the phone:
"Book a court in seconds."

[Paste brand & design system block]
[Append master style suffix]
```

---

## Prompt 3 — Fixtures & leagues

```
Create an App Store screenshot for "Vob Squash" showing the fixtures / league matches screen.

Inside the app UI:
- Dark cards (#3E4145) with 16px radius
- Fixture cards with colored team header stripe (blue, green, or orange band across top)
- Home vs away labels, match date, opposition club name
- Small tennis/squash icon accents
- Fixtures tab selected in bottom dock (cyan highlight)

Marketing overlay text:
"Fixtures, ladders & league play."

[Paste brand & design system block]
[Append master style suffix]
```

---

## Prompt 4 — Member directory

```
Create an App Store screenshot for "Vob Squash" showing the member directory.

Inside the app UI:
- Search bar at top on dark background
- Scrollable list of member names with circular avatar initials
- Each row has a subtle colorful left accent (rainbow hues keyed to initials)
- Section index A–Z on the right edge
- Dark cards, white primary text, #B0C9C2 secondary labels

Marketing overlay text:
"Find any member instantly."

[Paste brand & design system block]
[Append master style suffix]
```

---

## Prompt 5 — Ladders & challenges

```
Create an App Store screenshot for "Vob Squash" showing the club ladder rankings.

Inside the app UI:
- Team blocks stacked vertically, each with a colored 4px left border (cyan, teal, green)
- Player rows with rank number, name, and ladder position
- Trophy icon accents in cyan
- Ladders tab selected in bottom dock

Marketing overlay text:
"Challenge. Climb. Compete."

[Paste brand & design system block]
[Append master style suffix]
```

---

## Prompt 6 — Fridge calculator (club refreshments)

```
Create an App Store screenshot for "Vob Squash" showing the fridge calculator / refreshments payment screen.

Inside the app UI:
- Tabs: Drinks, Snacks, Others
- List items with quantity steppers (+ / − buttons)
- Running total at bottom
- Magenta (#CB5FA5) accent on calculator-related elements
- Cyan primary action button "Pay" or similar

Marketing overlay text:
"Refreshments made simple."

[Paste brand & design system block]
[Append master style suffix]
```

---

## Prompt 7 — Profile & account

```
Create an App Store screenshot for "Vob Squash" showing the member profile screen.

Inside the app UI:
- Collapsing header with club banner imagery (subtle squash court or club photo)
- Large circular profile photo with member initials fallback
- Rows: edit name, change password, sign out
- Profile tab selected in bottom dock (avatar tab highlighted)

Marketing overlay text:
"Your membership, your way."

[Paste brand & design system block]
[Append master style suffix]
```

---

## Prompt 8 — Login / first impression

```
Create an App Store screenshot for "Vob Squash" showing the sign-in screen.

Inside the app UI:
- Centered cyan (#28D6F5) tennis/squash icon (56px)
- Title "Vob Squash" in bold white, weight 800
- Subtitle "Sign in to continue" in #B0C9C2
- Email and password fields on dark surfaces
- Cyan filled "Sign in" button with dark text (#0A0A0A)
- Dark glassic background with soft cyan/teal orbs

Marketing overlay text:
"Official app for VOB Squash Club."

[Paste brand & design system block]
[Append master style suffix]
```

---

## Prompt 9 — Google Play feature graphic (1024 × 500)

```
Create a Google Play Store feature graphic (wide banner, 1024×500 aspect ratio).

Layout:
- Left third: "Vob Squash" wordmark in bold white on dark #1F1F1F background
- Tagline: "Book courts. Play leagues. Stay connected."
- Right two-thirds: stylized composite of the app UI — home screen with event banner, booking grid, and bottom dock
- Soft cyan (#28D6F5) and teal (#0B8091) glow accents
- Optional subtle squash court texture in background, very dark and desaturated
- No device frame required — flat marketing banner style

[Paste brand & design system block]
[Append master style suffix]
```

---

## Prompt 10 — App icon / brand lockup (optional)

```
Create a square app icon concept for "Vob Squash" squash club app.

- Dark charcoal base (#1F1F1F)
- Central stylized tennis/squash ball or racket icon in cyan (#28D6F5)
- Minimal, flat, modern — readable at 1024×1024 and small sizes
- No text on icon (Apple HIG: avoid text in app icons)
- Subtle teal (#0B8091) shadow or ring for depth

Clean vector-style, no photorealism.
```

---

## Suggested screenshot set (minimum viable)

1. **Hero** — Prompt 1 (Home)
2. **Bookings** — Prompt 2
3. **Fixtures** — Prompt 3
4. **Members or Ladders** — Prompt 4 or 5
5. **Profile or Calculator** — Prompt 6 or 7

Add Prompt 9 for Google Play. Use Prompt 8 only if you want a "sign in" story frame.

---

## Tips for ChatGPT

1. **Attach real screenshots** from the simulator/device — ChatGPT aligns layout and colors better than text alone.
2. **One screen per image** — don't ask for every feature in a single prompt.
3. **Iterate in short steps**: generate UI inside phone first → then ask to add marketing headline outside the device.
4. **Fix typos manually** — AI often misspells small overlay text; add headlines in Figma/Canva after generation.
5. **Real screenshots + frames**: For pixel-perfect store listings, capture actual app screenshots and use [Apple's marketing tools](https://developer.apple.com/app-store/marketing/guidelines/) or Figma device frames; use these prompts for hero banners and feature graphics only.
6. **Reference assets in repo**: `assets/images/home_dark_mode.png`, `assets/images/splash_dark_mode.png`, `assets/images/vob_header_v2.png`

---

## Draft App Store copy (not in repo — edit as needed)

**App name (store):** Vob Squash  
**Subtitle:** Book courts. Play leagues. Stay connected.  
**Promotional text:** The official member app for VOB Squash Club, Cape Town.  
**Description opener:** Vob Squash helps club members book courts, view fixtures and ladders, browse the member directory, pay for refreshments, and manage their profile — all from your phone.

**Keywords:** squash, club, booking, courts, ladder, fixtures, VOB, Cape Town, sports
