import 'package:flutter/material.dart';
import '../../../../core/services/weather_service.dart';
import '../widgets/weather_animations.dart';

class MetricsCard extends StatelessWidget {
  final String title;
  final String value;
  final double percentageChange;
  final bool isPositive;
  final WeatherCondition weatherCondition;
  final bool isDark;

  const MetricsCard({
    super.key,
    required this.title,
    required this.value,
    required this.percentageChange,
    required this.isPositive,
    required this.weatherCondition,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? const Color(0xFF1E1E24) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2C2C2C);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.grey.withOpacity(0.1),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background Animation passed from parent
            Positioned.fill(
              child: WeatherAnimationWrapper(condition: weatherCondition),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textColor,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                              color: isDark
                                  ? Colors.black54
                                  : Colors
                                        .transparent, // Only shadow on dark? OR subtle shadow
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 28,
                      color: textColor,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                          color: isDark ? Colors.black54 : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        color: isPositive
                            ? const Color(0xFF00C853)
                            : const Color(0xFFCF6679),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${isPositive ? '+' : ''}${percentageChange}% from last quarter',
                        style: TextStyle(
                          color: isPositive
                              ? const Color(0xFF00C853)
                              : const Color(0xFFCF6679),
                          fontSize: 12,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                              color: isDark
                                  ? Colors.black54
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
