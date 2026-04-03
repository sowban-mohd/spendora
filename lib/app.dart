import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/routes/router_provider.dart';
import 'package:spendora/core/theme/app_theme.dart';

class SpendoraApp extends ConsumerWidget {
  const SpendoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Spendora',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
