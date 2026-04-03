import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/controller/finance_data_controller.dart';
import 'package:spendora/core/routes/app_navigator.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/core/widgets/app_error_state.dart';
import 'package:spendora/core/widgets/app_loading_state.dart';
import 'package:spendora/core/widgets/empty_state_card.dart';
import 'package:spendora/features/transactions/controller/transactions_page_controller.dart';
import 'package:spendora/features/transactions/presentation/components/transaction_tile.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financeState = ref.watch(financeDataControllerProvider);
    final pageState = ref.watch(transactionsPageControllerProvider);
    final filteredTransactions = ref.watch(filteredTransactionsProvider);

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

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AppNavigator.goToTransactionForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
          children: [
            Text(
              'Transactions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Search, filter, edit, and clean up your daily money log.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),
            const SizedBox(height: 18),
            TextField(
              onChanged: ref
                  .read(transactionsPageControllerProvider.notifier)
                  .setSearchQuery,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                hintText: 'Search notes or category',
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: TransactionFilter.values.map((filter) {
                final selected = pageState.filter == filter;
                return ChoiceChip(
                  selected: selected,
                  label: Text(
                    switch (filter) {
                      TransactionFilter.all => 'All',
                      TransactionFilter.income => 'Income',
                      TransactionFilter.expense => 'Expense',
                    },
                  ),
                  onSelected: (_) {
                    ref
                        .read(transactionsPageControllerProvider.notifier)
                        .setFilter(filter);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            if (filteredTransactions.isEmpty)
              EmptyStateCard(
                title: pageState.searchQuery.isEmpty
                    ? 'No transactions yet'
                    : 'No matches found',
                message: pageState.searchQuery.isEmpty
                    ? 'Add your first income or expense to begin tracking your habits.'
                    : 'Try a different search or switch your filter.',
                buttonLabel: 'Add transaction',
                onPressed: () => AppNavigator.goToTransactionForm(context),
              )
            else
              Column(
                children: filteredTransactions.map((transaction) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Dismissible(
                      key: ValueKey(transaction.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: AppColors.expense,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (_) {
                        ref
                            .watch(financeDataControllerProvider.notifier)
                            .deleteTransaction(transaction.id);
                      },
                      child: TransactionTile(
                        transaction: transaction,
                        onTap: () => AppNavigator.goToTransactionForm(
                          context,
                          transaction: transaction,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
