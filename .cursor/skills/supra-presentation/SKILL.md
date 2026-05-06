---
name: supra-presentation
description: >-
  Flutter presentation-layer standards for the Supra app (app/supra): structure,
  widgets, async UI, theming, and production-quality UI patterns. Use when
  editing or creating files under lib/presentation/, lib/engine/ UI (theme,
  router), when greenfielding or re-implementing Supra in a new Flutter app, or
  when the user asks for production-ready front-end, UI refactors, or Supra
  screens. For patterns worth keeping from the current app, read preserve.md
  in this skill folder.
disable-model-invocation: true
---

# Supra presentation layer

When rebuilding Supra in a **new** Flutter project, follow this skill **and** [preserve.md](preserve.md) (what to carry forward from the legacy presentation layer).

## Architecture

- When creating a new feature, add a folder named after the feature under `lib/presentation/`. The top-level screen in that folder is the route entry: this is what navigation (go_router, auto_route, or imperative routes) should target.
- **`data/`** — Use for feature-local types that are not shared app-wide: presentation models, seed/mock lists, and lightweight glue types (e.g. placeholder rows before an API exists). Prefer **`package:app_name/...`** imports between `lib` files. Domain DTOs from another package stay outside this folder unless the feature owns a thin view-model wrapper.
- **`widgets/`** — Put internal widgets here; use **`part` / `part of`** from the route file for feature-private trees. **`part of`** in a subfolder must use a **relative path** to the library file (e.g. `part of '../bookings_page.dart';` from `feature/widgets/foo.dart`). Using only the basename (`part of 'bookings_page.dart';`) points at the wrong library and breaks the merge.
- **Route page (thin)** — The entry `.dart` file should mostly hold imports, `part` directives, and the root widget/state plus wiring (providers, callbacks). Push **scroll/body composition, layout toggles, and lists** into dedicated widgets in **`part`** files (or a named child widget class) so the route file does not combine seed data, multiple layout modes, and every leaf widget in one file.
- From the route page inward, prefer `part` / `part of` for internal widgets.
- Keep files small and single-purpose where possible.
- With `part of`, prefer private widget classes where possible.
- Provide blocs with `BlocProvider` at the root of the feature page unless there is a strong reason to provide higher in the tree.

## Auth bootstrap (apps using `app_bloc`)

- **`bootstrap()`** — Before `runApp`: load `app_config.json`, `Supabase.initialize`, `registerMiddleware(appConfig)`, attach `SupabaseAuthDioInterceptor` if needed, then **`registerAppBlocDependencies()`** (order is required; see `packages/app_bloc`).
- **Splash + `go_router`** — Initial route shows a short splash; first frame dispatches **`AuthEvent.checkRequested`**. Use **`refreshListenable`** wired to `AuthBloc.stream` (e.g. a small `ChangeNotifier` that listens to the stream) so **`redirect`** runs when the bloc reaches `authenticated` vs `unauthenticated`.
- **Redirects** — Keep protected routes (shell, profile) behind **`AuthState.authenticated`**; send **`AuthInitial` / `AuthLoading`** to splash (except stay on `/login` during sign-in **loading**).

## Layout and composition

- Prefer a new widget class over a method that returns `Widget` (subtree gets its own `BuildContext`).
- Reusable, multi-purpose widgets belong in the shared `lib/presentation/widgets/` folder (or existing shared widgets location).
- Prefer `const` constructors whenever possible.
- For lists, prefer `.builder` constructors (e.g. `ListView.builder`).
- Except for logout flows, prefer bottom sheets over dialogs/modals.

## Async and errors

- Handle errors in a uniform way; an error modal (or shared error surface) is usually appropriate.

## Theming

- Stay within an explicit style guide; if gaps exist, extend the guide rather than one-off styling.
- Avoid inline styling when theme or shared decoration can be used.
- Preserve readable contrast in dark mode.
- For container-style headers/sections, a leading left color accent (“sliver” / strip) is desirable when it fits the design.

## Quality

- Unit and golden tests are not required for this app unless the user asks.
- Linting targets:
  - Use package `very_good_analysis` (align `analysis_options.yaml` when adopting).
  - Formatter: `page_width: 120`.
  - Ignore generated files in lint/format as usual.

## Additional resources

- Patterns to keep from today’s Supra UI: [preserve.md](preserve.md)
- Longer notes and examples: [reference.md](reference.md)
