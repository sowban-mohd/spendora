import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:spendora/core/models/alert_message.dart';
import 'package:spendora/core/models/finance_data_state.dart';
import 'package:spendora/core/models/finance_transaction.dart';
import 'package:spendora/core/models/monthly_goal.dart';
import 'package:spendora/core/services/local_finance_service.dart';
import 'package:spendora/core/utils/is_same_date.dart';

final financeDataControllerProvider =
    NotifierProvider<FinanceDataController, FinanceDataState>(
      FinanceDataController.new,
    );

class FinanceDataController extends Notifier<FinanceDataState> {
  @override
  FinanceDataState build() {
    _loadData();
    return FinanceDataState.initial();
  }

  double get income => state.transactions
      .where((item) => item.type == TransactionType.income)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get expense => state.transactions
      .where((item) => item.type == TransactionType.expense)
      .fold(0.0, (sum, item) => sum + item.amount);

  List<FinanceTransaction> get currentMonthTransactions => state.transactions
      .where(
        (item) =>
            item.date.year == DateTime.now().year &&
            item.date.month == DateTime.now().month,
      )
      .toList();

  double get currentMonthIncome => currentMonthTransactions
      .where((item) => item.type == TransactionType.income)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get currentMonthExpense => currentMonthTransactions
      .where((item) => item.type == TransactionType.expense)
      .fold(0.0, (sum, item) => sum + item.amount);

  double get currentMonthSavings => currentMonthIncome - currentMonthExpense;

  int get currentMonthNoSpendDays =>
      _countNoSpendDays(currentMonthTransactions);

  List<FinanceTransaction> get recentTransactions =>
      state.transactions.take(4).toList();
  List<MapEntry<TransactionCategory, double>> get topSpendingCategories {
    final result = <TransactionCategory, double>{};

    for (final transaction in currentMonthTransactions.where(
      (item) => item.isExpense,
    )) {
      result.update(
        transaction.category,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    return result.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  }

  double get balance => income - expense;

  double get savingsProgress => state.goal!.savingsTarget == 0
      ? 0.0
      : (balance / state.goal!.savingsTarget).clamp(0, 1).toDouble();

  double get currentMonthSavingsProgress => state.goal!.savingsTarget == 0
      ? 0.0
      : (currentMonthSavings / state.goal!.savingsTarget).clamp(0, 1).toDouble();

  double get currentMonthExpenseLimitProgress =>
      state.goal!.monthlyExpenseLimit == 0
      ? 0.0
      : (currentMonthExpense / state.goal!.monthlyExpenseLimit)
            .clamp(0, 1)
            .toDouble();

  double get currentMonthNoSpendChallengeProgress =>
      state.goal!.noSpendTargetDays == 0
      ? 0.0
      : (currentMonthNoSpendDays / state.goal!.noSpendTargetDays)
            .clamp(0, 1)
            .toDouble();

  List<FinanceTrendBarData> buildWeeklyExpenseTrendData() {
    final now = DateTime.now();

    return List.generate(7, (index) {
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: 6 - index));
      final amount = state.transactions
          .where((item) => item.isExpense && isSameDate(item.date, day))
          .fold<double>(0, (sum, item) => sum + item.amount);

      return FinanceTrendBarData(
        label: DateFormat('E').format(day),
        amount: amount,
      );
    });
  }

  List<FinanceTrendBarData> buildMonthlyExpenseTrendData() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    final weekCount = ((monthEnd.day - 1) ~/ 7) + 1;

    return List.generate(weekCount, (index) {
      final startDay = DateTime(now.year, now.month, index * 7 + 1);
      final endDay = DateTime(
        now.year,
        now.month,
        min(startDay.day + 6, monthEnd.day),
      );
      final amount = state.transactions
          .where(
            (item) =>
                item.isExpense &&
                !item.date.isBefore(monthStart) &&
                !item.date.isAfter(monthEnd) &&
                !item.date.isBefore(startDay) &&
                !item.date.isAfter(endDay),
          )
          .fold<double>(0, (sum, item) => sum + item.amount);

      return FinanceTrendBarData(
        label: '${startDay.day}-${endDay.day}',
        amount: amount,
      );
    });
  }

  FinanceInsightsData buildInsightsData({required bool isWeekly}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final periodStart = isWeekly
        ? today.subtract(const Duration(days: 6))
        : DateTime(now.year, now.month, 1);
    final periodEnd = isWeekly ? today : DateTime(now.year, now.month + 1, 0);
    final scopedTransactions = state.transactions.where(
      (item) =>
          !_startOfDay(item.date).isBefore(periodStart) &&
          !_startOfDay(item.date).isAfter(periodEnd),
    );

    final categoryTotals = <TransactionCategory, double>{};
    for (final transaction in scopedTransactions.where(
      (item) => item.isExpense,
    )) {
      categoryTotals.update(
        transaction.category,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    final categoryBreakdown =
        categoryTotals.entries
            .map(
              (entry) => FinanceCategoryTotal(
                category: entry.key,
                amount: entry.value,
              ),
            )
            .toList()
          ..sort((a, b) => b.amount.compareTo(a.amount));

    final trendData = isWeekly
        ? List.generate(7, (index) {
            final day = periodStart.add(Duration(days: index));
            final amount = state.transactions
                .where((item) => item.isExpense && isSameDate(item.date, day))
                .fold<double>(0, (sum, item) => sum + item.amount);

            return FinanceTrendBarData(
              label: DateFormat('E').format(day),
              amount: amount,
            );
          })
        : List.generate(((periodEnd.day - 1) ~/ 7) + 1, (index) {
            final startDay = DateTime(now.year, now.month, index * 7 + 1);
            final endDay = DateTime(
              now.year,
              now.month,
              min(startDay.day + 6, periodEnd.day),
            );
            final amount = state.transactions
                .where(
                  (item) =>
                      item.isExpense &&
                      !_startOfDay(item.date).isBefore(startDay) &&
                      !_startOfDay(item.date).isAfter(endDay),
                )
                .fold<double>(0, (sum, item) => sum + item.amount);

            return FinanceTrendBarData(
              label: '${startDay.day}-${endDay.day}',
              amount: amount,
            );
          });

    final currentPeriodExpense = isWeekly
        ? _expenseBetween(state.transactions, periodStart, periodEnd)
        : categoryBreakdown.fold<double>(0, (sum, item) => sum + item.amount);
    final previousPeriodExpense = isWeekly
        ? _expenseBetween(
            state.transactions,
            periodStart.subtract(const Duration(days: 7)),
            periodStart.subtract(const Duration(days: 1)),
          )
        : 0.0;

    return FinanceInsightsData(
      topCategory: categoryBreakdown.isEmpty ? null : categoryBreakdown.first,
      currentPeriodExpense: currentPeriodExpense,
      previousPeriodExpense: previousPeriodExpense,
      trendData: trendData,
      categoryBreakdown: categoryBreakdown,
    );
  }

  Future<void> _loadData() async {
    try {
      final service = ref.read(localFinanceServiceProvider);
      final transactions = await service.loadTransactions();
      final goal = await service.loadGoal();
      state = state.copyWith(
        isLoading: false,
        transactions: transactions,
        goal: goal,
      );
    } catch (e) {
      debugPrint('Finance data loading error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: const AlertMessage(
          header: 'Unable to load data',
          message: 'Please try again in a moment.',
        ),
      );
    }
  }

  Future<void> reloadData() async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    await _loadData();
  }

  Future<void> addTransaction(FinanceTransaction transaction) async {
    try {
      final updatedList = [transaction, ...state.transactions]
        ..sort((a, b) => b.date.compareTo(a.date));
      state = state.copyWith(transactions: updatedList);
      await ref.read(localFinanceServiceProvider).addTransaction(transaction);
      state = state.copyWith(
        alertMessage: AlertMessage(
          header: "Success",
          message: "Added transaction successfully.",
        ),
      );
    } on AlertMessage catch (e) {
      state = state.copyWith(alertMessage: e);
      reloadData();
    }
  }

  Future<void> updateTransaction(FinanceTransaction transaction) async {
    try {
      final updatedList =
          state.transactions
              .map((item) => item.id == transaction.id ? transaction : item)
              .toList()
            ..sort((a, b) => b.date.compareTo(a.date));
      state = state.copyWith(transactions: updatedList);
      await ref
          .read(localFinanceServiceProvider)
          .updateTransaction(transaction);
      state = state.copyWith(
        alertMessage: AlertMessage(
          header: "Success",
          message: "Updated transaction successfully.",
        ),
      );
    } on AlertMessage catch (e) {
      state = state.copyWith(errorMessage: e);
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      final updatedList = state.transactions
          .where((item) => item.id != transactionId)
          .toList();
      state = state.copyWith(transactions: updatedList);
      await ref
          .read(localFinanceServiceProvider)
          .deleteTransaction(transactionId);
      state = state.copyWith(
        alertMessage: AlertMessage(
          header: "Success",
          message: "Deleted transaction successfully.",
        ),
      );
    } on AlertMessage catch (e) {
      state = state.copyWith(errorMessage: e);
    }
  }

  Future<void> updateGoal(MonthlyGoal goal) async {
    state = state.copyWith(clearErrorMessage: true);
    try {
      await ref.read(localFinanceServiceProvider).updateGoal(goal);
      state = state.copyWith(
        goal: goal,
        alertMessage: const AlertMessage(
          header: 'Goal updated',
          message: 'Your monthly targets were saved.',
        ),
      );
    } on AlertMessage catch (e) {
      state = state.copyWith(alertMessage: e);
    }
  }

  void clearAlertMessage() {
    state = state.copyWith(clearAlertMessage: true);
  }

  void clearErrorMessage() {
    state = state.copyWith(clearErrorMessage: true);
  }

  int _countNoSpendDays(List<FinanceTransaction> transactions) {
    final expenseDays = transactions
        .where((item) => item.isExpense)
        .map((item) => DateTime(item.date.year, item.date.month, item.date.day))
        .toSet();
    final now = DateTime.now();

    return List.generate(now.day, (index) => index + 1)
        .where(
          (day) => !expenseDays.contains(DateTime(now.year, now.month, day)),
        )
        .length;
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
              !_startOfDay(item.date).isBefore(start) &&
              !_startOfDay(item.date).isAfter(end),
        )
        .fold<double>(0, (sum, item) => sum + item.amount);
  }

  DateTime _startOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}

class FinanceTrendBarData {
  final String label;
  final double amount;

  const FinanceTrendBarData({required this.label, required this.amount});
}

class FinanceCategoryTotal {
  final TransactionCategory category;
  final double amount;

  const FinanceCategoryTotal({required this.category, required this.amount});
}

class FinanceInsightsData {
  final FinanceCategoryTotal? topCategory;
  final double currentPeriodExpense;
  final double previousPeriodExpense;
  final List<FinanceTrendBarData> trendData;
  final List<FinanceCategoryTotal> categoryBreakdown;

  const FinanceInsightsData({
    required this.topCategory,
    required this.currentPeriodExpense,
    required this.previousPeriodExpense,
    required this.trendData,
    required this.categoryBreakdown,
  });
}
