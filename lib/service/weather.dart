import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getWeather(String latitude, String longitude) async {
  final String apiKey = '69386c6cb777decb20f24d475d2d51ad';
  final String url = 'https://api.openweathermap.org/data/3.0/onecall?lat=$latitude&lon=$longitude&appid=$apiKey&lang=es&units=metric';

  try {
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return {
        'current': {
          'temp': data['current']['temp'],
          'description': data['current']['weather'][0]['description'],
          'humidity': data['current']['humidity'],
          'clouds': data['current']['clouds'],
        },
        'daily': List.generate(3, (index) => {
          'temp_max': data['daily'][index]['temp']['max'],
          'temp_min': data['daily'][index]['temp']['min'],
          'description': data['daily'][index]['weather'][0]['description'],
          'humidity': data['daily'][index]['humidity'],
        }),
      };
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}