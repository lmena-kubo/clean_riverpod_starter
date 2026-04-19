// Tokens nombrados por valor hex (paleta plana) para matchear 1:1 con el
// design system del diseñador. Dart no permite identificadores que empiecen
// con dígito; prefijamos con `c`. Preservamos mayúsculas del hex original.
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

abstract final class DsColors {
  static const Color c00796B = Color(0xFF00796B);
  static const Color cBA1A1A = Color(0xFFBA1A1A);
}
