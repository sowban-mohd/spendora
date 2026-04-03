import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendora/core/models/finance_transaction.dart';
import 'package:spendora/core/routes/routes.dart';
import 'package:spendora/features/shell/presentation/main_shell_page.dart';
import 'package:spendora/features/transactions/presentation/pages/transaction_form_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.home.path,
    routes: [
      GoRoute(
        path: Routes.home.path,
        builder: (context, state) => const MainShellPage(),
      ),
      GoRoute(
        path: Routes.transactionForm.path,
        builder: (context, state) {
          final transaction = state.extra as FinanceTransaction?;
          return TransactionFormPage(transaction: transaction);
        },
      ),
    ],
  );
});
