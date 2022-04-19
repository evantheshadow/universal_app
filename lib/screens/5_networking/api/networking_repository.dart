import 'package:http/http.dart' as http;
import 'package:new_calc/screens/5_networking/api/networking_model.dart';
import 'package:new_calc/screens/5_networking/api/response/decoding.dart';
import 'package:new_calc/screens/5_networking/api/response/response_model.dart';


class NetworkingRepository {
  // API key
  // Base API url
  static const baseRequestTimeout = Duration(seconds: 45);
  static const String _baseUrl = "https://mashape-community-urban-dictionary.p.rapidapi.com";
  // Base headers for Response url
  static const Map<String, String> _headers = {
    "x-rapidapi-key": "74544559ecmsh9aab6980542918cp18063cjsne490e6cd3794",
    "x-rapidapi-host": "mashape-community-urban-dictionary.p.rapidapi.com",

  };

  // Base API request to get response
  Future<dynamic> getWordLink(String inputWord) async {
    // final String inputWord = 'wat';
    final requestUrl = '$_baseUrl/define?term=$inputWord';
    final response = await http
      .get(Uri.parse(requestUrl), headers: _headers)
      .timeout(baseRequestTimeout);
      final decoded = decodeResponseToJson(response);
    if (response.statusCode == 200) {
      final data = UrbanDictionaryCardResponse.fromJson(decoded);
      print("success: $data");
      return ResponseInformation(true, 200, data, '');
    } else {
      print("not success");
      return ResponseInformation(false, 400, null, 'Данные не были загружены :(');
    }
  }
}