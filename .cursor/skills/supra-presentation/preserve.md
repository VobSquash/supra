# Supra presentation — patterns to preserve

Use this when **greenfielding** a new Flutter app or re-implementing features: it complements [SKILL.md](SKILL.md) (rules) with **what you liked** in today’s `app/supra` UI so those ideas carry forward.

Optional file paths under `app/supra/lib/...` can be added beside items when you want a concrete legacy reference.

---

## Widgets and building blocks

### Global chrome

- **Home page app bar avatar**: keep the outer circle before the image; it separates the photo from the area behind it.
- **Bottom navigation bar**: keep the coloring and the light top edge as a border; it reads very cleanly. Consider a **future tweak**: selected tab as an **underline** instead of a full-square highlight.
- **Main app scaffold**: the whole scaffold should remain **swipeable** in sync with the bottom nav (tab/PageView-style flow).

### Home

- **`HomeSectionItem`** / section tiles: keep this pattern, especially with **`leadingEdgeAccent`**.

### Bookings

- **Grid view**: good for showing each booking line; there is still **wasted vertical space** inside **`_SlotRowStacked`** — tighten in the new app.
- **List view (accessibility)**: keep as-is; it works well.

### Ladders

- Keep the ladders page **largely as-is**. Consider applying the **`leadingEdgeAccent`** idea to the whole block for consistency.

### Fixtures

- **Home / Away** and **No catering** blocks: keep **equal height**; misaligned sizes look off. Good candidate for a **shared widget** (text + color in, layout out).

### Profile (member)

- **Overall layout**: needs a **full rethink** — flow is weak.
- **Exception — header**: keep the **scrolling header** design approach for profile.

### Members list / details

- **Search**: behavior is good; search appears in several places — **extract to shared** and reuse.
- **Otherwise**: not worth keeping except mirroring the **my-profile header section**; revisit the rest.

---

## Admin section

Give admin its **own dedicated area** — e.g. a **new bottom-nav tab** (optionally visible by `ProfileType`) so the **burger menu** can go away.

| Area | Direction |
|------|-----------|
| **Admin bookings** | Perfect — carry forward. |
| **Ladder management** | Perfect — carry forward. |
| **All users** | Weak — redo; align with the **my profile** revamp. |
| **Create members** | Perfect — carry forward; **validate** against new backend **profile-picture** behavior. |

---

## Theming and visual language

- **Color scheme**: keep as-is (you consider it spot-on).
- **Typography**: no dedicated font yet — **plan to add** one in the greenfield app.

---

## Interaction patterns & navigation

- Today’s **screen navigation** and **slowed-down transition** feel fine.
- **Forward-looking**: evaluate **GoRouter** or **AutoRoute** so **deep links**, **push notifications**, and **reminders** (e.g. booking in ~3 hours) have a clear story. No need to commit on day one, but **don’t paint into a corner**.
