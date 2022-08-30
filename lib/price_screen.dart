import 'dart:io';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/crypto.dart';
import 'package:bitcoin_ticker/crypto_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Crypto crypto = Crypto();
  List<CryptoModel> cryptos = <CryptoModel>[];

  @override
  void initState() {
    super.initState();
    getBitcoinData();
  }

  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else if (value is int) {
      return 0.0 + value;
    } else {
      return value;
    }
  }

  Future<void> getBitcoinData() async {
    dynamic cryptoData = await crypto.getCryptoData(selectedCurrency);
    cryptos = [];
    setState(() => {
          cryptos.add(CryptoModel(checkDouble(cryptoData[0]['current_price']),
              cryptoData[0]['image'], cryptoData[0]['symbol'])),
          cryptos.add(CryptoModel(checkDouble(cryptoData[1]['current_price']),
              cryptoData[1]['image'], cryptoData[1]['symbol'])),
          cryptos.add(CryptoModel(checkDouble(cryptoData[2]['current_price']),
              cryptoData[2]['image'], cryptoData[2]['symbol'])),
        });
  }

  CupertinoPicker getCupertinoPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
        getBitcoinData();
      },
      children: [
        for (String currency in currenciesList) Text(currency),
      ],
    );
  }

  DropdownButton<String> getAndroidDropdownButton() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: [
        for (String currency in currenciesList)
          DropdownMenuItem(value: currency, child: Text(currency)),
      ],
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
        });
        getBitcoinData();
      },
    );
  }

  Widget getPicker() {
    if (kIsWeb) {
      return getAndroidDropdownButton();
    } else {
      return Platform.isIOS || Platform.isMacOS
          ? getCupertinoPicker()
          : getAndroidDropdownButton();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (CryptoModel crypto in cryptos)
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
              child: Card(
                color: Colors.lightBlueAccent,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(height: 50.0, width: 50.0, crypto.imageURL),
                      Text(
                        '1 ${crypto.symbol.toUpperCase()} = ${crypto.currentValue}  $selectedCurrency',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}
