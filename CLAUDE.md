# Clean Riverpod Starter

Flutter starter con Clean Architecture + Riverpod 3 + go_router + Dio + freezed. Viene pre-configurado con flavors (STG/PROD), Design System base, manejo de errores tipado, y hooks de calidad local vía `lefthook`.

## Leé antes de arrancar

Si es la primera vez que usás este template: [`docs/GETTING_STARTED.md`](docs/GETTING_STARTED.md).

## Reglas vivas del proyecto

Leer **antes** de escribir código que toque el área correspondiente:

- [`.claude/rules/dart-style.md`](.claude/rules/dart-style.md) — nombrado, imports, `const`, comentarios, prohibiciones generales.
- [`.claude/rules/widget-composition.md`](.claude/rules/widget-composition.md) — jerarquía `View → Section → UIWidget` y dónde van los formatters.
- [`.claude/rules/validations.md`](.claude/rules/validations.md) — validaciones fuera de entities; `CoreValidationService` vs validations por módulo.
- [`.claude/rules/arquitectura-explicada.md`](.claude/rules/arquitectura-explicada.md) — Clean Architecture aplicada con Riverpod 3. **Fuente de verdad** de la arquitectura.

## Stack fijado

- Flutter + Dart SDK `^3.10.0`.
- Estado + DI: `flutter_riverpod` `^3.3.1` con code-gen obligatorio (`@riverpod`).
- Routing: `go_router` con `refreshListenable` alimentado por `ref.listen`.
- HTTP: `dio` detrás de un `ApiService` wrapper (los datasources nunca tocan Dio directo).
- Persistencia: `flutter_secure_storage` (solo JWT del backend).
- Modelado: `freezed` + `json_serializable`.
- Lints: `very_good_analysis`. `riverpod_lint` + `custom_lint` pausados hasta que `custom_lint` soporte `analyzer ^9.0.0` (bloquea a `riverpod_generator 4.x`). Las reglas se enforzan vía `.claude/rules/arquitectura-explicada.md`.
- Tests: `mocktail`.
- Flavors: STG / PROD vía `--dart-define-from-file`.
- Calidad local: `lefthook` (hooks de git locales). Tras clonar: `lefthook install` (una vez).

## Convención del backend: camelCase vs snake_case

El `build.yaml` trae `field_rename: snake` **comentado** por default (asume camelCase en el wire). Si tu backend responde snake_case, descomentá esa línea. Detalle completo en [`docs/BACKEND_CONVENTIONS.md`](docs/BACKEND_CONVENTIONS.md).

## Fuera del stack — no introducir sin evaluar

`get_it`, `injectable`, `fpdart`, `dartz`, `drift`, `isar`, y el API `Mutation` de Riverpod 3 (aún experimental). El template es minimalista a propósito — agregá deps solo cuando una feature lo requiera.

## Reglas transversales no negociables

- **Comentarios**: solo el "por qué". Nunca describir el "qué". No narrar código autoexplicativo.
- **`try/catch`**: solo en `repositories/impl`. Prohibido en `UseCase`, `Notifier` y `View`.
- **Errores**: el repositorio lanza excepciones de dominio tipadas (`AuthFailure`, `NetworkFailure`, …). El `AsyncNotifier` las captura con `AsyncValue.guard`. No se usa `Either` ni wrappers.
- **Providers**: solo `Notifier` / `AsyncNotifier` con `@riverpod`. Legacy (`StateProvider`, `StateNotifier`) prohibido.
- **`ref.mounted`**: verificar después de cada `await` dentro de un notifier antes de tocar `state`.
- **UI**: `ref.watch(p).when(...)` para dibujar; `ref.listen(p, ...)` para efectos efímeros (toasts, navegación).

## Estructura

Feature-first. Las tres capas de cada feature son `domain/`, `infrastructure/`, `presentation/` (el término "infrastructure" respeta el vocabulario de `arquitectura-explicada.md`).

```
lib/
  main_stg.dart     # entrypoint flavor STG (por convención Flutter, mains en lib/ root)
  main_prod.dart    # entrypoint flavor PROD
  app/              # bootstrap, App widget, router
  core/             # env, network, storage, errors, validations
  design_system/    # tokens, theme, atoms, molecules, organisms
  features/
    auth/           # feature de ejemplo (login contra REST, Clean Architecture completa)
    home/           # placeholder post-login
  l10n/
```

## Feature `auth` como ejemplo canónico

Este template trae la feature `auth` completa como **plantilla de referencia**. Cubre:
- Domain: entities (`User`, `AuthSession`), ports (`IAuthRepository`, `IAuthDatasource`), use case.
- Infrastructure: DTOs con freezed/json_serializable, datasource con Dio, repository con `try/catch` único.
- Presentation: `AuthController` (auth state), `LoginAction` (acción de submit), `LoginView` con atoms del DS.
- Router: guard con `refreshListenable`.

Copiá esta feature como referencia cuando crees features nuevas.
