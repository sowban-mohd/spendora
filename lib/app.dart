import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/controller/theme_mode_controller.dart';
import 'package:spendora/core/routes/router_provider.dart';
import 'package:spendora/core/theme/app_theme.dart';

class SpendoraApp extends ConsumerWidget {
  const SpendoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeControllerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Spendora',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
