import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_database.g.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

@DataClassName('StoredTransaction')
class Transactions extends Table {
  TextColumn get id => text()();
  RealColumn get amount => real()();
  TextColumn get type => text()();
  TextColumn get category => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('StoredMonthlyGoal')
class MonthlyGoals extends Table {
  IntColumn get id => integer()();
  RealColumn get savingsTarget => real()();
  RealColumn get monthlyExpenseLimit => real()();
  IntColumn get noSpendTargetDays => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [Transactions, MonthlyGoals])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'spendora'));

  @override
  int get schemaVersion => 1;
}
