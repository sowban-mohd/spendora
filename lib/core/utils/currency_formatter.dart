import 'package:intl/intl.dart';

final _currencyFormat = NumberFormat.currency(symbol: 'Rs ', decimalDigits: 0);

String formatCurrency(double value) => _currencyFormat.format(value);
