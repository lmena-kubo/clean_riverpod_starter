# clean_riverpod_starter

Flutter starter con Clean Architecture + Riverpod 3 + go_router + Dio + freezed. Viene configurado con flavors (STG/PROD), Design System base, manejo de errores tipado, y hooks de calidad local.

## Uso rápido

```bash
fvm install
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs
lefthook install
fvm flutter run --flavor stg --dart-define-from-file=env/stg.json -t lib/main_stg.dart
```

## Documentación

- [`docs/GETTING_STARTED.md`](docs/GETTING_STARTED.md) — cómo adaptar el template para un proyecto nuevo.
- [`docs/BACKEND_CONVENTIONS.md`](docs/BACKEND_CONVENTIONS.md) — camelCase vs snake_case.
- [`CLAUDE.md`](CLAUDE.md) — stack fijado + reglas transversales.
- [`.claude/rules/arquitectura-explicada.md`](.claude/rules/arquitectura-explicada.md) — Clean Architecture aplicada con Riverpod 3.
