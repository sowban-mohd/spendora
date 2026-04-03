import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/controller/finance_data_controller.dart';
import 'package:spendora/core/models/finance_transaction.dart';

final transactionsPageControllerProvider = NotifierProvider.autoDispose<
    TransactionsPageController, TransactionsPageState>(
  TransactionsPageController.new,
);

final filteredTransactionsProvider = Provider.autoDispose<List<FinanceTransaction>>(
  (ref) {
    final dataState = ref.watch(financeDataControllerProvider);
    final pageState = ref.watch(transactionsPageControllerProvider);
    final query = pageState.searchQuery.trim().toLowerCase();

    return dataState.transactions.where((transaction) {
      final matchesType = pageState.filter == TransactionFilter.all ||
          (pageState.filter == TransactionFilter.income &&
              transaction.type == TransactionType.income) ||
          (pageState.filter == TransactionFilter.expense &&
              transaction.type == TransactionType.expense);
      final matchesQuery = query.isEmpty ||
          transaction.notes.toLowerCase().contains(query) ||
          transaction.category.label.toLowerCase().contains(query);
      return matchesType && matchesQuery;
    }).toList();
  },
);

class TransactionsPageController extends Notifier<TransactionsPageState> {
  @override
  TransactionsPageState build() {
    return const TransactionsPageState(
      searchQuery: '',
      filter: TransactionFilter.all,
    );
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setFilter(TransactionFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

enum TransactionFilter { all, income, expense }

class TransactionsPageState {
  final String searchQuery;
  final TransactionFilter filter;

  const TransactionsPageState({
    required this.searchQuery,
    required this.filter,
  });

  TransactionsPageState copyWith({
    String? searchQuery,
    TransactionFilter? filter,
  }) {
    return TransactionsPageState(
      searchQuery: searchQuery ?? this.searchQuery,
      filter: filter ?? this.filter,
    );
  }
}
