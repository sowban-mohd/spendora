import 'package:flutter/material.dart';
import 'package:spendora/core/theme/app_theme_colors.dart';

class EmptyStateCard extends StatelessWidget {
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback? onPressed;

  const EmptyStateCard({
    super.key,
    required this.title,
    required this.message,
    this.buttonLabel = 'Take action',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textMuted,
                ),
          ),
          if (onPressed != null) ...[
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onPressed,
              child: Text(buttonLabel),
            ),
          ],
        ],
      ),
    );
  }
}
