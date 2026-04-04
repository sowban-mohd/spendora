import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/services/shared_preferences_provider.dart';

final themeModeControllerProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(
      ThemeModeController.new,
    );

class ThemeModeController extends Notifier<ThemeMode> {
  static const _themeModeKey = 'theme_mode';

  @override
  ThemeMode build() {
    final sharedPreferences = ref.read(sharedPreferencesProvider);
    final storedValue = sharedPreferences.getString(_themeModeKey);

    return switch (storedValue) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.light,
    };
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    ref
        .read(sharedPreferencesProvider)
        .setString(_themeModeKey, _serializeThemeMode(mode));
  }

  String _serializeThemeMode(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
    };
  }
}
