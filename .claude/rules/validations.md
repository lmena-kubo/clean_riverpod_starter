# Sistema de Validaciones

## Regla fundamental
Las entities NO validan. Prohibido:
- entity.isValid()
- entity.validate()
- Cualquier método de validación dentro de una Entity

## Estructura
- Validaciones genéricas:  lib/app/shared/validations/core_validation_service.dart
- Validaciones por módulo: lib/features/[x]/domain/validation/[x]_validation_service.dart

## Patrón
class CoreValidationService {
  static String? validateEmail(String? value) { ... }
  static String? validateRequired(String? value) { ... }
}

class UserValidationService {
  static String? validateUsername(String? value) { ... }
}

## Cuándo usar cada uno
- CoreValidationService: validaciones reutilizables (email, teléfono, campos requeridos)
- [Module]ValidationService: reglas específicas del dominio del módulo

## En formularios Flutter
Referenciar el servicio desde la View, no inline en el widget:
  validator: (v) => UserValidationService.validateUsername(v)