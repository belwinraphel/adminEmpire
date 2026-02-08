import '../../domain/entities/kpi.dart';

class KPIModel extends KPI {
  const KPIModel({
    required super.label,
    required super.value,
    required super.percentageChange,
    required super.isPositiveTrend,
  });

  factory KPIModel.fromJson(Map<String, dynamic> json) {
    return KPIModel(
      label: json['label'],
      value: json['value'],
      percentageChange: (json['percentageChange'] as num).toDouble(),
      isPositiveTrend: json['isPositiveTrend'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'percentageChange': percentageChange,
      'isPositiveTrend': isPositiveTrend,
    };
  }
}
