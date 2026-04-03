// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, StoredTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    type,
    category,
    date,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class StoredTransaction extends DataClass
    implements Insertable<StoredTransaction> {
  final String id;
  final double amount;
  final String type;
  final String category;
  final DateTime date;
  final String notes;
  const StoredTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount'] = Variable<double>(amount);
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    map['date'] = Variable<DateTime>(date);
    map['notes'] = Variable<String>(notes);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      amount: Value(amount),
      type: Value(type),
      category: Value(category),
      date: Value(date),
      notes: Value(notes),
    );
  }

  factory StoredTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredTransaction(
      id: serializer.fromJson<String>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String>(notes),
    };
  }

  StoredTransaction copyWith({
    String? id,
    double? amount,
    String? type,
    String? category,
    DateTime? date,
    String? notes,
  }) => StoredTransaction(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    type: type ?? this.type,
    category: category ?? this.category,
    date: date ?? this.date,
    notes: notes ?? this.notes,
  );
  StoredTransaction copyWithCompanion(TransactionsCompanion data) {
    return StoredTransaction(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredTransaction(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, type, category, date, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredTransaction &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.category == this.category &&
          other.date == this.date &&
          other.notes == this.notes);
}

class TransactionsCompanion extends UpdateCompanion<StoredTransaction> {
  final Value<String> id;
  final Value<double> amount;
  final Value<String> type;
  final Value<String> category;
  final Value<DateTime> date;
  final Value<String> notes;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required double amount,
    required String type,
    required String category,
    required DateTime date,
    required String notes,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amount = Value(amount),
       type = Value(type),
       category = Value(category),
       date = Value(date),
       notes = Value(notes);
  static Insertable<StoredTransaction> custom({
    Expression<String>? id,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<String>? category,
    Expression<DateTime>? date,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<double>? amount,
    Value<String>? type,
    Value<String>? category,
    Value<DateTime>? date,
    Value<String>? notes,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MonthlyGoalsTable extends MonthlyGoals
    with TableInfo<$MonthlyGoalsTable, StoredMonthlyGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlyGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _savingsTargetMeta = const VerificationMeta(
    'savingsTarget',
  );
  @override
  late final GeneratedColumn<double> savingsTarget = GeneratedColumn<double>(
    'savings_target',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyExpenseLimitMeta =
      const VerificationMeta('monthlyExpenseLimit');
  @override
  late final GeneratedColumn<double> monthlyExpenseLimit =
      GeneratedColumn<double>(
        'monthly_expense_limit',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _noSpendTargetDaysMeta = const VerificationMeta(
    'noSpendTargetDays',
  );
  @override
  late final GeneratedColumn<int> noSpendTargetDays = GeneratedColumn<int>(
    'no_spend_target_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    savingsTarget,
    monthlyExpenseLimit,
    noSpendTargetDays,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoredMonthlyGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('savings_target')) {
      context.handle(
        _savingsTargetMeta,
        savingsTarget.isAcceptableOrUnknown(
          data['savings_target']!,
          _savingsTargetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_savingsTargetMeta);
    }
    if (data.containsKey('monthly_expense_limit')) {
      context.handle(
        _monthlyExpenseLimitMeta,
        monthlyExpenseLimit.isAcceptableOrUnknown(
          data['monthly_expense_limit']!,
          _monthlyExpenseLimitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyExpenseLimitMeta);
    }
    if (data.containsKey('no_spend_target_days')) {
      context.handle(
        _noSpendTargetDaysMeta,
        noSpendTargetDays.isAcceptableOrUnknown(
          data['no_spend_target_days']!,
          _noSpendTargetDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_noSpendTargetDaysMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredMonthlyGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredMonthlyGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      savingsTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}savings_target'],
      )!,
      monthlyExpenseLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monthly_expense_limit'],
      )!,
      noSpendTargetDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}no_spend_target_days'],
      )!,
    );
  }

  @override
  $MonthlyGoalsTable createAlias(String alias) {
    return $MonthlyGoalsTable(attachedDatabase, alias);
  }
}

class StoredMonthlyGoal extends DataClass
    implements Insertable<StoredMonthlyGoal> {
  final int id;
  final double savingsTarget;
  final double monthlyExpenseLimit;
  final int noSpendTargetDays;
  const StoredMonthlyGoal({
    required this.id,
    required this.savingsTarget,
    required this.monthlyExpenseLimit,
    required this.noSpendTargetDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['savings_target'] = Variable<double>(savingsTarget);
    map['monthly_expense_limit'] = Variable<double>(monthlyExpenseLimit);
    map['no_spend_target_days'] = Variable<int>(noSpendTargetDays);
    return map;
  }

  MonthlyGoalsCompanion toCompanion(bool nullToAbsent) {
    return MonthlyGoalsCompanion(
      id: Value(id),
      savingsTarget: Value(savingsTarget),
      monthlyExpenseLimit: Value(monthlyExpenseLimit),
      noSpendTargetDays: Value(noSpendTargetDays),
    );
  }

  factory StoredMonthlyGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredMonthlyGoal(
      id: serializer.fromJson<int>(json['id']),
      savingsTarget: serializer.fromJson<double>(json['savingsTarget']),
      monthlyExpenseLimit: serializer.fromJson<double>(
        json['monthlyExpenseLimit'],
      ),
      noSpendTargetDays: serializer.fromJson<int>(json['noSpendTargetDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'savingsTarget': serializer.toJson<double>(savingsTarget),
      'monthlyExpenseLimit': serializer.toJson<double>(monthlyExpenseLimit),
      'noSpendTargetDays': serializer.toJson<int>(noSpendTargetDays),
    };
  }

  StoredMonthlyGoal copyWith({
    int? id,
    double? savingsTarget,
    double? monthlyExpenseLimit,
    int? noSpendTargetDays,
  }) => StoredMonthlyGoal(
    id: id ?? this.id,
    savingsTarget: savingsTarget ?? this.savingsTarget,
    monthlyExpenseLimit: monthlyExpenseLimit ?? this.monthlyExpenseLimit,
    noSpendTargetDays: noSpendTargetDays ?? this.noSpendTargetDays,
  );
  StoredMonthlyGoal copyWithCompanion(MonthlyGoalsCompanion data) {
    return StoredMonthlyGoal(
      id: data.id.present ? data.id.value : this.id,
      savingsTarget: data.savingsTarget.present
          ? data.savingsTarget.value
          : this.savingsTarget,
      monthlyExpenseLimit: data.monthlyExpenseLimit.present
          ? data.monthlyExpenseLimit.value
          : this.monthlyExpenseLimit,
      noSpendTargetDays: data.noSpendTargetDays.present
          ? data.noSpendTargetDays.value
          : this.noSpendTargetDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredMonthlyGoal(')
          ..write('id: $id, ')
          ..write('savingsTarget: $savingsTarget, ')
          ..write('monthlyExpenseLimit: $monthlyExpenseLimit, ')
          ..write('noSpendTargetDays: $noSpendTargetDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, savingsTarget, monthlyExpenseLimit, noSpendTargetDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredMonthlyGoal &&
          other.id == this.id &&
          other.savingsTarget == this.savingsTarget &&
          other.monthlyExpenseLimit == this.monthlyExpenseLimit &&
          other.noSpendTargetDays == this.noSpendTargetDays);
}

class MonthlyGoalsCompanion extends UpdateCompanion<StoredMonthlyGoal> {
  final Value<int> id;
  final Value<double> savingsTarget;
  final Value<double> monthlyExpenseLimit;
  final Value<int> noSpendTargetDays;
  const MonthlyGoalsCompanion({
    this.id = const Value.absent(),
    this.savingsTarget = const Value.absent(),
    this.monthlyExpenseLimit = const Value.absent(),
    this.noSpendTargetDays = const Value.absent(),
  });
  MonthlyGoalsCompanion.insert({
    this.id = const Value.absent(),
    required double savingsTarget,
    required double monthlyExpenseLimit,
    required int noSpendTargetDays,
  }) : savingsTarget = Value(savingsTarget),
       monthlyExpenseLimit = Value(monthlyExpenseLimit),
       noSpendTargetDays = Value(noSpendTargetDays);
  static Insertable<StoredMonthlyGoal> custom({
    Expression<int>? id,
    Expression<double>? savingsTarget,
    Expression<double>? monthlyExpenseLimit,
    Expression<int>? noSpendTargetDays,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (savingsTarget != null) 'savings_target': savingsTarget,
      if (monthlyExpenseLimit != null)
        'monthly_expense_limit': monthlyExpenseLimit,
      if (noSpendTargetDays != null) 'no_spend_target_days': noSpendTargetDays,
    });
  }

  MonthlyGoalsCompanion copyWith({
    Value<int>? id,
    Value<double>? savingsTarget,
    Value<double>? monthlyExpenseLimit,
    Value<int>? noSpendTargetDays,
  }) {
    return MonthlyGoalsCompanion(
      id: id ?? this.id,
      savingsTarget: savingsTarget ?? this.savingsTarget,
      monthlyExpenseLimit: monthlyExpenseLimit ?? this.monthlyExpenseLimit,
      noSpendTargetDays: noSpendTargetDays ?? this.noSpendTargetDays,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (savingsTarget.present) {
      map['savings_target'] = Variable<double>(savingsTarget.value);
    }
    if (monthlyExpenseLimit.present) {
      map['monthly_expense_limit'] = Variable<double>(
        monthlyExpenseLimit.value,
      );
    }
    if (noSpendTargetDays.present) {
      map['no_spend_target_days'] = Variable<int>(noSpendTargetDays.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyGoalsCompanion(')
          ..write('id: $id, ')
          ..write('savingsTarget: $savingsTarget, ')
          ..write('monthlyExpenseLimit: $monthlyExpenseLimit, ')
          ..write('noSpendTargetDays: $noSpendTargetDays')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $MonthlyGoalsTable monthlyGoals = $MonthlyGoalsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    transactions,
    monthlyGoals,
  ];
}

typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      required double amount,
      required String type,
      required String category,
      required DateTime date,
      required String notes,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<double> amount,
      Value<String> type,
      Value<String> category,
      Value<DateTime> date,
      Value<String> notes,
      Value<int> rowid,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          StoredTransaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            StoredTransaction,
            BaseReferences<
              _$AppDatabase,
              $TransactionsTable,
              StoredTransaction
            >,
          ),
          StoredTransaction,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                amount: amount,
                type: type,
                category: category,
                date: date,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required double amount,
                required String type,
                required String category,
                required DateTime date,
                required String notes,
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                amount: amount,
                type: type,
                category: category,
                date: date,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      StoredTransaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        StoredTransaction,
        BaseReferences<_$AppDatabase, $TransactionsTable, StoredTransaction>,
      ),
      StoredTransaction,
      PrefetchHooks Function()
    >;
typedef $$MonthlyGoalsTableCreateCompanionBuilder =
    MonthlyGoalsCompanion Function({
      Value<int> id,
      required double savingsTarget,
      required double monthlyExpenseLimit,
      required int noSpendTargetDays,
    });
typedef $$MonthlyGoalsTableUpdateCompanionBuilder =
    MonthlyGoalsCompanion Function({
      Value<int> id,
      Value<double> savingsTarget,
      Value<double> monthlyExpenseLimit,
      Value<int> noSpendTargetDays,
    });

class $$MonthlyGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $MonthlyGoalsTable> {
  $$MonthlyGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get savingsTarget => $composableBuilder(
    column: $table.savingsTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monthlyExpenseLimit => $composableBuilder(
    column: $table.monthlyExpenseLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get noSpendTargetDays => $composableBuilder(
    column: $table.noSpendTargetDays,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MonthlyGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthlyGoalsTable> {
  $$MonthlyGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get savingsTarget => $composableBuilder(
    column: $table.savingsTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monthlyExpenseLimit => $composableBuilder(
    column: $table.monthlyExpenseLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get noSpendTargetDays => $composableBuilder(
    column: $table.noSpendTargetDays,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MonthlyGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthlyGoalsTable> {
  $$MonthlyGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get savingsTarget => $composableBuilder(
    column: $table.savingsTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get monthlyExpenseLimit => $composableBuilder(
    column: $table.monthlyExpenseLimit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get noSpendTargetDays => $composableBuilder(
    column: $table.noSpendTargetDays,
    builder: (column) => column,
  );
}

class $$MonthlyGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MonthlyGoalsTable,
          StoredMonthlyGoal,
          $$MonthlyGoalsTableFilterComposer,
          $$MonthlyGoalsTableOrderingComposer,
          $$MonthlyGoalsTableAnnotationComposer,
          $$MonthlyGoalsTableCreateCompanionBuilder,
          $$MonthlyGoalsTableUpdateCompanionBuilder,
          (
            StoredMonthlyGoal,
            BaseReferences<
              _$AppDatabase,
              $MonthlyGoalsTable,
              StoredMonthlyGoal
            >,
          ),
          StoredMonthlyGoal,
          PrefetchHooks Function()
        > {
  $$MonthlyGoalsTableTableManager(_$AppDatabase db, $MonthlyGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthlyGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthlyGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthlyGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> savingsTarget = const Value.absent(),
                Value<double> monthlyExpenseLimit = const Value.absent(),
                Value<int> noSpendTargetDays = const Value.absent(),
              }) => MonthlyGoalsCompanion(
                id: id,
                savingsTarget: savingsTarget,
                monthlyExpenseLimit: monthlyExpenseLimit,
                noSpendTargetDays: noSpendTargetDays,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double savingsTarget,
                required double monthlyExpenseLimit,
                required int noSpendTargetDays,
              }) => MonthlyGoalsCompanion.insert(
                id: id,
                savingsTarget: savingsTarget,
                monthlyExpenseLimit: monthlyExpenseLimit,
                noSpendTargetDays: noSpendTargetDays,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MonthlyGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MonthlyGoalsTable,
      StoredMonthlyGoal,
      $$MonthlyGoalsTableFilterComposer,
      $$MonthlyGoalsTableOrderingComposer,
      $$MonthlyGoalsTableAnnotationComposer,
      $$MonthlyGoalsTableCreateCompanionBuilder,
      $$MonthlyGoalsTableUpdateCompanionBuilder,
      (
        StoredMonthlyGoal,
        BaseReferences<_$AppDatabase, $MonthlyGoalsTable, StoredMonthlyGoal>,
      ),
      StoredMonthlyGoal,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$MonthlyGoalsTableTableManager get monthlyGoals =>
      $$MonthlyGoalsTableTableManager(_db, _db.monthlyGoals);
}
