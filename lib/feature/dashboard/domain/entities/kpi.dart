import 'package:equatable/equatable.dart';

class KPI extends Equatable {
  final String label;
  final String value;
  final double percentageChange;
  final bool isPositiveTrend;

  const KPI({
    required this.label,
    required this.value,
    required this.percentageChange,
    required this.isPositiveTrend,
  });

  @override
  List<Object?> get props => [label, value, percentageChange, isPositiveTrend];
}
