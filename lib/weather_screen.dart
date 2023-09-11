import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/hourly_forecast.dart';
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
 
  final _textController = TextEditingController();
  String currentCity = 'Delhi';
  late Future<Map<String, dynamic>> weather = getCurrentWeather(currentCity);
  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
   
    
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$openWeatherApiKey'),
      );
      final data = jsonDecode(res.body);
      if (data["cod"] != "200") {
        throw 'An Unexpected Error Occurred';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    
    super.initState();
    weather = getCurrentWeather(currentCity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                
                setState(() {
                  weather = getCurrentWeather(currentCity);
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              
              return  Container(
                 alignment: Alignment.center,
                padding:const  EdgeInsets.symmetric(vertical: 350),
                child: const CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
                  
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 350),
                child: Text(snapshot.error.toString()));
            }
            final data = snapshot.data;
            final currentData = data!['list'][0];
            final currentTemp = currentData['main']['temp'];
            final currentSky = currentData['weather'][0]['main'];
            IconData currentIcon=Icons.sunny;
            if(currentSky=="Rain") {
              currentIcon=Icons.cloudy_snowing;
            }
            if(currentSky=="Clouds") {
              currentIcon=Icons.cloud;
            }
            final currentPressure = currentData['main']['pressure'];
            final currentWind = currentData['wind']['speed'];
            final currentHumidity = currentData['main']['humidity'];
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _textController,
                    textCapitalization: TextCapitalization.words,
                    onSubmitted: (value) {
                      if(_textController.text.isEmpty){
                        return;
                      }
                      setState(() {
                        currentCity = _textController.text;
                        
                        weather = getCurrentWeather(currentCity);
                      });
                    },
                    decoration: const InputDecoration(
                        hintText: 'Search City', icon: Icon(Icons.search)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  currentCity,
                                  
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                                Text(
                                  '${(currentTemp - 273.15).toStringAsFixed(2)} °C',
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Icon(
                                  currentIcon,
                                  size: 64,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  currentSky,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 28),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Hourly Forecast',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        final hourlyData = data['list'][index + 1];
                        final time =
                            DateTime.parse(hourlyData['dt_txt'].toString());
                        IconData hourIcon=Icons.sunny;
                        if(hourlyData['weather'][0]['main'] =='Clouds'){
                          hourIcon=Icons.cloud;
                        }
                        if(hourlyData['weather'][0]['main'] =='Rain'){
                          hourIcon=Icons.cloudy_snowing;
                        }
                        return HorlyForecast(
                            time: DateFormat.j().format(time),
                            icon: hourIcon,
                            temp: hourlyData['main']['temp']);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Additional Information',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      additional_info(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currentHumidity.toString(),
                      ),
                      additional_info(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: currentWind.toString(),
                      ),
                      additional_info(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: currentPressure.toString(),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
