import 'package:flutter/material.dart';

class DsPasswordInput extends StatelessWidget {
  const DsPasswordInput({
    required this.controller,
    required this.label,
    this.validator,
    this.enabled = true,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: true,
      autofillHints: const [AutofillHints.password],
      enabled: enabled,
      validator: validator,
    );
  }
}
