import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:spendora/core/controller/currency_data_controller.dart';
import 'package:spendora/core/controller/finance_data_controller.dart';
import 'package:spendora/core/models/finance_transaction.dart';
import 'package:spendora/core/routes/app_navigator.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/core/theme/app_theme_colors.dart';
import 'package:spendora/core/utils/get_currency_symbol.dart';
import 'package:spendora/core/widgets/app_loading_state.dart';
import 'package:spendora/core/widgets/confirmation_dialog.dart';
import 'package:spendora/features/transactions/controller/transaction_form_page_controller.dart';

class TransactionFormPage extends ConsumerStatefulWidget {
  final FinanceTransaction? transaction;

  const TransactionFormPage({super.key, this.transaction});

  @override
  ConsumerState<TransactionFormPage> createState() =>
      _TransactionFormPageState();
}

class _TransactionFormPageState extends ConsumerState<TransactionFormPage> {
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;
  late final TextEditingController _convertedAmountController;
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
    _convertedAmountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _convertedAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyDataController = ref.watch(
      currencyDataControllerProvider.notifier,
    );
    //Listen to error messages regarding exchange rates loading
    ref.listen(currencyDataControllerProvider.select((s) => s.alertMessage), (
      _,
      next,
    ) {
      if (next == null) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(next.message)));
      currencyDataController.clearAlertMessage();
    });

    final state = ref.watch(transactionFormPageControllerProvider);
    final controller = ref.watch(
      transactionFormPageControllerProvider.notifier,
    );
    final currentCurrency = ref.watch(
      currencyDataControllerProvider.select((s) => s.currency),
    );
    final isExchangeRatesNotLoaded = ref.watch(
      currencyDataControllerProvider.select((s) => s.exchangeRates == null),
    );
    final exchangeRatesLoading = ref.watch(
      currencyDataControllerProvider.select((s) => s.ratesLoading),
    );
    final selectedCurrency = state.selectedCurrency;
    final conversionOn = currentCurrency != selectedCurrency;
    final dataIsEmpty = ref
        .read(financeDataControllerProvider)
        .transactions
        .isEmpty;

    final colors = context.appColors;

    //Seeding transaction data in the edit case
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
        title: Text(
          widget.transaction == null ? 'Add transaction' : 'Edit transaction',
        ),
      ),
      body: exchangeRatesLoading
          ? const AppLoadingState(title: 'Loading exchange rate...')
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
              children: [
                Text(
                  'Track the moment clearly so your patterns stay useful later.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: colors.textMuted),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (value) {
                    controller.setAmountError(null);
                    if (conversionOn && value.isNotEmpty) {
                      _convertedAmountController.text = currencyDataController
                          .convertAmount(
                            amount: double.parse(_amountController.text.trim()),
                            sourceCurrency: selectedCurrency,
                          )
                          .toString();
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixText: '${getCurrencySymbol(selectedCurrency)} ',
                    errorText: state.amountError,
                    suffixIcon: TextButton(
                      onPressed: () =>
                          _showCurrencyPicker(context, (currency) async {
                            if (currentCurrency != currency.code &&
                                isExchangeRatesNotLoaded) {
                              final success = await currencyDataController
                                  .loadExchangeRates();
                              if (success) {
                                controller.selectCurrency(currency.code);
                              }
                            }
                          }),
                      child: Text(selectedCurrency),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (conversionOn)
                  TextField(
                    controller: _convertedAmountController,
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixText: '${getCurrencySymbol(currentCurrency)} ',
                      labelText: 'Amount in $currentCurrency',
                    ),
                  ),
                if (dataIsEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Current currency format is $currentCurrency, if you want to change ',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _showCurrencyPicker(context, (
                          currency,
                        ) {
                          currencyDataController.changeCurrency(currency.code);
                        }),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text('click here.'),
                      ),
                      Text(
                        'This selection can be done only when there is no data stored to ensure consistency in all the data.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  'Type',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: state.selectedType.categories.map((category) {
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
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365 * 3),
                      ),
                      lastDate: DateTime.now(),
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
                    child: Text(
                      DateFormat('dd MMM yyyy').format(state.selectedDate),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    hintText:
                        'Coffee with team, freelance payout, grocery top-up...',
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: state.isSubmitting
                      ? null
                      : () async {
                          final didSave = await controller.saveTransaction(
                            existingTransaction: widget.transaction,
                            amount: conversionOn
                                ? _convertedAmountController.text.trim()
                                : _amountController.text.trim(),
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
                            final confirmed = await showConfirmationDialog(
                              context,
                              title: 'Delete transaction?',
                              message:
                                  'This transaction will be removed permanently and cannot be recovered.',
                              confirmLabel: 'Delete',
                              cancelLabel: 'Keep',
                              isDestructive: true,
                              icon: Icons.delete_outline_rounded,
                            );
                            if (!confirmed) {
                              return;
                            }
                            await controller.deleteTransaction(
                              widget.transaction!,
                            );
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

  void _showCurrencyPicker(
    BuildContext context,
    void Function(Currency) onSelected,
  ) {
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      onSelect: (currency) {
        debugPrint(currency.toString());
        onSelected(currency);
      },
    );
  }
}
