import 'package:spendora/core/models/alert_message.dart';
import 'package:spendora/core/models/finance_transaction.dart';
import 'package:spendora/core/models/monthly_goal.dart';

class FinanceDataState {
  final bool isLoading;
  final List<FinanceTransaction> transactions;
  final MonthlyGoal goal;
  final AlertMessage? errorMessage;
  final AlertMessage? alertMessage;

  const FinanceDataState({
    required this.isLoading,
    required this.transactions,
    required this.goal,
    this.errorMessage,
    this.alertMessage,
  });

  factory FinanceDataState.initial() {
    return FinanceDataState(
      isLoading: true,
      transactions: const [],
      goal: MonthlyGoal.initial(),
    );
  }

  FinanceDataState copyWith({
    bool? isLoading,
    List<FinanceTransaction>? transactions,
    MonthlyGoal? goal,
    AlertMessage? errorMessage,
    AlertMessage? alertMessage,
    bool clearAlertMessage = false,
    bool clearErrorMessage = false,
  }) {
    return FinanceDataState(
      isLoading: isLoading ?? this.isLoading,
      transactions: transactions ?? this.transactions,
      goal: goal ?? this.goal,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      alertMessage: clearAlertMessage
          ? null
          : alertMessage ?? this.alertMessage,
    );
  }
}
