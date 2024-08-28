import 'dart:convert';
import 'package:http/http.dart' as http;

class HoroscopeService {
  static const String baseUrl = 'https://us-central1-tf-natal.cloudfunctions.net/horoscopeapi';
  static const String authToken = 'nBbT74igVTu6MtfMZD27';

  Future<Map<String, dynamic>> getHoroscope(String date, String sign) async {
    final url = Uri.parse('$baseUrl?date=$date&sign=$sign');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load horoscope');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}
