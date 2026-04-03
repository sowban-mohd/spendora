class MonthlyGoal {
  final double savingsTarget;
  final double monthlyExpenseLimit;
  final int noSpendTargetDays;

  const MonthlyGoal({
    required this.savingsTarget,
    required this.monthlyExpenseLimit,
    required this.noSpendTargetDays,
  });

  factory MonthlyGoal.initial() {
    return const MonthlyGoal(
      savingsTarget: 18000,
      monthlyExpenseLimit: 22000,
      noSpendTargetDays: 10,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'savingsTarget': savingsTarget,
      'monthlyExpenseLimit': monthlyExpenseLimit,
      'noSpendTargetDays': noSpendTargetDays,
    };
  }

  factory MonthlyGoal.fromMap(Map<String, dynamic> map) {
    return MonthlyGoal(
      savingsTarget: (map['savingsTarget'] as num).toDouble(),
      monthlyExpenseLimit: (map['monthlyExpenseLimit'] as num).toDouble(),
      noSpendTargetDays: (map['noSpendTargetDays'] as num).toInt(),
    );
  }

  MonthlyGoal copyWith({
    double? savingsTarget,
    double? monthlyExpenseLimit,
    int? noSpendTargetDays,
  }) {
    return MonthlyGoal(
      savingsTarget: savingsTarget ?? this.savingsTarget,
      monthlyExpenseLimit: monthlyExpenseLimit ?? this.monthlyExpenseLimit,
      noSpendTargetDays: noSpendTargetDays ?? this.noSpendTargetDays,
    );
  }
}
