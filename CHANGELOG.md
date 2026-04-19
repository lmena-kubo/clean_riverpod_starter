# Changelog

Todas las mejoras relevantes de este template se documentan acá.

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y el versionado sigue [SemVer](https://semver.org/lang/es/).

## [Unreleased]

### Added
- Sección "Usar como template" y "Cómo subir mejoras" en el README.
- Este `CHANGELOG.md`.

## [1.0.0] - 2026-04-18

### Added
- Stack base: Flutter `^3.10.0`, `flutter_riverpod` `^3.3.1` con code-gen, `go_router`, `dio`, `freezed`, `flutter_secure_storage`.
- Flavors STG / PROD vía `--dart-define-from-file` (`env/stg.json`, `env/prod.json`).
- Arquitectura Clean documentada en `.claude/rules/arquitectura-explicada.md` (domain / infrastructure / presentation).
- Feature `auth` como plantilla canónica: entities, ports, use case, DTOs, datasource Dio, repository con `try/catch` único y `AuthController` con `AsyncValue.guard`.
- `core/errors` con `ApiExceptionHandler` y failures tipados (`AuthFailure`, `NetworkFailure`, `UnknownFailure`).
- Design System base: tokens, theme, atoms / molecules / organisms.
- Guard de router con `refreshListenable` alimentado por `ref.listen`.
- Reglas vivas del proyecto en `.claude/rules/` (dart-style, widget-composition, validations).
- Hooks de calidad local vía `lefthook`.
- Documentación inicial: `README.md`, `docs/GETTING_STARTED.md`, `docs/BACKEND_CONVENTIONS.md`, `CLAUDE.md`.

### Removed
- Feature placeholders específicos de VetApp (patients, consultation, recording) removidos del template base.

[Unreleased]: https://github.com/lmena-kubo/clean_riverpod_starter/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/lmena-kubo/clean_riverpod_starter/releases/tag/v1.0.0
