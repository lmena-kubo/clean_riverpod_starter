# Arquitectura Clean — Explicación simple

---

## Capa de Dominio

Es el corazón de la app. Define **qué se necesita**, sin importar cómo ni de dónde viene.

### Interfaz del Datasource
Le dice a la infraestructura: *"quien quiera ser mi fuente de datos, debe saber hacer esto"*.
El dominio no sabe si el dato viene de una API, de un archivo local o de un mock — solo le importa que alguien se lo entregue.

```dart
// Contrato: "alguien me tiene que dar un token, no me importa cómo"
abstract interface class IAuthDatasource {
  Future<String> generateAccessToken();
}
```

### Interfaz del Repository
Le dice a los casos de uso: *"quien quiera ser mi repositorio, debe saber ejecutar esta operación"*.
El dominio no sabe si el token se guarda en disco, en memoria o en la nube — solo le importa que la operación se complete o falle con una excepción de dominio tipada.

```dart
// Contrato: "alguien me tiene que ejecutar esto; si algo sale mal, me lanza una excepción de dominio"
abstract interface class IAuthRepository {
  Future<void> generateAccessToken();
}
```

Si algo falla, el repositorio **lanza** una excepción de dominio (`AuthFailure`, `NetworkFailure`, etc.). La capa de presentación la captura con `AsyncValue.guard`. No usamos `Either` ni wrappers — el mecanismo de errores es Dart puro.

### UseCase
Aplica la regla de negocio. En la mayoría de casos solo delega, pero es el punto donde
se podría agregar lógica pura (validaciones, transformaciones) sin tocar la UI ni la API.

```dart
class GenerateAccessTokenUseCase {
  Future<void> call() => _repository.generateAccessToken();
}
```

---

## Capa de Infraestructura

Aquí vive el **cómo**. Es la única capa que conoce Dio, JSON, SecureStorage, APIs externas.

### api/ — Directorio de endpoints
Solo constantes. No hace nada, solo nombra las rutas para que si el backend cambia una URL,
haya un único lugar donde corregirlo.

```dart
class AuthApi {
  static const String generateAccessToken = 'mis/generate-access-token';
}
```

### datasources/impl — El que va a buscar el dato
Implementa la interfaz del dominio. Su única responsabilidad es hablar con la fuente externa
y devolver el dato crudo. **No maneja errores**, si algo falla lanza la excepción hacia arriba.

```
API → JSON → dato crudo (String, lista, objeto)
```

```dart
// Habla con la API, parsea el JSON, entrega el dato
class AuthDatasourceImpl implements IAuthDatasource {
  @override
  Future<String> generateAccessToken() async {
    final response = await _apiService.get(AuthApi.generateAccessToken);
    final apiResponse = ApiResponse.fromJson(response.data, ...);
    return apiResponse.data!['accessToken'] as String;
  }
}
```

### repositories/impl — El coordinador
Implementa la interfaz del repository. Es el **único lugar con try/catch** en toda la app.
Su trabajo: orquestar datasource + persistencia, y **traducir** errores crudos de infraestructura (Dio, parseo, storage) en excepciones de dominio tipadas que el resto de capas pueda entender.

```
llama al datasource → usa el dato → completa, o lanza excepción de dominio
```

```dart
class AuthRepositoryImpl implements IAuthRepository {
  @override
  Future<void> generateAccessToken() async {
    try {
      final token = await _datasource.generateAccessToken();
      await _storage.setAccessToken(token);
    } catch (e) {
      throw ApiExceptionHandler.handle(e);
    }
  }
}
```

`ApiExceptionHandler` vive en `lib/core/errors/` y transforma cualquier error crudo (`DioException`, `FormatException`, errores de storage) en una excepción de dominio (`AuthFailure`, `NetworkFailure`, `UnknownFailure`). La capa de presentación solo ve estas excepciones tipadas, nunca el detalle de infraestructura.

---

## Capa de Presentación

Aquí vive la UI y el estado. **No conoce Dio, no conoce JSON, no hace try/catch.** Los únicos errores que llegan acá son excepciones de dominio tipadas, y los captura `AsyncValue.guard`.

### providers/di/ — El ensamblador
Construye y conecta todas las piezas usando Riverpod 3 con code-generation.
Funciona como un mapa de *"cuando alguien pida X, entrégale Y construido con Z"*.

```
apiServiceProvider ──────────────────────────────┐
                                                  ▼
                                       AuthDatasourceImpl
                                                  │
secureStorageServiceProvider ──────► AuthRepositoryImpl
                                                  │
                                    GenerateAccessTokenUseCase
```

Cada `@riverpod` es una **función** (o un `Notifier`/`AsyncNotifier`) que describe cómo construir una pieza. `build_runner` lee la anotación y genera el archivo `.g.dart` con el provider real:

```dart
@riverpod
AuthDatasource authDatasource(Ref ref) =>
    AuthDatasourceImpl(ref.watch(apiServiceProvider));

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
      datasource: ref.watch(authDatasourceProvider),
      storage: ref.watch(secureStorageServiceProvider),
    );

@riverpod
GenerateAccessTokenUseCase generateAccessTokenUseCase(Ref ref) =>
    GenerateAccessTokenUseCase(ref.watch(authRepositoryProvider));
```

### ¿Qué es Riverpod y por qué `@riverpod`?

Riverpod 3 es el **contenedor de estado y dependencias** de la app. Funciona como una heladera:

- Registrás cosas con `@riverpod` → *"en esta heladera hay leche"*
- Cualquiera las pide con `ref.watch` / `ref.read` / `ref.listen` → *"dame la leche"*
- Riverpod decide si crearla nueva o entregar la que ya existe

**Regla estricta**: usamos **solo** `Notifier` y `AsyncNotifier`. Los legacy `StateProvider` y `StateNotifier` están prohibidos.

### controllers/ — El que coordina la acción y expone el estado

Las acciones (login, cargar datos, POST de audio) no se disparan directamente contra el use case desde la View. Viven en un `AsyncNotifier` que:

1. Expone un `AsyncValue<T>` con estados `loading` / `data` / `error`.
2. Envuelve la llamada al use case con `AsyncValue.guard`, que captura cualquier excepción lanzada por el repository y la transforma en `AsyncError` automáticamente — **sin `try/catch`**.
3. Usa `ref.mounted` después de cada `await` para evitar escribir estado sobre un notifier ya destruido.

```dart
@riverpod
class AuthController extends _$AuthController {
  @override
  Future<void> build() async {}

  Future<void> generateAccessToken() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(generateAccessTokenUseCaseProvider)(),
    );
    if (!ref.mounted) return;
    state = result;
  }
}
```

Dos formas de disparar la acción:

- **Auto-fire en `build()`** — la lógica se pone directamente en `Future<T> build()`. Se ejecuta en el primer `watch` del provider. Ideal para bootstrap (splash que obtiene el token al iniciar la app).
- **Disparo manual desde la View** — la View llama un método del notifier (`ref.read(authControllerProvider.notifier).generateAccessToken()`). Ideal para acciones en respuesta a input del usuario (tap en botón de login).

### views/ — El que observa y reacciona

La View ya no dispara fire-and-forget; observa el estado del controller y reacciona.

```dart
class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (prev, next) {
      next.whenOrNull(
        data: (_) => context.go('/home'),
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        ),
      );
    });

    return state.when(
      loading: () => const SplashLoading(),
      error: (e, _) => SplashError(message: '$e'),
      data: (_) => const SizedBox.shrink(),
    );
  }
}
```

### Guía rápida: `ref.watch` vs `ref.read` vs `ref.listen`

| Método | Cuándo | Reconstruye UI | Ejemplo |
|---|---|---|---|
| `ref.watch` | Dentro de `build()` para obtener estado reactivo | Sí | `ref.watch(authControllerProvider)` |
| `ref.read` | Para disparar una acción puntual (callbacks, `onPressed`) | No | `ref.read(ctrl.notifier).login()` |
| `ref.listen` | Efectos efímeros: navegación, snackbars, toasts | No | `ref.listen(p, (prev, next) => ...)` |

---

## Flujo completo — ejemplo accessToken

### Caso exitoso
```
SplashView.build → ref.watch(authControllerProvider)
  └─ AuthController.build() se dispara en el primer watch
       └─ AsyncValue.guard(() => generateAccessTokenUseCase())
            └─ GenerateAccessTokenUseCase.call()
                 └─ AuthRepositoryImpl.generateAccessToken()
                      ├─ AuthDatasourceImpl.generateAccessToken()
                      │    └─ GET mis/generate-access-token
                      │         └─ { "data": { "accessToken": "eyJhbG..." } }
                      ├─ SecureStorageService.setAccessToken("eyJhbG...")
                      └─ Future<void> completa
                           └─ state = AsyncData(null)
                                └─ SplashView reacciona (ref.listen) → navega a /home
```

### Caso error
```
AuthRepositoryImpl captura DioException
  └─ throw ApiExceptionHandler.handle(e) (AuthFailure / NetworkFailure / ...)
       └─ AsyncValue.guard la atrapa
            └─ state = AsyncError(failure, stackTrace)
                 └─ SplashView reacciona → SnackBar o pantalla de error
```

Cada capa hace **una sola cosa** y no sabe qué hay arriba ni abajo de ella.
