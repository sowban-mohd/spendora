import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/controller/finance_data_controller.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/core/theme/app_theme_colors.dart';
import 'package:spendora/core/utils/currency_formatter.dart';
import 'package:spendora/features/goals/controller/goals_page_controller.dart';

class GoalsPage extends ConsumerStatefulWidget {
  const GoalsPage({super.key});

  @override
  ConsumerState<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends ConsumerState<GoalsPage> {
  final _savingsController = TextEditingController();
  final _limitController = TextEditingController();
  final _noSpendController = TextEditingController();
  bool _seeded = false;

  @override
  void dispose() {
    _savingsController.dispose();
    _limitController.dispose();
    _noSpendController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final financeState = ref.watch(financeDataControllerProvider);
    final financeDataController = ref.watch(
      financeDataControllerProvider.notifier,
    );
    final pageState = ref.watch(goalsPageControllerProvider);
    final colors = context.appColors;

    final goal = financeState.goal;
    if (!_seeded) {
      _savingsController.text = goal.savingsTarget.toStringAsFixed(0);
      _limitController.text = goal.monthlyExpenseLimit.toStringAsFixed(0);
      _noSpendController.text = goal.noSpendTargetDays.toString();
      _seeded = true;
    }

    final expenses = financeDataController.currentMonthExpense;
    final savings = financeDataController.currentMonthSavings;
    final noSpendDays = financeDataController.currentMonthNoSpendDays;
    final savingsProgress = financeDataController.currentMonthSavingsProgress;
    final limitProgress =
        financeDataController.currentMonthExpenseLimitProgress;
    final challengeProgress =
        financeDataController.currentMonthNoSpendChallengeProgress;

    if (pageState.alertMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(pageState.alertMessage!.message)),
        );
        ref.watch(goalsPageControllerProvider.notifier).clearAlertMessage();
      });
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
        children: [
          Text(
            'Goals and challenges',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Keep your month grounded with one clear savings target and a no-spend rhythm.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.textMuted),
          ),
          const SizedBox(height: 18),
          _ProgressCard(
            title: 'Savings goal',
            subtitle: '${formatCurrency(savings)} saved so far',
            progress: savingsProgress,
            progressLabel:
                '${formatCurrency(goal.savingsTarget)} target for this month',
            color: AppColors.income,
          ),
          const SizedBox(height: 14),
          _ProgressCard(
            title: 'Expense limit',
            subtitle: '${formatCurrency(expenses)} spent so far',
            progress: limitProgress,
            progressLabel:
                '${formatCurrency(goal.monthlyExpenseLimit)} monthly ceiling',
            color: AppColors.expense,
          ),
          const SizedBox(height: 14),
          _ProgressCard(
            title: 'No-spend challenge',
            subtitle: '$noSpendDays clean days this month',
            progress: challengeProgress,
            progressLabel: '${goal.noSpendTargetDays} target days',
            color: AppColors.chartBlue,
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: colors.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Update monthly focus',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _savingsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Savings target',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _limitController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Expense limit'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _noSpendController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'No-spend target days',
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: pageState.isSaving
                      ? null
                      : () async {
                          await ref
                              .read(goalsPageControllerProvider.notifier)
                              .saveGoal(
                                savingsTarget: _savingsController.text,
                                monthlyLimit: _limitController.text,
                                noSpendTargetDays: _noSpendController.text,
                              );
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      pageState.isSaving ? 'Saving...' : 'Save goals',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final String progressLabel;
  final Color color;

  const _ProgressCard({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.progressLabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.textMuted),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            borderRadius: BorderRadius.circular(999),
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation(color),
          ),
          const SizedBox(height: 8),
          Text(
            progressLabel,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}
