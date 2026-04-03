import 'package:flutter/material.dart';
import 'package:spendora/core/theme/app_colors.dart';

class AppLoadingState extends StatelessWidget {
  final String title;

  const AppLoadingState({
    super.key,
    this.title = 'Loading your money view...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}
