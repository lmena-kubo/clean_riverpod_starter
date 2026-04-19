abstract final class CoreValidationService {
  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? validateRequired(
    String? value, {
    String fieldName = 'Campo',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    final required = validateRequired(value, fieldName: 'Email');
    if (required != null) return required;
    if (!_emailRegex.hasMatch(value!.trim())) {
      return 'Email inválido';
    }
    return null;
  }

  static String? validateMinLength(
    String? value,
    int min, {
    String fieldName = 'Campo',
  }) {
    final required = validateRequired(value, fieldName: fieldName);
    if (required != null) return required;
    if (value!.length < min) {
      return '$fieldName debe tener al menos $min caracteres';
    }
    return null;
  }
}
