import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendora/core/models/finance_transaction.dart';
import 'package:spendora/core/routes/routes.dart';

class AppNavigator {
  static void goToTransactionForm(
    BuildContext context, {
    FinanceTransaction? transaction,
  }) {
    context.push(Routes.transactionForm.path, extra: transaction);
  }

  static void pop(BuildContext context) {
    context.pop();
  }
}
