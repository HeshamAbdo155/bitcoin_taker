import 'package:http/http.dart' as http;
import 'dart:convert';

const apikey = '96655B4B-A112-42AD-9500-7F5135D36E49';

class BitcoinNetwork {
  Future getData(String selectedCurrency) async {
    http.Response response = await http.get(Uri.parse(
        'https://rest.coinapi.io/v1/exchangerate/BTC/$selectedCurrency?apikey=$apikey'));
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      double price = decodedData['rate'];
      return price;
    } else {
      throw Exception('failed to load Api <-----> ${response.statusCode}');
    }
  }
}
