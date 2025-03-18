import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weatherappflutter/service/weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _weather;

  IconData _getWeatherIcon(String description) {
    if (description.contains('lluvia')) return Icons.water_drop;
    if (description.contains('nube')) return Icons.cloud;
    if (description.contains('sol')) return Icons.sunny;
    return Icons.cloud;
  }

  void _getWeather() async {
    if (_latitudeController.text.isEmpty || _longitudeController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Por favor ingrese latitud y longitud",
        backgroundColor: Colors.red
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var weather = await getWeather(
        _longitudeController.text.trim(),
        _latitudeController.text.trim(),
      );
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _weather = null;  
      });
      Fluttertoast.showToast(
        msg: "Error obteniendo el clima: ${e.toString()}", 
        backgroundColor: Colors.red
      );
      print(e);
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.blue[700],
      ),
      body:SingleChildScrollView( // Add this wrapper
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _latitudeController,
                    decoration: const InputDecoration(
                      labelText: 'Latitud',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _longitudeController,
                    decoration: const InputDecoration(
                      labelText: 'Longitud',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _getWeather();
              },
              child: const Text('Buscar'),
            ),
            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Clima actual:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    if (_isLoading)
                      const CircularProgressIndicator()
                    else if (_weather != null) ...[
                      Icon(
                        _getWeatherIcon(_weather!['current']['description']),
                        size: 50,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_weather!['current']['temp']}°C',
                        style: const TextStyle(fontSize: 32),
                      ),
                      Text(
                        _weather!['current']['description'],
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('Humedad'),
                              Text('${_weather!['current']['humidity']}%'),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('Nubes'),
                              Text('${_weather!['current']['clouds']}%'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Proximos 3 dias',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: _weather == null ? 0 : 3,
                itemBuilder: (context, index) {
                  if (_weather == null) return null;
                  var daily = _weather!['daily'][index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Día ${index + 1}'),
                          Icon(_getWeatherIcon(daily['description'])),
                          Column(
                            children: [
                              Text('${daily['temp_max']}°C'),
                              Text('${daily['temp_min']}°C'),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('Humedad'),
                              Text('${daily['humidity']}%'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
