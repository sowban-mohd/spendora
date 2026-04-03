import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/controller/finance_data_controller.dart';
import 'package:spendora/core/models/alert_message.dart';
import 'package:spendora/core/models/monthly_goal.dart';

final goalsPageControllerProvider =
    NotifierProvider.autoDispose<GoalsPageController, GoalsPageState>(
  GoalsPageController.new,
);

class GoalsPageController extends Notifier<GoalsPageState> {
  @override
  GoalsPageState build() {
    return const GoalsPageState(isSaving: false);
  }

  Future<bool> saveGoal({
    required String savingsTarget,
    required String monthlyLimit,
    required String noSpendTargetDays,
  }) async {
    final parsedSavingsTarget = double.tryParse(savingsTarget.trim());
    final parsedMonthlyLimit = double.tryParse(monthlyLimit.trim());
    final parsedNoSpendDays = int.tryParse(noSpendTargetDays.trim());

    if (parsedSavingsTarget == null ||
        parsedMonthlyLimit == null ||
        parsedNoSpendDays == null ||
        parsedSavingsTarget <= 0 ||
        parsedMonthlyLimit <= 0 ||
        parsedNoSpendDays < 0) {
      state = state.copyWith(
        alertMessage: const AlertMessage(
          header: 'Invalid values',
          message: 'Please enter valid numbers for all goal fields.',
        ),
      );
      return false;
    }

    state = state.copyWith(isSaving: true, alertMessage: null);
    final goal = MonthlyGoal(
      savingsTarget: parsedSavingsTarget,
      monthlyExpenseLimit: parsedMonthlyLimit,
      noSpendTargetDays: parsedNoSpendDays,
    );
    await ref.watch(financeDataControllerProvider.notifier).updateGoal(goal);
    state = state.copyWith(isSaving: false, alertMessage: null);
    return true;
  }

  void clearAlertMessage() {
    state = state.copyWith(alertMessage: null);
  }
}

class GoalsPageState {
  final bool isSaving;
  final AlertMessage? alertMessage;

  const GoalsPageState({required this.isSaving, this.alertMessage});

  GoalsPageState copyWith({
    bool? isSaving,
    AlertMessage? alertMessage,
  }) {
    return GoalsPageState(
      isSaving: isSaving ?? this.isSaving,
      alertMessage: alertMessage,
    );
  }
}
