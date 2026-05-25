Orchestration layer and **sole entrypoint** to `client_*` packages.

### What this package does

- **Config propagation**: takes `client_models` `AppConfig` and derives per-client configs (e.g. `client_supabase` `SupabaseConfig`) via `ClientConfigs`.
- **Mappings**: uses AutoMappr for config/model conversion.
- **DI / access point**: exposes `registerMiddleware(AppConfig, {SupabaseClient? supabaseClient})` — pass the host app’s authenticated `SupabaseClient` (`Supabase.instance.client` after Flutter `Supabase.initialize`, or a pure-Dart client for Jaspr/Vue/etc.).

### Quick start

```bash
dart run middleware path/to/app_config.json
```
