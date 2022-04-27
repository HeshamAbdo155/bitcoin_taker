import 'package:bitcoin_taker/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../component/coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  DropdownButton<String> getAndroid() {
    return DropdownButton<String>(
      value: selectedCurrency,
      onChanged: (newValue) {
        setState(() {
          selectedCurrency = newValue!;
          getData();
        });
      },
      items: currenciesList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  CupertinoPicker getIos() {
    List<Text> pickerItems = [];
    for (String item in currenciesList) {
      pickerItems.add(Text(item));
    }
    return CupertinoPicker(
      backgroundColor: Colors.green,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      itemExtent: 33.0,
      children: pickerItems,
    );
  }

  String bitcoinValue = '?';
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      double data = await BitcoinNetwork().getData(selectedCurrency);
      isWaiting = false;
      setState(() {
        bitcoinValue = data.toStringAsFixed(0);
      });
    } catch (e) {
      (e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin 🤑 Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.green,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = ${isWaiting ? '?' : bitcoinValue} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 130.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.green,
            child: Platform.isIOS ? getIos() : getAndroid(),
          ),
        ],
      ),
    );
  }
}
