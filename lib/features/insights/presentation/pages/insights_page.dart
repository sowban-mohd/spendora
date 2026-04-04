import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/controller/finance_data_controller.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/core/theme/app_theme_colors.dart';
import 'package:spendora/core/utils/currency_formatter.dart';
import 'package:spendora/features/insights/controller/insights_page_controller.dart';

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(financeDataControllerProvider);
    final financeDataController = ref.watch(
      financeDataControllerProvider.notifier,
    );
    final pageState = ref.watch(insightsPageControllerProvider);
    final colors = context.appColors;
    final insightData = financeDataController.buildInsightsData(
      isWeekly: pageState.selectedMode == InsightMode.weekly,
    );
    final trendData = insightData.trendData;
    final categoryBreakdown = insightData.categoryBreakdown;
    final maxTrendAmount = trendData.fold<double>(
      1,
      (sum, element) => element.amount > sum ? element.amount : sum,
    );
    final totalCategorySpend = categoryBreakdown.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
        children: [
          Text(
            'Insights',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Small-screen clarity for the spending patterns behind your day-to-day choices.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.textMuted),
          ),
          const SizedBox(height: 18),
          SegmentedButton<InsightMode>(
            segments: const [
              ButtonSegment(value: InsightMode.weekly, label: Text('Weekly')),
              ButtonSegment(value: InsightMode.monthly, label: Text('Monthly')),
            ],
            selected: {pageState.selectedMode},
            onSelectionChanged: (value) {
              ref
                  .watch(insightsPageControllerProvider.notifier)
                  .setMode(value.first);
            },
          ),
          const SizedBox(height: 18),
          _InsightCard(
            title: 'Biggest spending category',
            value: insightData.topCategory == null
                ? 'No data yet'
                : '${insightData.topCategory!.category.label} | ${formatCurrency(insightData.topCategory!.amount)}',
            description: 'Your heaviest spend cluster at the moment.',
          ),
          if (pageState.selectedMode == InsightMode.weekly) ...[
            const SizedBox(height: 12),
            _InsightCard(
              title: 'This week vs last week',
              value:
                  '${insightData.currentPeriodExpense >= insightData.previousPeriodExpense ? '+' : '-'}${formatCurrency((insightData.currentPeriodExpense - insightData.previousPeriodExpense).abs())}',
              description:
                  'Last 7 days: ${formatCurrency(insightData.currentPeriodExpense)} | Previous 7 days: ${formatCurrency(insightData.previousPeriodExpense)}',
            ),
          ],
          const SizedBox(height: 12),
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
                  pageState.selectedMode == InsightMode.weekly
                      ? 'Weekly trend'
                      : 'Monthly trend',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                ...trendData.map((item) {
                  final widthFactor = (item.amount / maxTrendAmount).clamp(
                    0.08,
                    1.0,
                  );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 56,
                          child: Text(
                            item.label,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colors.textMuted),
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
              color: colors.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: colors.outline),
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
                ...categoryBreakdown.take(5).map((entry) {
                  final progress = totalCategorySpend == 0
                      ? 0.0
                      : entry.amount / totalCategorySpend;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.category.label),
                            Text(formatCurrency(entry.amount)),
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
                }),
              ],
            ),
          ),
        ],
      ),
    );
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
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(18),
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
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.textMuted),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}
