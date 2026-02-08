import 'package:equatable/equatable.dart';

class Climate extends Equatable {
  final double temperature;
  final double windSpeed;
  final double humidity;
  final String condition;
  final String videoUrl;

  const Climate({
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.condition,
    required this.videoUrl,
  });

  @override
  List<Object?> get props => [
    temperature,
    windSpeed,
    humidity,
    condition,
    videoUrl,
  ];
}
