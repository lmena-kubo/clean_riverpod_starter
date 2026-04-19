import 'package:clean_riverpod_starter/app/app.dart';
import 'package:clean_riverpod_starter/core/env/env.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  Env.assertValid();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
