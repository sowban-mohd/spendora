import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/models/alert_message.dart';
import 'package:spendora/core/models/finance_transaction.dart';
import 'package:spendora/core/models/monthly_goal.dart';
import 'package:spendora/core/services/local_finance_service.dart';

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
}

class FinanceDataState {
  final bool isLoading;
  final List<FinanceTransaction> transactions;
  final MonthlyGoal goal;
  final AlertMessage? errorMessage;
  final AlertMessage? alertMessage;

  const FinanceDataState({
    required this.isLoading,
    required this.transactions,
    required this.goal,
    this.errorMessage,
    this.alertMessage,
  });

  factory FinanceDataState.initial() {
    return FinanceDataState(
      isLoading: true,
      transactions: const [],
      goal: MonthlyGoal.initial(),
    );
  }

  FinanceDataState copyWith({
    bool? isLoading,
    List<FinanceTransaction>? transactions,
    MonthlyGoal? goal,
    AlertMessage? errorMessage,
    AlertMessage? alertMessage,
    bool clearAlertMessage = false,
    bool clearErrorMessage = false,
  }) {
    return FinanceDataState(
      isLoading: isLoading ?? this.isLoading,
      transactions: transactions ?? this.transactions,
      goal: goal ?? this.goal,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      alertMessage: clearAlertMessage
          ? null
          : alertMessage ?? this.alertMessage,
    );
  }
}
