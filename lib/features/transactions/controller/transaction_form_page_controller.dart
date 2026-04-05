import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spendora/core/controller/currency_data_controller.dart';
import 'package:spendora/core/controller/finance_data_controller.dart';
import 'package:spendora/core/models/alert_message.dart';
import 'package:spendora/core/models/finance_transaction.dart';

final transactionFormPageControllerProvider = NotifierProvider.autoDispose<
    TransactionFormPageController, TransactionFormPageState>(
  TransactionFormPageController.new,
);

class TransactionFormPageController extends Notifier<TransactionFormPageState> {
  @override
  TransactionFormPageState build() {
    return TransactionFormPageState.initial(ref);
  }

  void setType(TransactionType type) {
    final nextCategory = state.selectedCategory.supportsType(type)
        ? state.selectedCategory
        : type.defaultCategory;
    state = state.copyWith(
      selectedType: type,
      selectedCategory: nextCategory,
    );
  }

  void setCategory(TransactionCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setAmountError(String? error) {
    state = state.copyWith(amountError: error);
  }

  void selectCurrency(String currency){
    state = state.copyWith(selectedCurrency: currency);
  }

  Future<bool> saveTransaction({
    required FinanceTransaction? existingTransaction,
    required String amount,
    required String notes,
  }) async {
    print(amount);
    final parsedAmount = double.tryParse(amount.trim());
    if (parsedAmount == null || parsedAmount <= 0) {
      state = state.copyWith(amountError: 'Enter a valid amount');
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      amountError: null,
      alertMessage: null,
    );

    final transaction = FinanceTransaction(
      id: existingTransaction?.id ??
          'txn-${DateTime.now().microsecondsSinceEpoch}',
      amount: parsedAmount,
      type: state.selectedType,
      category: state.selectedCategory,
      date: state.selectedDate,
      notes: notes.trim(),
    );

    if (existingTransaction == null) {
      await ref
          .read(financeDataControllerProvider.notifier)
          .addTransaction(transaction);
    } else {
      await ref
          .read(financeDataControllerProvider.notifier)
          .updateTransaction(transaction);
    }

    state = state.copyWith(isSubmitting: false);
    return true;
  }

  Future<void> deleteTransaction(FinanceTransaction transaction) async {
    state = state.copyWith(isSubmitting: true);
    await ref
        .read(financeDataControllerProvider.notifier)
        .deleteTransaction(transaction.id);
    state = state.copyWith(
      isSubmitting: false,
      alertMessage: const AlertMessage(
        header: 'Deleted',
        message: 'The transaction was removed.',
      ),
    );
  }
}

class TransactionFormPageState {
  final TransactionType selectedType;
  final TransactionCategory selectedCategory;
  final String selectedCurrency;
  final DateTime selectedDate;
  final bool isSubmitting;
  final String? amountError;
  final AlertMessage? alertMessage;

  const TransactionFormPageState({
    required this.selectedType,
    required this.selectedCategory,
    required this.selectedCurrency,
    required this.selectedDate,
    required this.isSubmitting,
    this.amountError,
    this.alertMessage,
  });

  factory TransactionFormPageState.initial(Ref ref) {
    return TransactionFormPageState(
      selectedType: TransactionType.expense,
      selectedCategory: TransactionType.expense.defaultCategory,
      selectedCurrency: ref.watch(currencyDataControllerProvider).currency,
      selectedDate: DateTime.now(),
      isSubmitting: false,
    );
  }

  TransactionFormPageState copyWith({
    TransactionType? selectedType,
    TransactionCategory? selectedCategory,
    String? selectedCurrency,
    DateTime? selectedDate,
    bool? isSubmitting,
    String? amountError,
    AlertMessage? alertMessage,
  }) {
    return TransactionFormPageState(
      selectedType: selectedType ?? this.selectedType,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      selectedDate: selectedDate ?? this.selectedDate,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      amountError: amountError ?? this.amountError,
      alertMessage: alertMessage ?? this.alertMessage,
    );
  }
}
