import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EmployeeAttendanceChart extends StatelessWidget {
  final bool isDark;
  const EmployeeAttendanceChart({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? const Color(0xFF1E1E24) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey : Colors.grey;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.grey.withOpacity(0.1);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Statistics',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: textColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'This Month',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: textColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 60, // Keep layout
                          sections: [
                            PieChartSectionData(
                              color: const Color(0xFF6C63FF),
                              value: 70,
                              radius: 15,
                              showTitle: false,
                            ), // Completed
                            PieChartSectionData(
                              color: const Color(0xFF00C853),
                              value: 15,
                              radius: 15,
                              showTitle: false,
                            ), // Pending
                            PieChartSectionData(
                              color: const Color(0xFFCF6679),
                              value: 5,
                              radius: 15,
                              showTitle: false,
                            ), // Cancelled
                            PieChartSectionData(
                              color: const Color(0xFFFFD600),
                              value: 10,
                              radius: 15,
                              showTitle: false,
                            ), // Processing
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '24,500', // Total Orders
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                          ),
                          Text(
                            'Total Orders',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: subTextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LegendItem(
                        color: const Color(0xFF6C63FF),
                        label: 'Completed',
                        value: '18,500',
                        textColor: textColor,
                      ),
                      const SizedBox(height: 12),
                      _LegendItem(
                        color: const Color(0xFF00C853),
                        label: 'Pending',
                        value: '4,000',
                        textColor: textColor,
                      ),
                      const SizedBox(height: 12),
                      _LegendItem(
                        color: const Color(0xFFFFD600),
                        label: 'Processing',
                        value: '1,500',
                        textColor: textColor,
                      ),
                      const SizedBox(height: 12),
                      _LegendItem(
                        color: const Color(0xFFCF6679),
                        label: 'Cancelled',
                        value: '500',
                        textColor: textColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.withOpacity(0.2),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'View Full Details',
                style: TextStyle(color: textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final Color textColor;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
