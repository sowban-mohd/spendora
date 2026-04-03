import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/models/alert_message.dart';
import 'package:spendora/core/models/finance_transaction.dart';
import 'package:spendora/core/models/monthly_goal.dart' as goal_model;
import 'package:spendora/core/services/app_database.dart';

final localFinanceServiceProvider = Provider(
  (ref) => LocalFinanceService(ref.watch(appDatabaseProvider)),
);

class LocalFinanceService {
  LocalFinanceService(this._database);

  final AppDatabase _database;

  Future<List<FinanceTransaction>> loadTransactions() async {
    // await _seedDemoData();
    final rows = await (_database.select(
      _database.transactions,
    )..orderBy([(table) => OrderingTerm.desc(table.date)])).get();
    return rows.map(_mapTransactionRow).toList();
  }

  Future<void> addTransaction(FinanceTransaction transaction) async {
    try {
      await _database
          .into(_database.transactions)
          .insert(_mapTransactionCompanion(transaction));
    } catch (e) {
      debugPrint(e.toString());
      throw AlertMessage(
        header: 'Error',
        message: 'Failed to add transaction, something went wrong.',
      );
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await (_database.delete(
        _database.transactions,
      )..where((t) => t.id.equals(id))).go();
    } catch (e) {
      debugPrint(e.toString());
      throw AlertMessage(
        header: 'Error',
        message: 'Failed to delete transaction, something went wrong.',
      );
    }
  }

  Future<void> updateTransaction(FinanceTransaction transaction) async {
    try {
      await _database
          .update(_database.transactions)
          .replace(_mapTransactionCompanion(transaction));
    } catch (e) {
      debugPrint(e.toString());
      throw AlertMessage(
        header: 'Error',
        message: 'Failed to update transaction, something went wrong.',
      );
    }
  }

  Future<goal_model.MonthlyGoal> loadGoal() async {
    final row = await (_database.select(
      _database.monthlyGoals,
    )..where((table) => table.id.equals(1))).getSingleOrNull();
    if (row == null) {
      return goal_model.MonthlyGoal.initial();
    }
    return goal_model.MonthlyGoal(
      savingsTarget: row.savingsTarget,
      monthlyExpenseLimit: row.monthlyExpenseLimit,
      noSpendTargetDays: row.noSpendTargetDays,
    );
  }

  Future<void> updateGoal(goal_model.MonthlyGoal goal) async {
    try {
      await _database
          .into(_database.monthlyGoals)
          .insertOnConflictUpdate(
            MonthlyGoalsCompanion(
              id: const Value(1),
              savingsTarget: Value(goal.savingsTarget),
              monthlyExpenseLimit: Value(goal.monthlyExpenseLimit),
              noSpendTargetDays: Value(goal.noSpendTargetDays),
            ),
          );
    } catch (e) {
      debugPrint(e.toString());
      throw AlertMessage(
        header: "Error",
        message: "Error updating goal, something went wrong.",
      );
    }
  }

  Future<void> _seedDemoData() async {
    final transactionCount = await _database.managers.transactions.count();
    final goalCount = await _database.managers.monthlyGoals.count();

    //Only adding data if database is empty
    if (transactionCount > 0 || goalCount > 0) {
      return;
    }

    final now = DateTime.now();
    final seedTransactions = <FinanceTransaction>[
      FinanceTransaction(
        id: 'txn-1',
        amount: 42000,
        type: TransactionType.income,
        category: TransactionCategory.salary,
        date: DateTime(now.year, now.month, 1),
        notes: 'Monthly salary',
      ),
      FinanceTransaction(
        id: 'txn-2',
        amount: 2500,
        type: TransactionType.income,
        category: TransactionCategory.freelance,
        date: now.subtract(const Duration(days: 2)),
        notes: 'Design side project',
      ),
      FinanceTransaction(
        id: 'txn-3',
        amount: 420,
        type: TransactionType.expense,
        category: TransactionCategory.food,
        date: now.subtract(const Duration(days: 1)),
        notes: 'Lunch and coffee',
      ),
      FinanceTransaction(
        id: 'txn-4',
        amount: 1200,
        type: TransactionType.expense,
        category: TransactionCategory.transport,
        date: now.subtract(const Duration(days: 3)),
        notes: 'Cab rides',
      ),
      FinanceTransaction(
        id: 'txn-5',
        amount: 3800,
        type: TransactionType.expense,
        category: TransactionCategory.shopping,
        date: now.subtract(const Duration(days: 5)),
        notes: 'Shoes and essentials',
      ),
      FinanceTransaction(
        id: 'txn-6',
        amount: 1600,
        type: TransactionType.expense,
        category: TransactionCategory.bills,
        date: now.subtract(const Duration(days: 7)),
        notes: 'Mobile and internet',
      ),
      FinanceTransaction(
        id: 'txn-7',
        amount: 5000,
        type: TransactionType.income,
        category: TransactionCategory.freelance,
        date: now.subtract(const Duration(days: 9)),
        notes: 'Workshop payment',
      ),
      FinanceTransaction(
        id: 'txn-8',
        amount: 950,
        type: TransactionType.expense,
        category: TransactionCategory.entertainment,
        date: now.subtract(const Duration(days: 11)),
        notes: 'Movie night',
      ),
      FinanceTransaction(
        id: 'txn-9',
        amount: 2200,
        type: TransactionType.expense,
        category: TransactionCategory.health,
        date: now.subtract(const Duration(days: 14)),
        notes: 'Pharmacy and checkup',
      ),
      FinanceTransaction(
        id: 'txn-10',
        amount: 3200,
        type: TransactionType.expense,
        category: TransactionCategory.savings,
        date: now.subtract(const Duration(days: 16)),
        notes: 'Moved to rainy day fund',
      ),
      FinanceTransaction(
        id: 'txn-11',
        amount: 750,
        type: TransactionType.expense,
        category: TransactionCategory.food,
        date: now.subtract(const Duration(days: 19)),
        notes: 'Dinner with friends',
      ),
      FinanceTransaction(
        id: 'txn-12',
        amount: 1800,
        type: TransactionType.expense,
        category: TransactionCategory.education,
        date: now.subtract(const Duration(days: 24)),
        notes: 'Course renewal',
      ),
    ];

    await _database.transaction(() async {
      await _database.batch((batch) {
        batch.insertAll(
          _database.transactions,
          seedTransactions.map(_mapTransactionCompanion).toList(),
        );
      });
      await _database
          .into(_database.monthlyGoals)
          .insert(
            MonthlyGoalsCompanion(
              id: const Value(1),
              savingsTarget: Value(
                goal_model.MonthlyGoal.initial().savingsTarget,
              ),
              monthlyExpenseLimit: Value(
                goal_model.MonthlyGoal.initial().monthlyExpenseLimit,
              ),
              noSpendTargetDays: Value(
                goal_model.MonthlyGoal.initial().noSpendTargetDays,
              ),
            ),
          );
    });
  }

  //Data mapping helpers

  FinanceTransaction _mapTransactionRow(StoredTransaction row) {
    return FinanceTransaction(
      id: row.id,
      amount: row.amount,
      type: TransactionType.values.byName(row.type),
      category: TransactionCategory.values.byName(row.category),
      date: row.date,
      notes: row.notes,
    );
  }

  TransactionsCompanion _mapTransactionCompanion(
    FinanceTransaction transaction,
  ) {
    return TransactionsCompanion.insert(
      id: transaction.id,
      amount: transaction.amount,
      type: transaction.type.name,
      category: transaction.category.name,
      date: transaction.date,
      notes: transaction.notes,
    );
  }
}
