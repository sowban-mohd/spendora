import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/controller/theme_mode_controller.dart';
import 'package:spendora/core/theme/app_theme_colors.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider);
    final isDarkMode = themeMode == ThemeMode.dark;
    final colors = context.appColors;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Adjust the app experience to match your preference.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: colors.outline),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dark mode',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isDarkMode
                            ? 'Spendora is using the dark theme.'
                            : 'Spendora is using the light theme.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    ref
                        .read(themeModeControllerProvider.notifier)
                        .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
