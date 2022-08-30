import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:logger/logger.dart';

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class Networking {
  final String url;

  Networking(this.url);

  Future<dynamic> getData() async {
    loggerNoStack.d('url: $url');

    Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      loggerNoStack.i(jsonResponse);
      return jsonResponse;
    } else {
      loggerNoStack.v(
          'Request failed with status: ${response.statusCode} - ${response.body}');
    }
  }
}
