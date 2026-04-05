import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/controller/currency_data_controller.dart';
import 'package:spendora/core/controller/finance_data_controller.dart';
import 'package:spendora/core/routes/app_navigator.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/core/theme/app_theme_colors.dart';
import 'package:spendora/core/utils/get_currency_symbol.dart';
import 'package:spendora/core/widgets/app_error_state.dart';
import 'package:spendora/core/widgets/app_loading_state.dart';
import 'package:spendora/features/dashboard/presentation/pages/home_dashboard_page.dart';
import 'package:spendora/features/goals/controller/goals_page_controller.dart';
import 'package:spendora/features/goals/presentation/pages/goals_page.dart';
import 'package:spendora/features/insights/presentation/pages/insights_page.dart';
import 'package:spendora/features/settings/presentation/pages/settings_page.dart';
import 'package:spendora/features/shell/constants/shell_destination.dart';
import 'package:spendora/features/transactions/presentation/pages/transactions_page.dart';

class MainShellPage extends ConsumerStatefulWidget {
  const MainShellPage({super.key});

  @override
  ConsumerState<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends ConsumerState<MainShellPage> {
  ShellDestination _currentDestination = ShellDestination.home;

  final _savingsController = TextEditingController();
  final _limitController = TextEditingController();
  final _noSpendController = TextEditingController();

  @override
  void dispose() {
    _savingsController.dispose();
    _limitController.dispose();
    _noSpendController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    //Listening to alert messages related to all the data
    ref.listen(
      financeDataControllerProvider.select((state) => state.alertMessage),
      (previous, next) {
        if (next == null) {
          return;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.message)));
        ref.watch(financeDataControllerProvider.notifier).clearAlertMessage();
      },
    );

    final financeState = ref.watch(financeDataControllerProvider);

    final currentCurrency = ref.watch(
      currencyDataControllerProvider.select((s) => s.currency),
    );

    if (financeState.isLoading) {
      return const _ShellScaffold(child: SafeArea(child: AppLoadingState()));
    }
    if (financeState.errorMessage != null) {
      return _ShellScaffold(
        child: SafeArea(
          child: AppErrorState(
            alertMessage: financeState.errorMessage!,
            onRetry: () =>
                ref.watch(financeDataControllerProvider.notifier).reloadData(),
          ),
        ),
      );
    }

    //If no transactions are made
    if (financeState.transactions.isEmpty) {
      return _ShellScaffold(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        color: colors.accentSoft,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        size: 42,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Your money story starts with the first entry.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Add an income or expense to unlock the dashboard, goals, and insights across Spendora.',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: colors.textMuted),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          AppNavigator.goToTransactionForm(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        backgroundColor: AppColors.accent,
                      ),
                      child: const Text(
                        'Add transaction',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    //If no goals are added
    if (financeState.goal == null) {
      return _ShellScaffold(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        color: colors.accentSoft,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        size: 42,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Add some monthly goals to focus on healthy spending patterns.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: colors.outline),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextField(
                            controller: _savingsController,
                            keyboardType: TextInputType.number,

                            decoration: InputDecoration(
                              prefixText: getCurrencySymbol(currentCurrency),
                              labelText: 'Savings target',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _limitController,
                            keyboardType: TextInputType.number,

                            decoration: InputDecoration(
                              prefixText: getCurrencySymbol(currentCurrency),
                              labelText: 'Expense limit',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _noSpendController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'No-spend target days',
                            ),
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton(
                            onPressed: () async {
                              await ref
                                  .watch(goalsPageControllerProvider.notifier)
                                  .saveGoal(
                                    savingsTarget: _savingsController.text,
                                    monthlyLimit: _limitController.text,
                                    noSpendTargetDays: _noSpendController.text,
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              backgroundColor: AppColors.accent,
                            ),
                            child: const Text(
                              'Add goals',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return _ShellScaffold(
      drawer: _AppDrawer(
        selectedDestination: _currentDestination,
        onDestinationSelected: (destination) {
          AppNavigator.pop(context);
          setState(() {
            _currentDestination = destination;
          });
        },
      ),
      child: _buildSelectedPage(),
    );
  }

  Widget _buildSelectedPage() {
    return switch (_currentDestination) {
      ShellDestination.home => const HomeDashboardPage(),
      ShellDestination.transactions => const TransactionsPage(),
      ShellDestination.goals => const GoalsPage(),
      ShellDestination.insights => const InsightsPage(),
      ShellDestination.settings => const SettingsPage(),
    };
  }
}

//Drawer
class _AppDrawer extends StatelessWidget {
  final ShellDestination selectedDestination;
  final ValueChanged<ShellDestination> onDestinationSelected;

  const _AppDrawer({
    required this.selectedDestination,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spendora',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Navigate your money story.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: colors.textMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...ShellDestination.values.map((destination) {
                final selected = destination == selectedDestination;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    leading: Icon(
                      selected ? destination.selectedIcon : destination.icon,
                      color: selected ? colors.textPrimary : colors.textMuted,
                    ),
                    title: Text(
                      destination.label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: colors.textPrimary,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    tileColor: selected ? colors.accentSoft : null,
                    onTap: () => onDestinationSelected(destination),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// Common scaffold for different states
class _ShellScaffold extends StatelessWidget {
  final Widget child;
  final Widget? drawer;

  const _ShellScaffold({required this.child, this.drawer});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: drawer == null
          ? null
          : AppBar(
              backgroundColor: colors.background,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              titleSpacing: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spendora',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.textPrimary,
                      letterSpacing: 0.2,
                    ),
                  ),
                  Text(
                    'Navigate your money story.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: colors.textMuted),
                  ),
                ],
              ),
            ),
      drawer: drawer,
      body: child,
    );
  }
}
