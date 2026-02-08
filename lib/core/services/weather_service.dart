import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum WeatherCondition { sun, snow, night, thunderRain, thunderStorm }

class WeatherService {
  static const MethodChannel _channel = MethodChannel(
    'com.hrmanager.admin/weather',
  );

  Future<WeatherCondition> getWeatherCondition() async {
    try {
      if (kIsWeb) {
        // Web fallback: Random mock
        return _mockRandomWeather();
      }

      final String? result = await _channel.invokeMethod('getWeather');
      return _parseCondition(result);
    } on PlatformException catch (e) {
      debugPrint(
        "Failed to get weather: '${e.message}'. Falling back to mock.",
      );
      return _mockRandomWeather();
    } on MissingPluginException {
      // Fallback for development/simulators without native rebuilds or web
      return _mockRandomWeather();
    }
  }

  WeatherCondition _parseCondition(String? condition) {
    switch (condition?.toLowerCase()) {
      case 'sun':
        return WeatherCondition.sun;
      case 'snow':
        return WeatherCondition.snow;
      case 'night':
        return WeatherCondition.night;
      case 'thunder_rain':
        return WeatherCondition.thunderRain;
      case 'thunder_storm':
        return WeatherCondition.thunderStorm;
      default:
        return WeatherCondition.sun;
    }
  }

  WeatherCondition _mockRandomWeather() {
    final conditions = WeatherCondition.values;
    return conditions[Random().nextInt(conditions.length)];
  }
}
