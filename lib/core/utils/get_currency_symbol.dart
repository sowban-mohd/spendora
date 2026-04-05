import 'package:intl/intl.dart';

String getCurrencySymbol(String code) {
  return NumberFormat.simpleCurrency(name: code).currencySymbol;
}