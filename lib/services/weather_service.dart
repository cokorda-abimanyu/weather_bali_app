import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const String _apiKey = '15f1ef1115f050dfbef37ef12b2f3378'
;
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> getWeatherByCity(String cityName) async {
    final uri = Uri.parse(
      '$_baseUrl?q=$cityName&appid=$_apiKey&units=metric',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception('Gagal mengambil data cuaca. Code: ${response.statusCode}');
    }
  }
}
