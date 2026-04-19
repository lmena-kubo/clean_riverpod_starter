import 'package:clean_riverpod_starter/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App shows loading indicator on boot', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
