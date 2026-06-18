import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/ui/homepage.dart';
import 'package:weather_app/ui/widgets/constant.dart';
import 'package:intl/intl.dart';

class _GlassHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.22),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: Row(
            children: [
              /// Back Arrow
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 12),

              /// Title
              const Text(
                'Daily Weather Forecast',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final List dailyForecastWeather;
  final String location;

  const DetailPage({
    super.key,
    required this.dailyForecastWeather,
    required this.location,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    int safeIndex(int index) {
      final len = widget.dailyForecastWeather.length;
      if (len <= 0) return 0;
      return index.clamp(0, len - 1);
    }

    Map<String, dynamic> getForecastWeather(int index) {
      final weatherData = widget.dailyForecastWeather;
      if (weatherData.isEmpty) {
        return {
          "forecastDate": "",
          "weatherName": "",
          "minTemp": 0,
          "maxTemp": 0,
          "wind": 0,
          "humidity": 0,
          "rain": 0,
        };
      }

      final i = safeIndex(index);
      final dayObj = weatherData[i];

      dynamic dateRaw = dayObj["date"];
      DateTime? parsedDate;
      try {
        parsedDate = (dateRaw is String) ? DateTime.parse(dateRaw) : null;
      } catch (_) {}

      final forecastDate =
          parsedDate != null
              ? DateFormat('EEE · dd MMM').format(parsedDate)
              : "";

      int toInt(dynamic v) {
        if (v == null) return 0;
        if (v is int) return v;
        if (v is double) return v.round();
        if (v is String) {
          final d = double.tryParse(v);
          return d?.round() ?? 0;
        }
        return 0;
      }

      final day = dayObj["day"] ?? {};
      final condition = day["condition"] ?? {};

      final maxWindSpeed = toInt(day["maxwind_kph"]);
      final avgHumidity = toInt(day["avghumidity"]);
      final chanceOfRain = toInt(day["daily_chance_of_rain"]);
      final weatherName = (condition["text"] ?? "").toString();

      final minTemp = toInt(day["mintemp_c"]);
      final maxTemp = toInt(day["maxtemp_c"]);

      return {
        "forecastDate": forecastDate,
        "weatherName": weatherName,
        "minTemp": minTemp,
        "maxTemp": maxTemp,
        "wind": maxWindSpeed,
        "humidity": avgHumidity,
        "rain": chanceOfRain,
      };
    }

    final today = getForecastWeather(0);

    return Scaffold(
      body: Stack(
        children: [
          /// 🌌 Background Image
          Positioned.fill(
            child: Image.asset(
              'assests/dailyweatherbg.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          /// 🌫 Strong Gaussian Blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: Colors.black.withOpacity(0.15)),
            ),
          ),

          /// 🌤 Foreground Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  /// 🔙 Header with Back Button
                  _GlassHeader(),

                  const SizedBox(height: 16),

                  /// 🔝 Current Weather Card
                  _GlassCard(
                    height: 180,
                    child: Row(
                      children: [
                        /// Left Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.location,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                today["forecastDate"],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              const Spacer(),

                              /// Weather Metrics
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _Metric(
                                    icon: Icons.water_drop,
                                    label: 'Rain',
                                    value: '${today["rain"]}%',
                                  ),
                                  _Metric(
                                    icon: Icons.air,
                                    label: 'Wind',
                                    value: '${today["wind"]} km/h',
                                  ),
                                  _Metric(
                                    icon: Icons.opacity,
                                    label: 'Humidity',
                                    value: '${today["humidity"]}%',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        /// Temperature
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.08),
                              ),
                            ),
                            Text(
                              '${today["maxTemp"]}°C',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 📅 5-Day Forecast
                  Expanded(
                    child: ListView.separated(
                      itemCount: (widget.dailyForecastWeather.length - 1).clamp(
                        0,
                        5,
                      ),
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final forecast = getForecastWeather(index + 1);

                        return _GlassCard(
                          height: 84,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    forecast["forecastDate"],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    forecast["weatherName"],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.65),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                '${forecast["maxTemp"]}°C',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🧊 Glassmorphic Card
class _GlassCard extends StatelessWidget {
  final Widget child;
  final double height;

  const _GlassCard({required this.child, required this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: height,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// 🌧 Weather Metric Widget
class _Metric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _Metric({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.white.withOpacity(0.9)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
