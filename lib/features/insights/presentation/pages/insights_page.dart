import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/controller/finance_data_controller.dart';
import 'package:spendora/core/models/finance_transaction.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/core/utils/currency_formatter.dart';
import 'package:spendora/core/widgets/app_error_state.dart';
import 'package:spendora/core/widgets/app_loading_state.dart';
import 'package:spendora/features/insights/controller/insights_page_controller.dart';

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financeState = ref.watch(financeDataControllerProvider);
    final pageState = ref.watch(insightsPageControllerProvider);

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

    final transactions = financeState.transactions;
    final now = DateTime.now();
    final scopedTransactions = transactions.where((item) {
      if (pageState.selectedMode == InsightMode.weekly) {
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        return item.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            item.date.isBefore(weekEnd.add(const Duration(days: 1)));
      }
      return item.date.year == now.year && item.date.month == now.month;
    }).toList();
    final thisWeekStart = now.subtract(Duration(days: now.weekday - 1));
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
    final thisWeekExpenses = _expenseBetween(
      transactions,
      thisWeekStart,
      thisWeekStart.add(const Duration(days: 6)),
    );
    final lastWeekExpenses = _expenseBetween(
      transactions,
      lastWeekStart,
      lastWeekStart.add(const Duration(days: 6)),
    );
    final categoryTotals = <TransactionCategory, double>{};
    for (final transaction in scopedTransactions.where((item) => item.isExpense)) {
      categoryTotals.update(
        transaction.category,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topCategory = sortedCategories.isEmpty ? null : sortedCategories.first;
    final frequentType = _buildFrequentType(scopedTransactions);
    final trendData = pageState.selectedMode == InsightMode.weekly
        ? List.generate(4, (index) {
            final weekStart = thisWeekStart.subtract(Duration(days: (3 - index) * 7));
            final weekEnd = weekStart.add(const Duration(days: 6));
            final amount = _expenseBetween(transactions, weekStart, weekEnd);
            return _TrendPoint(label: 'W${index + 1}', amount: amount);
          })
        : List.generate(4, (index) {
            final monthDate = DateTime(now.year, now.month - (3 - index), 1);
            final amount = transactions
                .where(
                  (item) =>
                      item.isExpense &&
                      item.date.year == monthDate.year &&
                      item.date.month == monthDate.month,
                )
                .fold<double>(0, (sum, item) => sum + item.amount);
            return _TrendPoint(
              label: '${monthDate.month}/${monthDate.year.toString().substring(2)}',
              amount: amount,
            );
          });

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
        children: [
          Text(
            'Insights',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Small-screen clarity for the spending patterns behind your day-to-day choices.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          const SizedBox(height: 18),
          SegmentedButton<InsightMode>(
            segments: const [
              ButtonSegment(value: InsightMode.weekly, label: Text('Weekly')),
              ButtonSegment(value: InsightMode.monthly, label: Text('Monthly')),
            ],
            selected: {pageState.selectedMode},
            onSelectionChanged: (value) {
              ref.watch(insightsPageControllerProvider.notifier).setMode(value.first);
            },
          ),
          const SizedBox(height: 18),
          _InsightCard(
            title: 'Biggest spending category',
            value: topCategory == null
                ? 'No data yet'
                : '${topCategory.key.label} | ${formatCurrency(topCategory.value)}',
            description: 'Your heaviest spend cluster at the moment.',
          ),
          const SizedBox(height: 12),
          _InsightCard(
            title: 'This week vs last week',
            value:
                '${thisWeekExpenses >= lastWeekExpenses ? '+' : '-'}${formatCurrency((thisWeekExpenses - lastWeekExpenses).abs())}',
            description:
                'Weekly change in total expenses. This week: ${formatCurrency(thisWeekExpenses)}',
          ),
          const SizedBox(height: 12),
          _InsightCard(
            title: 'Most frequent transaction type',
            value: frequentType,
            description: 'What shows up most often in your money log.',
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
                  pageState.selectedMode == InsightMode.weekly
                      ? 'Weekly trend'
                      : 'Monthly trend',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 18),
                ...trendData.map((item) {
                  final maxAmount = trendData.fold<double>(
                    1,
                    (sum, element) => element.amount > sum ? element.amount : sum,
                  );
                  final widthFactor = (item.amount / maxAmount).clamp(0.08, 1.0);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 56,
                          child: Text(
                            item.label,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textMuted,
                                ),
                          ),
                        ),
                        Expanded(
                          child: FractionallySizedBox(
                            widthFactor: widthFactor,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColors.chartBlue,
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(formatCurrency(item.amount)),
                      ],
                    ),
                  );
                }),
              ],
            ),
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
                  'Spending by category',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 18),
                ...sortedCategories.take(5).map((entry) {
                  final total = sortedCategories.fold<double>(
                    0,
                    (sum, item) => sum + item.value,
                  );
                  final progress = total == 0 ? 0.0 : entry.value / total;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key.label),
                            Text(formatCurrency(entry.value)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(999),
                          backgroundColor: AppColors.accentSoft,
                          valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _expenseBetween(
    List<FinanceTransaction> transactions,
    DateTime start,
    DateTime end,
  ) {
    return transactions
        .where(
          (item) =>
              item.isExpense &&
              item.date.isAfter(start.subtract(const Duration(days: 1))) &&
              item.date.isBefore(end.add(const Duration(days: 1))),
        )
        .fold<double>(0, (sum, item) => sum + item.amount);
  }

  String _buildFrequentType(List<FinanceTransaction> transactions) {
    final incomeCount = transactions.where((item) => !item.isExpense).length;
    final expenseCount = transactions.where((item) => item.isExpense).length;
    if (incomeCount == expenseCount) {
      return 'Balanced mix';
    }
    return incomeCount > expenseCount ? 'Income entries' : 'Expense entries';
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final String value;
  final String description;

  const _InsightCard({
    required this.title,
    required this.value,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}

class _TrendPoint {
  final String label;
  final double amount;

  const _TrendPoint({
    required this.label,
    required this.amount,
  });
}
