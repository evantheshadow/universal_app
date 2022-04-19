import 'dart:convert';
import 'package:http/http.dart' as http;

dynamic decodeResponseToJson(http.Response response) {
  final utfFormatted = const Utf8Decoder().convert(response.bodyBytes);
  final decoded = json.decode(utfFormatted);
  return decoded;
}