// OpenWeatherMap API에 필요한 정보

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> fetchWeather(String city) async {
  final apiKey = '5ba422352bbc9637d35ff08ff5af681c';
  final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final weatherMain = data['weather'][0]['main']; // 예: Clear, Rain, Clouds
    return weatherMain;
  } else {
    throw Exception('Failed to fetch weather');
  }
}
