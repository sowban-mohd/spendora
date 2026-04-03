import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:spendora/core/controller/finance_data_controller.dart';
import 'package:spendora/core/models/finance_transaction.dart';
import 'package:spendora/core/routes/app_navigator.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/core/utils/currency_formatter.dart';
import 'package:spendora/core/widgets/empty_state_card.dart';
import 'package:spendora/core/widgets/metric_card.dart';
import 'package:spendora/features/dashboard/controller/home_dashboard_controller.dart';
import 'package:spendora/features/dashboard/models/home_dashboard_state.dart';
import 'package:spendora/features/transactions/presentation/components/transaction_tile.dart';

class HomeDashboardPage extends ConsumerWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financeState = ref.watch(financeDataControllerProvider);

    final dashboardState = ref.watch(homeDashboardControllerProvider);
    final transactions = financeState.transactions;
    final now = DateTime.now();
    final currentMonthTransactions = transactions
        .where((item) => item.date.year == now.year && item.date.month == now.month)
        .toList();
    final income = _sumAmount(currentMonthTransactions, TransactionType.income);
    final expenses = _sumAmount(currentMonthTransactions, TransactionType.expense);
    final balance = income - expenses;
    final savingsProgress = financeState.goal.savingsTarget == 0
        ? 0.0
        : (balance / financeState.goal.savingsTarget).clamp(0, 1).toDouble();
    final trendData = _buildTrendData(transactions, dashboardState.selectedWindow);
    final topCategories = _buildCategorySpending(currentMonthTransactions).entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final recentTransactions = transactions.take(4).toList();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => ref.watch(financeDataControllerProvider.notifier).reloadData(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accent, Color(0xFF3A6B57)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily money companion',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatCurrency(balance),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  // Text(
                  //   balance >= 0
                  //       ? 'You are saving more than you spend this month.'
                  //       : 'Spending is ahead of income this month.',
                  //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  //         color: Colors.white70,
                  //       ),
                  // ),
                  // const SizedBox(height: 18),
                  LinearProgressIndicator(
                    value: savingsProgress,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(999),
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(AppColors.warm),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Savings goal progress ${NumberFormat.percentPattern().format(savingsProgress)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.18,
              children: [
                MetricCard(
                  label: 'Current balance',
                  value: formatCurrency(balance),
                  caption: 'Month to date',
                  accentColor: AppColors.accent,
                ),
                MetricCard(
                  label: 'Total income',
                  value: formatCurrency(income),
                  caption: 'Incoming cash',
                  accentColor: AppColors.income,
                ),
                MetricCard(
                  label: 'Total expenses',
                  value: formatCurrency(expenses),
                  caption: 'Outgoing cash',
                  accentColor: AppColors.expense,
                ),
                MetricCard(
                  label: 'No-spend days',
                  value: '${_countNoSpendDays(currentMonthTransactions)} days',
                  caption: 'Challenge in motion',
                  accentColor: AppColors.chartBlue,
                ),
              ],
            ),
            const SizedBox(height: 18),
            _SectionCard(
              title: 'Spending trend',
              trailing: SegmentedButton<DashboardWindow>(
                segments: const [
                  ButtonSegment(value: DashboardWindow.week, label: Text('Week')),
                  ButtonSegment(value: DashboardWindow.month, label: Text('Month')),
                ],
                selected: {dashboardState.selectedWindow},
                onSelectionChanged: (value) {
                  ref.watch(homeDashboardControllerProvider.notifier).setWindow(value.first);
                },
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: trendData.map((item) {
                  final maxValue = trendData.fold<double>(
                    1,
                    (previousValue, element) => max(previousValue, element.amount),
                  );
                  final heightFactor = (item.amount / maxValue).clamp(0.12, 1.0);
                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 120 * heightFactor,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: AppColors.chartBlue.withValues(alpha: 0.78),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.label,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textMuted,
                              ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 18),
            _SectionCard(
              title: 'Top categories',
              trailing: Text(
                'This month',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
              ),
              child: topCategories.isEmpty
                  ? const Text('No expense data yet.')
                  : Column(
                      children: topCategories.take(4).map((entry) {
                        final totalTop = topCategories.fold<double>(
                          0,
                          (sum, item) => sum + item.value,
                        );
                        final progress = totalTop == 0 ? 0.0 : entry.value / totalTop;
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
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 18),
            if (recentTransactions.isEmpty)
              EmptyStateCard(
                title: 'No transactions yet',
                message:
                    'Start with your first entry and Spendora will turn it into habits and insights.',
                buttonLabel: 'Add transaction',
                onPressed: () => AppNavigator.goToTransactionForm(context),
              )
            else
              _SectionCard(
                title: 'Recent activity',
                trailing: Text(
                  'Latest 4',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
                child: Column(
                  children: recentTransactions
                      .map(
                        (transaction) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TransactionTile(
                            transaction: transaction,
                            onTap: () => AppNavigator.goToTransactionForm(
                              context,
                              transaction: transaction,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _sumAmount(List<FinanceTransaction> transactions, TransactionType type) {
    return transactions
        .where((item) => item.type == type)
        .fold(0, (sum, item) => sum + item.amount);
  }

  Map<TransactionCategory, double> _buildCategorySpending(
    List<FinanceTransaction> transactions,
  ) {
    final result = <TransactionCategory, double>{};
    for (final transaction in transactions.where((item) => item.isExpense)) {
      result.update(
        transaction.category,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }
    return result;
  }

  List<_TrendBarData> _buildTrendData(
    List<FinanceTransaction> transactions,
    DashboardWindow window,
  ) {
    final now = DateTime.now();
    if (window == DashboardWindow.week) {
      return List.generate(7, (index) {
        final day = now.subtract(Duration(days: 6 - index));
        final amount = transactions
            .where(
              (item) =>
                  item.isExpense &&
                  item.date.year == day.year &&
                  item.date.month == day.month &&
                  item.date.day == day.day,
            )
            .fold<double>(0, (sum, item) => sum + item.amount);
        return _TrendBarData(label: DateFormat('E').format(day), amount: amount);
      });
    }

    return List.generate(4, (index) {
      final startDay = now.subtract(Duration(days: (3 - index) * 7));
      final endDay = startDay.add(const Duration(days: 6));
      final amount = transactions
          .where(
            (item) =>
                item.isExpense &&
                item.date.isAfter(startDay.subtract(const Duration(days: 1))) &&
                item.date.isBefore(endDay.add(const Duration(days: 1))),
          )
          .fold<double>(0, (sum, item) => sum + item.amount);
      return _TrendBarData(label: 'W${index + 1}', amount: amount);
    });
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

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget trailing;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.trailing,
    required this.child,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
              const SizedBox(width: 12),
               trailing,
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _TrendBarData {
  final String label;
  final double amount;

  const _TrendBarData({
    required this.label,
    required this.amount,
  });
}
