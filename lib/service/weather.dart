import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getWeather(String longitude, String latitude) async {
  

  String url =
      'https://api.openweathermap.org/data/3.0/onecall?lat=$latitude&lon=$longitude&appid=69386c6cb777decb20f24d475d2d51ad&lang=es&units=metric';

  try {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print("Respuesta: ${response.body}");
      return {
        'current': {
          'temp': result['current']['temp'],
          'description': result['current']['weather'][0]['description'],
          'humidity': result['current']['humidity'],
          'clouds': result['current']['clouds'],
        },
        'daily': List.generate(3, (index) => {
          'temp_max': result['daily'][index]['temp']['max'],
          'temp_min': result['daily'][index]['temp']['min'],
          'description': result['daily'][index]['weather'][0]['description'],
          'humidity': result['daily'][index]['humidity'],
        }),
      };
    } else {
      throw Exception('Fallo cargano el clima');
    }
  } catch (e) {
    print(e);
    throw Exception( e.toString());
  }
}