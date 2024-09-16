import 'dart:math';

import 'package:bitcoin_ticker/services/coin_rate.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<Map<String, String>> getCryptoRates(int baseCurrencyIndex) async {
    Map<String, String> rates = {};

    for (String crypto in cryptoList) {
      try {
        double coinRate = await CoinRateModel().getCoinRate(
          crypto,
          baseCurrencyIndex + 1,
        );

        rates[crypto] = coinRate.toStringAsFixed(2);
      } catch (error) {
        rates[crypto] = '';
      }
    }

    return rates;
  }
}
