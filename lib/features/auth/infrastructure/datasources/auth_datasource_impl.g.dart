// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_datasource_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authDatasource)
final authDatasourceProvider = AuthDatasourceProvider._();

final class AuthDatasourceProvider
    extends
        $FunctionalProvider<IAuthDatasource, IAuthDatasource, IAuthDatasource>
    with $Provider<IAuthDatasource> {
  AuthDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authDatasourceHash();

  @$internal
  @override
  $ProviderElement<IAuthDatasource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IAuthDatasource create(Ref ref) {
    return authDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IAuthDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IAuthDatasource>(value),
    );
  }
}

String _$authDatasourceHash() => r'7b6b49263465b6513d0b7b6fe58adf21108af373';
