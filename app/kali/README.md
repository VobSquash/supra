# kali

Jaspr (client/SPA) app for the web admin portal.

## Prerequisites

- [Dart SDK](https://dart.dev/get-dart) (**`^3.10.9`**, aligned with `app_bloc` / middleware).
- [Jaspr CLI](https://pub.dev/packages/jaspr_cli): `dart pub global activate jaspr_cli`

Dependencies are pinned so **`jaspr`**, **`jaspr_router`**, and **`jaspr_cli`** stay on compatible major/minor versions. If you upgrade to Jaspr **0.23.x**, use **`jaspr_cli` 0.23.x**, which requires a **Dart 3.11+** SDK (CLI resolution fails on Dart 3.10).

```bash
cd app/kali
dart pub get
```

## Configuration

Place an **`app_config.json`** beside your static assets (**`web/app_config.json`**). It uses the same shape as **`client_models`** / Dupra (**`supabase_url`**, **`anon_key`**, legacy Back4App fields, …). At runtime the client fetches it from **`/app_config.json`** (resolved from **`Uri.base`**).

## Authentication

Kali wires the **same stack as Dupra**:

- **`registerMiddleware`** + **`SupabaseClient`** (pure Dart **`supabase`**: **`BrowserGotrueStorage`** is for PKCE verifiers only; the full auth session JSON is mirrored to **`localStorage`** under **`sb-<project-ref>-auth-token`**, matching **`supabase_flutter`** on web when both apps use the same Supabase URL).
- **`registerAppBlocDependencies`** → **`AuthBloc`** (**`packages/app_bloc`**).
- Email/password **`AuthBloc`** events match Dupra (**base64-encoded password** handled inside middleware).

Unauthenticated visits are **`Router.redirect`**-ed to **`/login`**; **`/splash`** covers the **`AuthBloc` initial / loading** window. Signed-in **`SessionSnapshot.displayName`** (or email fallback) appears in the app bar together with **Sign out**.

## Running locally

CLI (defaults Jaspr/WebDev ports **8080**, **5467**, **5567**):

```bash
dart run jaspr_cli:jaspr serve
```

Open [http://localhost:8080](http://localhost:8080).

From the repo root in VS Code / Cursor, use **“Kali (jaspr serve)”**. It delegates to `dart run jaspr_cli:jaspr serve` and passes **`--web-port 15467`** / **`--proxy-port 15567`** so Kali does not fight another Jaspr/other tool using the stock **5467** / **5567** DWDS ports.

### Port already in use (`SocketException` / bind failed)

That error means something is already listening on one of Jaspr’s ports (main **`8080`**, internal **`5467`** and **`5567`** by default, or whatever you passed).

1. **Stop the leftover process**: focus the terminal where `jaspr serve` is running and use **Ctrl+C**. If unsure, find listeners:
   ```bash
   lsof -nP -iTCP:8080 -sTCP:LISTEN
   lsof -nP -iTCP:5467 -sTCP:LISTEN
   lsof -nP -iTCP:5567 -sTCP:LISTEN
   lsof -nP -iTCP:15467 -sTCP:LISTEN
   lsof -nP -iTCP:15567 -sTCP:LISTEN
   ```
   then `kill <pid>` (or **Ctrl+C** in that terminal).
2. Avoid starting **`jaspr serve` twice**: the IDE “run” button can launch a **second** server while the first still holds ports.
3. Second instance / different URLs: **`“Kali (jaspr serve, alt ports)”`** uses **8090** + **15468** / **15568**, or from the CLI:  
   `dart run jaspr_cli:jaspr serve --web-port 5478 --proxy-port 5578 -p 8090`  
   and open [http://localhost:8090](http://localhost:8090).

## Production build

```bash
jaspr build
```

Output is under **`build/jaspr/`** (compiled JS, `index.html`, CSS, assets). Deploy that folder to static hosting (e.g. GitHub Pages).
