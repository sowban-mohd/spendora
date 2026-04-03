import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/controller/finance_data_controller.dart';
import 'package:spendora/core/models/finance_transaction.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/core/utils/currency_formatter.dart';
import 'package:spendora/core/widgets/app_error_state.dart';
import 'package:spendora/core/widgets/app_loading_state.dart';
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
    final pageState = ref.watch(goalsPageControllerProvider);

    if (financeState.isLoading) {
      return const SafeArea(child: AppLoadingState());
    }
    if (financeState.errorMessage != null) {
      return SafeArea(
        child: AppErrorState(
          alertMessage: financeState.errorMessage!,
          onRetry: () => ref.watch(financeDataControllerProvider.notifier).reloadData(),
        ),
      );
    }

    final goal = financeState.goal;
    if (!_seeded) {
      _savingsController.text = goal.savingsTarget.toStringAsFixed(0);
      _limitController.text = goal.monthlyExpenseLimit.toStringAsFixed(0);
      _noSpendController.text = goal.noSpendTargetDays.toString();
      _seeded = true;
    }

    final currentMonthTransactions = financeState.transactions
        .where(
          (item) =>
              item.date.year == DateTime.now().year &&
              item.date.month == DateTime.now().month,
        )
        .toList();
    final income = currentMonthTransactions
        .where((item) => item.type == TransactionType.income)
        .fold<double>(0, (sum, item) => sum + item.amount);
    final expenses = currentMonthTransactions
        .where((item) => item.type == TransactionType.expense)
        .fold<double>(0, (sum, item) => sum + item.amount);
    final savings = income - expenses;
    final noSpendDays = _countNoSpendDays(currentMonthTransactions);
    final savingsProgress = (savings / goal.savingsTarget).clamp(0, 1).toDouble();
    final limitProgress = (expenses / goal.monthlyExpenseLimit).clamp(0, 1).toDouble();
    final challengeProgress = goal.noSpendTargetDays == 0
        ? 0.0
        : (noSpendDays / goal.noSpendTargetDays).clamp(0, 1).toDouble();

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
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Keep your month grounded with one clear savings target and a no-spend rhythm.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
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
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.outline),
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
                  decoration: const InputDecoration(labelText: 'Savings target'),
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
                  decoration: const InputDecoration(labelText: 'No-spend target days'),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: pageState.isSaving
                      ? null
                      : () async {
                          await ref.read(goalsPageControllerProvider.notifier).saveGoal(
                                savingsTarget: _savingsController.text,
                                monthlyLimit: _limitController.text,
                                noSpendTargetDays: _noSpendController.text,
                              );
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(pageState.isSaving ? 'Saving...' : 'Save goals'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _countNoSpendDays(List<FinanceTransaction> transactions) {
    final expenseDays = transactions
        .where((item) => item.isExpense)
        .map((item) => DateTime(item.date.year, item.date.month, item.date.day))
        .toSet();
    final now = DateTime.now();
    return List.generate(now.day, (index) => index + 1)
        .where((day) => !expenseDays.contains(DateTime(now.year, now.month, day)))
        .length;
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
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}
