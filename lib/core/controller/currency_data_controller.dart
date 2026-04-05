import 'package:damn_nullable/damn_nullable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:spendora/core/models/alert_message.dart';
import 'package:spendora/core/models/currency_data_state.dart';
import 'package:spendora/core/services/currency_exchange_service.dart';
import 'package:spendora/core/services/shared_preferences_provider.dart';

final currencyDataControllerProvider = NotifierProvider(
  CurrencyDataController.new,
);

class CurrencyDataController extends Notifier<CurrencyDataState> {
  final _currencyStorageKey = "currency";
  @override
  CurrencyDataState build() {
    final currency = _loadCurrency();
    return CurrencyDataState.initial(currency);
  }

  String? _loadCurrency() {
    return ref.read(sharedPreferencesProvider).getString(_currencyStorageKey);
  }

  void changeCurrency(String newCurrency) {
    state = state.copyWith(currency: newCurrency);
  }

  String formatCurrency(double value) {
    final currencyFormat = NumberFormat.simpleCurrency(
      name: state.currency,
      decimalDigits: 0,
    );
    return currencyFormat.format(value);
  }

  Future<bool> loadExchangeRates() async {
    state = state.copyWith(ratesLoading: true);
    try {
      final rates = await ref
          .read(currencyExchangeServiceProvider)
          .fetchLatestRates(state.currency);
      state = state.copyWith(exchangeRates: rates);
      state = state.copyWith(ratesLoading: false);
      return true;
    } on AlertMessage catch (e) {
      debugPrint(e.toString());
      state = state.copyWith(alertMessage: DamnNullable(e));
      state = state.copyWith(ratesLoading: false);
      return false;
    }
  }

  double convertAmount({
    required double amount,
    required String sourceCurrency,
  }) {
    final rate = state.exchangeRates![sourceCurrency]!;
    final convertedAmount = amount / rate;
    return convertedAmount;
  }

  void clearAlertMessage() {
    state = state.copyWith(alertMessage: DamnNullable(null));
  }
}
