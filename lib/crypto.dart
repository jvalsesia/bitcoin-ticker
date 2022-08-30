
import 'package:bitcoin_ticker/networking.dart';

class Crypto {
  Future<dynamic> getCryptoData(String currency) async {
    String url = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=$currency&ids=bitcoin,ethereum,litecoin';
    Networking networking = Networking(url);
    dynamic bitcoinData = await networking.getData();
    return bitcoinData;
  }
}
