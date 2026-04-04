import 'package:flutter/material.dart';
import 'package:spendora/core/models/alert_message.dart';
import 'package:spendora/core/theme/app_theme_colors.dart';

class AppErrorState extends StatelessWidget {
  final AlertMessage alertMessage;
  final VoidCallback onRetry;

  const AppErrorState({
    super.key,
    required this.alertMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              alertMessage.header,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              alertMessage.message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textMuted,
                  ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
