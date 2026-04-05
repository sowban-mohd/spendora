import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/core/models/alert_message.dart';
import 'package:spendora/core/services/dio_provider.dart';

final currencyExchangeServiceProvider = Provider<CurrencyExchangeService>((
  ref,
) {
  return CurrencyExchangeService(ref.read(dioProvider));
});

class CurrencyExchangeService {
  final Dio _dio;

  CurrencyExchangeService(this._dio);

  Future<Map<String, dynamic>> fetchLatestRates(String baseCode) async {
    try {
    final apiKey = dotenv.maybeGet('EXCHANGE_RATE_API_KEY')?.trim() ?? '';
    if (apiKey.isEmpty) {
      throw const AlertMessage(
        header: "Can't select currency",
        message: 'Exchange rate API key is missing.',
      );
    }

    final response = await _dio.get<Map<String, dynamic>>(
      '/$apiKey/latest/${baseCode.toUpperCase()}',
    );

    final data = response.data;
    debugPrint("Exchange rates response : $data");
    if (data == null) {
      throw const AlertMessage(
        header: "Can't select currency",
        message: 'Exchange rate response was empty.',
      );
    }

    if (data['result'] != 'success') {
      throw AlertMessage(
        header: "Can't select currency",
        message:
            data['error-type'] as String? ?? 'Exchange rate request failed.',
      );
    }

    return data['conversion_rates'] as Map<String, dynamic>;
    } catch (e){
      debugPrint(e.toString());
      throw AlertMessage(header: "Can't select currency", message: "Something went wrong, make sure you are connected to internet.");
    }
  }
}
