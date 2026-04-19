import 'package:clean_riverpod_starter/core/validations/core_validation_service.dart';
import 'package:clean_riverpod_starter/design_system/atoms/ds_password_input.dart';
import 'package:clean_riverpod_starter/design_system/atoms/ds_primary_button.dart';
import 'package:clean_riverpod_starter/design_system/atoms/ds_text_input.dart';
import 'package:clean_riverpod_starter/features/auth/presentation/controllers/login_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(loginActionProvider.notifier).submit(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(loginActionProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        ),
      );
    });

    final isLoading = ref.watch(loginActionProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Ingresar')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DsTextInput(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                validator: CoreValidationService.validateEmail,
                enabled: !isLoading,
              ),
              const SizedBox(height: 16),
              DsPasswordInput(
                controller: _passwordController,
                label: 'Contraseña',
                validator: (v) => CoreValidationService.validateMinLength(
                  v,
                  6,
                  fieldName: 'Contraseña',
                ),
                enabled: !isLoading,
              ),
              const SizedBox(height: 32),
              DsPrimaryButton(
                label: 'Ingresar',
                isLoading: isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
