# Convenciones del backend

El template es **agnóstico** de la convención de nombrado del JSON que expone tu backend. Podés optar entre tres casos:

## Caso 1: API camelCase (default del template)

Tu backend responde y acepta JSON con campos en `camelCase`:

```json
{ "fullName": "Lucía", "phoneNumber": "+54..." }
```

**Acción**: ninguna. `build.yaml` viene sin `field_rename`, los DTOs matchean 1:1 con el wire.

## Caso 2: API snake_case

Tu backend responde y acepta JSON con campos en `snake_case`:

```json
{ "full_name": "Lucía", "phone_number": "+54..." }
```

**Acción**: descomentá en `build.yaml`:

```yaml
targets:
  $default:
    builders:
      json_serializable:
        options:
          field_rename: snake   # ← activá esta línea
          explicit_to_json: true
```

Regenerá: `fvm dart run build_runner build --delete-conflicting-outputs`.

Ahora `json_serializable` convierte automáticamente `fullName` ↔ `full_name` en ambas direcciones (fromJson y toJson). No necesitás tocar tus DTOs.

## Caso 3: API mixta / legacy

Tu backend usa distintos estilos en distintos endpoints (raro pero pasa):

**Acción**: no toques `build.yaml`. Anotá los campos problemáticos con `@JsonKey`:

```dart
@freezed
abstract class MyDto with _$MyDto {
  const factory MyDto({
    @JsonKey(name: 'full_name') required String fullName,
    required String email,
  }) = _MyDto;

  factory MyDto.fromJson(Map<String, dynamic> json) => _$MyDtoFromJson(json);
}
```

## Recomendación

Elegí una convención para todo el proyecto y mantenela. Si controlás el backend, alineá: el mayor costo de mantenimiento lo tiene la inconsistencia.
