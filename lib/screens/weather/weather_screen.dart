import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

 @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? weather;
  bool loading = true;
  String? errorMessage;

 Future<void> loadWeather() async {
  setState(() {
    loading = true;
    errorMessage = null;
  });

  try {
    final data = await ApiService.getWeather("Delhi");

    if (!mounted) return;

    setState(() {
      weather = data;
      loading = false;
      errorMessage = null;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      loading = false;
      errorMessage =
          "Unable to load weather.\nPlease check your internet connection.";
    });
  }
}
  
   @override
  void initState() {
    super.initState();
     loadWeather();
  }

  Widget buildWeatherInfo(
      IconData icon, String title, String value) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Icon(icon, color: Colors.green, size: 35),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(value),
          ],
        ),
      ),
    );
  }

  Widget forecastCard(
      String day,
      IconData icon,
      String temp,
      Color color,
      ) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(day),
        trailing: Text(
          temp,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
Widget _buildBody() {
  // LOADING STATE
  if (loading) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text(
            "Loading weather...",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // ERROR STATE
  if (errorMessage != null) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 70,
            ),

            const SizedBox(height: 20),

            const Text(
              "Weather Unavailable",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: loadWeather,
              icon: const Icon(Icons.refresh),
              label: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }

  // SUCCESSFUL WEATHER RESPONSE
  if (weather != null) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                weather!['name'] ?? 'Unknown Location',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "${weather!['main']['temp']} °C",
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                weather!['weather'][0]['description']
                    .toString()
                    .toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Icon(
                        Icons.water_drop,
                        size: 30,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${weather!['main']['humidity']}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Humidity"),
                    ],
                  ),

                  Column(
                    children: [
                      const Icon(
                        Icons.air,
                        size: 30,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${weather!['wind']['speed']} m/s",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Wind"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // NO DATA
  return const Center(
    child: Text(
      "No weather data available.",
      style: TextStyle(fontSize: 16),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F8F2),

      appBar: AppBar(
       title: const Text(
 ("weather"),
),

actions: [
  IconButton(
    icon: const Icon(Icons.refresh),
    onPressed: () async {
      setState(() {
        loading = true;
      });

      await loadWeather();
    },
  ),
],

        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

     body: _buildBody(),
      
    );
  }
}