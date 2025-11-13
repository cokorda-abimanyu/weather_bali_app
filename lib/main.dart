import 'package:flutter/material.dart';
import 'models/weather.dart';
import 'services/weather_service.dart';

void main() {
  runApp(const BaliWeatherApp());
}

class BaliWeatherApp extends StatelessWidget {
  const BaliWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bali Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF151515),
        fontFamily: 'Roboto',
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _searchController = TextEditingController(
    text: 'Denpasar',
  );

  Weather? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  final List<Map<String, dynamic>> _hourlyTemps = const [
    {'time': '08:00', 'temp': 19},
    {'time': '09:00', 'temp': 21},
    {'time': '10:00', 'temp': 23},
    {'time': '11:00', 'temp': 25},
    {'time': '12:00', 'temp': 26},
    {'time': '13:00', 'temp': 27},
    {'time': '14:00', 'temp': 26},
    {'time': '15:00', 'temp': 25},
  ];

  final List<Map<String, dynamic>> _daily = const [
    {
      'day': 'Friday',
      'desc': 'Cloudy with rain',
      'temp': 18,
      'icon': Icons.cloud,
    },
    {'day': 'Saturday', 'desc': 'Sunny', 'temp': 28, 'icon': Icons.wb_sunny},
    {'day': 'Sunday', 'desc': 'Rain', 'temp': 22, 'icon': Icons.water_drop},
    {
      'day': 'Monday',
      'desc': 'Thunder',
      'temp': 17,
      'icon': Icons.thunderstorm,
    },
    {'day': 'Tuesday', 'desc': 'Snow', 'temp': 2, 'icon': Icons.ac_unit},
    {
      'day': 'Wednesday',
      'desc': 'Cloudy with rain',
      'temp': 19,
      'icon': Icons.cloud_queue,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchWeather(_searchController.text);
  }

  Future<void> _fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _weatherService.getWeatherByCity(city);
      setState(() {
        _weather = result;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _weather = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onSubmitted(String value) {
    if (value.trim().isEmpty) return;
    _fetchWeather(value.trim());
  }

  String _formatToday() {
    final now = DateTime.now();
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final weekday = weekdays[now.weekday - 1];
    final month = months[now.month - 1];
    return '$weekday, ${now.day} $month';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : _errorMessage != null
                      ? Text(_errorMessage!, textAlign: TextAlign.center)
                      : _weather == null
                      ? const Text('Weather data not available.')
                      : _buildMainCard(_weather!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onSubmitted: _onSubmitted,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search city (e.g. Denpasar)',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 0,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () => _onSubmitted(_searchController.text),
          style: IconButton.styleFrom(backgroundColor: const Color(0xFF303030)),
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  Widget _buildMainCard(Weather weather) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian atas: lokasi & tanggal
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    weather.cityName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('•', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    _formatToday(),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                child: Row(
                  children: [
                    // KIRI
                    Expanded(flex: 3, child: _buildLeftWeatherInfo(weather)),

                    // TENGAH (ikon awan petir)
                    Expanded(flex: 4, child: Center(child: _buildStormIcon())),

                    // KANAN (daftar hari)
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _buildDailyPanel(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Timeline jam di bawah
              _buildHourlyTimeline(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLeftWeatherInfo(Weather weather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Suhu besar
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weather.temperature.toStringAsFixed(0),
              style: const TextStyle(fontSize: 76, fontWeight: FontWeight.w300),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                '°C',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _titleFromDescription(weather.description),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wind',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  '${weather.windSpeed.toStringAsFixed(1)} m/s',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(width: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Humidity',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  '${weather.humidity}%',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String _titleFromDescription(String desc) {
    final lower = desc.toLowerCase();
    if (lower.contains('storm') || lower.contains('thunder')) {
      return 'Storm with Rain';
    } else if (lower.contains('rain')) {
      return 'Rainy';
    } else if (lower.contains('cloud')) {
      return 'Cloudy';
    } else if (lower.contains('clear')) {
      return 'Clear Sky';
    }
    return desc.isEmpty
        ? 'Weather Info'
        : desc[0].toUpperCase() + desc.substring(1);
  }

  Widget _buildStormIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 190,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            gradient: const LinearGradient(
              colors: [Color(0xFF4C4C4C), Color(0xFF2C2C2C)],
            ),
          ),
        ),
        Container(
          width: 180,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(45),
          ),
        ),
        Positioned(
          bottom: -8,
          child: Icon(Icons.bolt, size: 80, color: Colors.amber.shade400),
        ),
      ],
    );
  }

  Widget _buildDailyPanel() {
    return Container(
      width: 190,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _daily.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final bool isToday = index == 0;

          return Padding(
            padding: EdgeInsets.only(top: index == 0 ? 4 : 10, bottom: 6),
            child: Row(
              children: [
                Icon(
                  item['icon'] as IconData,
                  size: 18,
                  color: isToday ? Colors.amber : Colors.white70,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['day'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isToday
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      Text(
                        item['desc'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${item['temp']}°',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                    color: isToday ? Colors.amber : Colors.white,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHourlyTimeline() {
    const selectedIndex = 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: 70,
          child: Row(
            children: _hourlyTemps.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final bool isSelected = index == selectedIndex;

              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.amber.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(
                                color: Colors.amber.withOpacity(0.7),
                                width: 1,
                              )
                            : null,
                      ),
                      child: Text(
                        '${item['temp']}°',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected ? Colors.amber : Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['time'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
