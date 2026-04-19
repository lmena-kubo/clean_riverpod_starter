// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_action.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginAction)
final loginActionProvider = LoginActionProvider._();

final class LoginActionProvider
    extends $NotifierProvider<LoginAction, AsyncValue<void>> {
  LoginActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginActionHash();

  @$internal
  @override
  LoginAction create() => LoginAction();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$loginActionHash() => r'03e53c6d24ddc30f06076ef692bc1ab98562eb8d';

abstract class _$LoginAction extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
