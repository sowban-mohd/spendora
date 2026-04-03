import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/controller/finance_data_controller.dart';
import 'package:spendora/core/routes/app_navigator.dart';
import 'package:spendora/core/theme/app_colors.dart';
import 'package:spendora/core/widgets/app_error_state.dart';
import 'package:spendora/core/widgets/app_loading_state.dart';
import 'package:spendora/features/dashboard/presentation/pages/home_dashboard_page.dart';
import 'package:spendora/features/goals/presentation/pages/goals_page.dart';
import 'package:spendora/features/insights/presentation/pages/insights_page.dart';
import 'package:spendora/features/transactions/presentation/pages/transactions_page.dart';

class MainShellPage extends ConsumerStatefulWidget {
  const MainShellPage({super.key});

  @override
  ConsumerState<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends ConsumerState<MainShellPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
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

    const pages = [
      HomeDashboardPage(),
      TransactionsPage(),
      GoalsPage(),
      InsightsPage(),
    ];

    final financeState = ref.watch(financeDataControllerProvider);

    if (financeState.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: AppLoadingState()),
      );
    }
    if (financeState.errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: AppErrorState(
            alertMessage: financeState.errorMessage!,
            onRetry: () =>
                ref.watch(financeDataControllerProvider.notifier).reloadData(),
          ),
        ),
      );
    }

    if (financeState.transactions.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
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
                        color: AppColors.accentSoft,
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
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Add an income or expense to unlock the dashboard, goals, and insights across Spendora.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          AppNavigator.goToTransactionForm(context),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical:  12, horizontal: 24),
                        backgroundColor: AppColors.accent,
                      ),
                      child: const Text('Add transaction', style: TextStyle(color: Colors.white, fontSize: 18), ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final bottomNavigationBar = NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.accentSoft,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long_rounded),
          label: 'Transactions',
        ),
        NavigationDestination(
          icon: Icon(Icons.flag_outlined),
          selectedIcon: Icon(Icons.flag_rounded),
          label: 'Goals',
        ),
        NavigationDestination(
          icon: Icon(Icons.insights_outlined),
          selectedIcon: Icon(Icons.insights_rounded),
          label: 'Insights',
        ),
      ],
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
