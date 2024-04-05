import 'package:flutter/material.dart';
import 'package:calculator/pages/consts.dart';
import 'package:weather/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  String _cityName = '';
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    _getWeatherData("Gurgaon");
  }

  void _getWeatherData(String city) {
    setState(() {
      _isLoading = true;
    });
    _wf.currentWeatherByCityName(city).then((w) {
      setState(() {
        _weather = w;
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch weather data. Please check the city name and try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        backgroundColor: const Color.fromARGB(255, 96, 176, 241),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                onChanged: (value) {
                  _cityName = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter City Name',
                  labelText: 'City Name',
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _getWeatherData(_cityName);
                  }
                },
                child: Text('Get Weather'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: _weather != null
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Temperature: ${_weather!.temperature?.celsius.toString()} °C',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Description: ${_weather!.weatherDescription ?? 'N/A'}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Humidity: ${_weather!.humidity ?? 'N/A'}%',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Wind Speed: ${_weather!.windSpeed?.toString()} m/s',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ),
          ],
        ),
      ),
    );
  }
}
