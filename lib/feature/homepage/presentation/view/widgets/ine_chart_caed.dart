import 'package:empire/core/extension/responsive.dart';
import 'package:empire/feature/auth/presentation/widget/custum_card.dart';
import 'package:empire/feature/revenue/domain/entity/revenue_entity.dart';
import 'package:empire/feature/revenue/presentation/bloc/revenue_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineChartCard extends StatelessWidget {
  RevenueState state;
  LineChartCard({super.key, required this.state});
  final leftTitle = {
    0: '0',
    2000: '2K',
    4000: '4K',
    6000: '6K',
    8000: '8K',
    10000: '10K',
  };
  @override
  Widget build(BuildContext context) {
    final revenueData = state.revenueData;
    final maxX = (revenueData.length - 1).toDouble();
    final maxRevenue = revenueData
        .map((e) => e.revenue)
        .reduce((a, b) => a > b ? a : b);

    final interval = calculateAdaptiveInterval(maxRevenue);
    final maxY = roundMaxY(maxRevenue, interval);
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Steps Overview",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: Responsive.isMobile(context) ? 9 / 4 : 16 / 6,
            child: LineChart(
              LineChartData(
                lineTouchData: const LineTouchData(handleBuiltInTouches: true),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < revenueData.length) {
                          return SideTitleWidget(
                            space: 10,
                            meta: meta,
                            child: Text(
                              _formatDateForDisplay(
                                revenueData[value.toInt()].date,
                                state.period,
                              ),
                              style: TextStyle(
                                fontSize: Responsive.isMobile(context) ? 9 : 12,
                                color: Colors.grey[400],
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          formatAxisValue(value),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        );
                      },
                      showTitles: true,
                      interval: interval,
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    curveSmoothness: 0,
                    color: Theme.of(context).primaryColor,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                      show: true,
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                    ),
                    dotData: const FlDotData(show: false),
                    // spots: spots,
                    spots: revenueData
                        .asMap()
                        .entries
                        .map(
                          (entry) =>
                              FlSpot(entry.key.toDouble(), entry.value.revenue),
                        )
                        .toList(),
                  ),
                ],
                minX: 0,
                maxX: maxX,
                minY: 0,
                maxY: maxY,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculateAdaptiveInterval(double maxValue) {
    if (maxValue <= 10_000) {
      return 1_000; // 1K steps
    } else if (maxValue <= 100_000) {
      return 10_000; // 10K steps
    } else if (maxValue <= 500_000) {
      return 50_000; // 50K steps
    } else {
      return 100_000; // 100K steps
    }
  }

  double roundMaxY(double maxValue, double interval) {
    return (maxValue / interval).ceil() * interval;
  }

  String formatAxisValue(double value) {
    if (value >= 1_000_000) {
      return '${(value / 1_000_000).toStringAsFixed(1)}M';
    } else if (value >= 1_000) {
      return '${(value / 1_000).toInt()}K';
    }
    return value.toInt().toString();
  }

  String _getPeriodDisplayNameweb(RevenuePeriod period) {
    switch (period) {
      case RevenuePeriod.daily:
        return 'Daily';
      case RevenuePeriod.weekly:
        return 'Weekly';
      case RevenuePeriod.monthly:
        return 'Monthly';
    }
  }

  String _formatDateForDisplay(DateTime date, RevenuePeriod period) {
    switch (period) {
      case RevenuePeriod.daily:
        return DateFormat('E').format(date);
      case RevenuePeriod.weekly:
        return 'W${_getWeekNumber(date)}';
      case RevenuePeriod.monthly:
        return DateFormat('MMM').format(date);
    }
  }

  int _getWeekNumber(DateTime date) {
    final firstJan = DateTime(date.year, 1, 1);
    final daysDiff = date.difference(firstJan).inDays;
    return ((daysDiff + firstJan.weekday - 1) / 7).floor() + 1;
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
    return '\$${value.toStringAsFixed(0)}';
  }

  double _calculateMaxY(List<RevenueData> data) {
    if (data.isEmpty) return 10000;
    final maxRevenue = data
        .map((e) => e.revenue)
        .reduce((a, b) => a > b ? a : b);
    final maxY = (maxRevenue * 1.2).ceilToDouble();
    return maxY > 0 ? maxY : 10000;
  }

  double _calculateInterval(double maxRevenue) {
    if (maxRevenue <= 1000) return 200;
    if (maxRevenue <= 5000) return 1000;
    if (maxRevenue <= 10000) return 2000;
    if (maxRevenue <= 50000) return 5000;
    if (maxRevenue <= 100000) return 10000;
    if (maxRevenue <= 500000) return 50000;
    if (maxRevenue <= 1000000) return 100000;
    return 200000;
  }
}
