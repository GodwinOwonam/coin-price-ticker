import 'dart:io';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/services/coin_rate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/ticker_card.dart';

CoinRateModel coinRateModel = CoinRateModel();

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  int selectedIndex = 1;
  String btcRate = '';
  String ethRate = '';
  String ltcRate = '';

  DropdownButton<String> androidDropdown() {
    return DropdownButton<String>(
      menuMaxHeight: 200.0,
      value: selectedCurrency,
      items: currenciesList
          .map(
            (currency) => DropdownMenuItem(
              value: currency,
              child: Text(currency),
            ),
          )
          .toList(),
      onChanged: (currency) async {
        String newCurrency = currency!;
        int newIndex = currenciesList.indexOf(currency!) + 1;

        await updateRates(newCurrency, newIndex);
      },
    );
  }

  CupertinoPicker iosPicker() {
    return CupertinoPicker(
      itemExtent: 42.0,
      onSelectedItemChanged: (int index) async {
        String newCurrency = currenciesList[index];
        int newIndex = index + 1;

        await updateRates(newCurrency, newIndex);
      },
      children: currenciesList
          .map(
            (currency) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(currency),
            ),
          )
          .toList(),
    );
  }

  Future<void> updateRates(String newCurrency, int newIndex) async {
    setState(() {
      btcRate = '';
      ethRate = '';
      ltcRate = '';

      selectedCurrency = newCurrency;
      selectedIndex = newIndex;
    });

    Map<String, String> rates = await CoinData().getCryptoRates(selectedIndex);

    setState(() {
      btcRate = rates['BTC']!;
      ethRate = rates['ETH']!;
      ltcRate = rates['LTC']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('🤑 Coin Ticker')),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TickerCard(
                  base: 'BTC', rate: btcRate, currency: selectedCurrency),
              TickerCard(
                  base: 'ETH', rate: ethRate, currency: selectedCurrency),
              TickerCard(
                  base: 'LTC', rate: ltcRate, currency: selectedCurrency),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: !Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
