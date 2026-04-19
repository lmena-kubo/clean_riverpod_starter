import 'package:flutter/material.dart';

class DsTextInput extends StatelessWidget {
  const DsTextInput({
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType,
    this.autofillHints,
    this.enabled = true,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      enabled: enabled,
      validator: validator,
    );
  }
}
