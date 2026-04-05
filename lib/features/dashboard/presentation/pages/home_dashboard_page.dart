import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:spendora/core/controller/currency_data_controller.dart';
import 'package:spendora/core/controller/finance_data_controller.dart';
import 'package:spendora/core/routes/app_navigator.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/core/theme/app_theme_colors.dart';
import 'package:spendora/core/widgets/empty_state_card.dart';
import 'package:spendora/core/widgets/metric_card.dart';
import 'package:spendora/features/dashboard/controller/home_dashboard_controller.dart';
import 'package:spendora/features/dashboard/models/home_dashboard_state.dart';
import 'package:spendora/features/transactions/presentation/components/transaction_tile.dart';

class HomeDashboardPage extends ConsumerWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(financeDataControllerProvider);
    final financeDataController = ref.watch(
      financeDataControllerProvider.notifier,
    );
    final dashboardState = ref.watch(homeDashboardControllerProvider);
    final colors = context.appColors;
    final income = financeDataController.income;
    final expenses = financeDataController.expense;
    final balance = financeDataController.balance;
    final savingsProgress = financeDataController.savingsProgress;
    final trendData = dashboardState.selectedWindow == DashboardWindow.week
        ? financeDataController.buildWeeklyExpenseTrendData()
        : financeDataController.buildMonthlyExpenseTrendData();
    final topCategories = financeDataController.topSpendingCategories;
    final recentTransactions = financeDataController.recentTransactions;
    final maxTrendAmount = trendData.fold<double>(
      0,
      (previousValue, element) =>
          previousValue > element.amount ? previousValue : element.amount,
    );
    final totalTopCategorySpend = topCategories.fold<double>(
      0,
      (sum, item) => sum + item.value,
    );
    final formatCurrency = ref.watch(currencyDataControllerProvider.notifier).formatCurrency;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppNavigator.goToTransactionForm(context),
        child: const Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.watch(financeDataControllerProvider.notifier).reloadData(),
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
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatCurrency(balance),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      balance >= 0
                          ? 'You are saving more than you spend this month.'
                          : 'Spending is ahead of income this month.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 18),
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
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white70),
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
                    accentColor: AppColors.income,
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
                    value:
                        '${financeDataController.currentMonthNoSpendDays} days',
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
                    ButtonSegment(
                      value: DashboardWindow.week,
                      label: Text('Week'),
                    ),
                    ButtonSegment(
                      value: DashboardWindow.month,
                      label: Text('Month'),
                    ),
                  ],
                  selected: {dashboardState.selectedWindow},
                  onSelectionChanged: (value) {
                    ref
                        .watch(homeDashboardControllerProvider.notifier)
                        .setWindow(value.first);
                  },
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: trendData.map((item) {
                    final heightFactor = maxTrendAmount == 0
                        ? 0.0
                        : (item.amount / maxTrendAmount).clamp(0.0, 1.0);
                    return Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 120 * heightFactor,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: item.amount == 0
                                  ? colors.accentSoft
                                  : AppColors.chartBlue.withValues(alpha: 0.78),
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.label,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colors.textMuted),
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: colors.textMuted),
                ),
                child: topCategories.isEmpty
                    ? const Text('No expense data yet.')
                    : Column(
                        children: topCategories.take(4).map((entry) {
                          final progress = totalTopCategorySpend == 0
                              ? 0.0
                              : entry.value / totalTopCategorySpend;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  backgroundColor: colors.accentSoft,
                                  valueColor: const AlwaysStoppedAnimation(
                                    AppColors.accent,
                                  ),
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
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget child;

  const _SectionCard({required this.title, this.trailing, required this.child});

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 12), trailing!],
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}
