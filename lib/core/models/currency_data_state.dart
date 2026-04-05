// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:damn_nullable/damn_nullable.dart';
import 'package:spendora/core/models/alert_message.dart';

class CurrencyDataState {
  final String currency;
  final Map<String, dynamic>? exchangeRates;
  final bool ratesLoading;
  final AlertMessage? alertMessage;
  CurrencyDataState({
    required this.currency,
    required this.ratesLoading,
    this.exchangeRates,
    this.alertMessage,
  });

  factory CurrencyDataState.initial(String? currency) =>
      CurrencyDataState(currency: currency ?? "INR", ratesLoading: false);

  @override
  String toString() =>
      'CurrencyDataState(currency: $currency, exchangeRates: $exchangeRates, alertMessage: $alertMessage)';

  CurrencyDataState copyWith({
    String? currency,
    Map<String, dynamic>? exchangeRates,
    bool? ratesLoading,
    DamnNullable<AlertMessage>? alertMessage,
  }) {
    return CurrencyDataState(
      currency: currency ?? this.currency,
      exchangeRates: exchangeRates ?? this.exchangeRates,
      ratesLoading: ratesLoading ?? this.ratesLoading,
      alertMessage: alertMessage.or(this.alertMessage),
    );
  }
}
