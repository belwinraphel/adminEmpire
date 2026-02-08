import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ClimateService {
  static const MethodChannel _channel = MethodChannel(
    'com.hrmanager.admin/climate',
  );

  Future<Map<String, dynamic>> getClimateData() async {
    if (kIsWeb) {
      // Return mock data for Web
      return {
        "temperature": 28.0,
        "windSpeed": 12.5,
        "humidity": 65.0,
        "condition": "Sunny",
      };
    }
    try {
      final Map<Object?, Object?> result = await _channel.invokeMethod(
        'getClimateData',
      );
      // Convert Map<Object?, Object?> to Map<String, dynamic>
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print("Failed to get climate data: '${e.message}'.");
      return {};
    } catch (e) {
      // Catch MissingPluginException and others
      print("Error getting climate data: $e");
      return {};
    }
  }
}
