# Branded Supabase auth emails

Supabase sends **Confirm signup**, **Magic link**, **Reset password**, **Change email**, etc. Those messages are **not** rendered by the Flutter app. You customise them in the Supabase project (or in `config.toml` when self-hosting / local CLI).

## Apply on hosted Supabase

1. Open [Authentication → Email Templates](https://supabase.com/dashboard/project/_/auth/templates) for your project.
2. Pick a template (e.g. **Reset password**).
3. Paste the HTML from the matching file in this folder into the template body.
4. Set the **Subject** — see the table below (each HTML file’s top comment repeats it).
5. Save.

Branding uses the **VOB Squash** light logo on a **light** header so the asset reads clearly; primary actions use **navy** `#132743` with a thin **cyan** accent strip to align with the app.

## Sender “from” name and reply-to

By default mail comes from Supabase’s shared sender. For a custom **From** domain, SPF, and reply routing, configure **Authentication → SMTP Settings** (custom SMTP) in the dashboard.

## Links still going to localhost

Email links use your project’s **Site URL** and **Redirect URLs** under [Authentication → URL Configuration](https://supabase.com/dashboard/project/_/auth/url-configuration). Set **Site URL** to your real app or landing URL, and add every redirect you use (including app deep links) to **Redirect allow list**.

Pass `redirectTo` from the app when calling `resetPasswordForEmail` so the recovery link respects your production URL (that URL must be in the allow list).

## Variables

Templates use Supabase [Go template variables](https://supabase.com/docs/guides/auth/auth-email-templates), e.g. `{{ .ConfirmationURL }}`, `{{ .SiteURL }}`, `{{ .Email }}`, `{{ .RedirectTo }}`.

For magic links / signup, `{{ .Token }}` is available if you prefer a 6-digit OTP instead of a single click-through URL (helps with link prefetchers).

**Reset password (`branded_recovery.html`):** The body includes **`{{ .Token }}`** so GoTrue sends a numeric code for in-app verification (`verifyOTP` with `OtpType.recovery`). The **`{{ .ConfirmationURL }}`** block remains optional for browser-based resets.

## Files

| File | Dashboard template name | Subject line to paste |
|------|-------------------------|------------------------|
| `branded_recovery.html` | Reset password | `Vob Account Password Reset` |
| `branded_magic_link.html` | Magic link | `VOB Squash — your sign-in link` (or your preference) |
| `branded_confirm_signup.html` | Confirm signup | `VOB Squash — confirm your email` |
| `branded_email_change.html` | Change email address | `VOB Squash — confirm your new email` |

Auth email templates: **do not** use Supabase Storage public URLs (`*.supabase.co/...`) for `<img src>` — validation/sanitization can remove `src` entirely ([dashboard URI checks / consonant-heavy hostnames](https://github.com/supabase/supabase/issues/36946)). Host the logo on **GitHub raw**, **`api.vobsquash.co.za`**, or similar; `branded_recovery.html` follows the same GitHub raw pattern as `app/supra/assets/html/general_mail.html`.

Security notification emails (password changed, etc.) can be styled the same way under **Authentication** if you enable those notifications.
