abstract final class Env {
  static const String flavor = String.fromEnvironment('FLAVOR');
  static const String baseUrl = String.fromEnvironment('BASE_URL');
  static const bool enableLogs = bool.fromEnvironment('ENABLE_LOGS');

  static bool get isStg => flavor == 'stg';
  static bool get isProd => flavor == 'prod';

  static void assertValid() {
    assert(
      flavor.isNotEmpty,
      'FLAVOR no está definido. ¿Corriste con --dart-define-from-file=env/<flavor>.json?',
    );
    assert(
      baseUrl.isNotEmpty,
      'BASE_URL no está definido. ¿Corriste con --dart-define-from-file=env/<flavor>.json?',
    );
  }
}
