import 'package:flutter/foundation.dart';

import '../services/networking.dart';

const base = '10.0.2.2:8080';

class CoinRateModel {
  Future<dynamic> getCoinRate(String baseCoin, int currencyIndex) async {
    NetworkHelper networkHelper = NetworkHelper();

    var url = Uri.http(base, '/$baseCoin/$currencyIndex');

    var data = await networkHelper.getData(url);

    return data['rate'];
  }
}
