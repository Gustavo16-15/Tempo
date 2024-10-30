import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Previsão do Tempo',
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _city = 'São Paulo';
  String _weatherDescription = '';
  double _temperature = 0.0;
  String _errorMessage = ''; // Variável para mensagens de erro

  Future<void> fetchWeather() async {
    String apiKey =
        '86d95928027a64f2c820678867e9434d'; // Substitua pela sua chave de API
    String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _temperature = data['main']['temp'];
          _weatherDescription = data['weather'][0]['description'];
          _errorMessage = ''; // Limpar mensagem de erro
        });
      } else {
        setState(() {
          _errorMessage =
              'Erro: ${response.reasonPhrase}'; // Armazenar mensagem de erro
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro: $e'; // Armazenar mensagem de erro
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Previsão do Tempo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Cidade'),
              onChanged: (value) {
                _city = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                fetchWeather();
              },
              child: Text('Obter Previsão'),
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty) ...[
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ],
            Text(
              'Temperatura: $_temperature °C',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Descrição: $_weatherDescription',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
