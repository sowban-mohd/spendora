import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return TransactionFormPageState.initial();
  }

  void setType(TransactionType type) {
    state = state.copyWith(selectedType: type);
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

  Future<bool> saveTransaction({
    required FinanceTransaction? existingTransaction,
    required String amount,
    required String notes,
  }) async {
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
  final DateTime selectedDate;
  final bool isSubmitting;
  final String? amountError;
  final AlertMessage? alertMessage;

  const TransactionFormPageState({
    required this.selectedType,
    required this.selectedCategory,
    required this.selectedDate,
    required this.isSubmitting,
    this.amountError,
    this.alertMessage,
  });

  factory TransactionFormPageState.initial() {
    return TransactionFormPageState(
      selectedType: TransactionType.expense,
      selectedCategory: TransactionCategory.food,
      selectedDate: DateTime.now(),
      isSubmitting: false,
    );
  }

  TransactionFormPageState copyWith({
    TransactionType? selectedType,
    TransactionCategory? selectedCategory,
    DateTime? selectedDate,
    bool? isSubmitting,
    String? amountError,
    AlertMessage? alertMessage,
  }) {
    return TransactionFormPageState(
      selectedType: selectedType ?? this.selectedType,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedDate: selectedDate ?? this.selectedDate,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      amountError: amountError,
      alertMessage: alertMessage,
    );
  }
}
