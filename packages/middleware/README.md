Orchestration layer and **sole entrypoint** to `client_*` packages.

### What this package does

- **Config propagation**: takes `client_models` `AppConfig` and derives per-client configs (e.g. `client_supabase` `SupabaseConfig`) via `ClientConfigs`.
- **Mappings**: uses AutoMappr for config/model conversion.
- **DI / access point**: exposes a single `registerMiddleware(AppConfig)` entrypoint for initialization.

### Quick start

```bash
dart run middleware path/to/app_config.json
```
