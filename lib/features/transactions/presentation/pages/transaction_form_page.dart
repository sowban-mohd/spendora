import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:spendora/core/models/finance_transaction.dart';
import 'package:spendora/core/routes/app_navigator.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/features/transactions/controller/transaction_form_page_controller.dart';

class TransactionFormPage extends ConsumerStatefulWidget {
  final FinanceTransaction? transaction;

  const TransactionFormPage({super.key, this.transaction});

  @override
  ConsumerState<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends ConsumerState<TransactionFormPage> {
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;
  bool _seeded = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.transaction?.amount.toStringAsFixed(0) ?? '',
    );
    _notesController = TextEditingController(
      text: widget.transaction?.notes ?? '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(transactionFormPageControllerProvider.notifier);
    final state = ref.watch(transactionFormPageControllerProvider);

    if (!_seeded && widget.transaction != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.setType(widget.transaction!.type);
        controller.setCategory(widget.transaction!.category);
        controller.setDate(widget.transaction!.date);
      });
      _seeded = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction == null ? 'Add transaction' : 'Edit transaction'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
        children: [
          Text(
            'Track the moment clearly so your patterns stay useful later.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => controller.setAmountError(null),
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixText: 'Rs ',
              errorText: state.amountError,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Type',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: TransactionType.values.map((type) {
              return ChoiceChip(
                label: Text(type.label),
                selected: state.selectedType == type,
                onSelected: (_) => controller.setType(type),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text(
            'Category',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: TransactionCategory.values.map((category) {
              return ChoiceChip(
                label: Text(category.label),
                selected: state.selectedCategory == category,
                onSelected: (_) => controller.setCategory(category),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: state.selectedDate,
                firstDate: DateTime.now().subtract(const Duration(days: 365 * 3)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (pickedDate != null) {
                controller.setDate(pickedDate);
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Date',
                suffixIcon: Icon(Icons.calendar_month_rounded),
              ),
              child: Text(DateFormat('dd MMM yyyy').format(state.selectedDate)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes',
              hintText: 'Coffee with team, freelance payout, grocery top-up...',
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: state.isSubmitting
                ? null
                : () async {
                    final didSave = await controller.saveTransaction(
                      existingTransaction: widget.transaction,
                      amount: _amountController.text,
                      notes: _notesController.text,
                    );
                    if (didSave && context.mounted) {
                      AppNavigator.pop(context);
                    }
                  },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                state.isSubmitting
                    ? 'Saving...'
                    : widget.transaction == null
                        ? 'Save transaction'
                        : 'Update transaction',
              ),
            ),
          ),
          if (widget.transaction != null) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: state.isSubmitting
                  ? null
                  : () async {
                      await controller.deleteTransaction(widget.transaction!);
                      if (context.mounted) {
                        AppNavigator.pop(context);
                      }
                    },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.expense,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Delete transaction'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
