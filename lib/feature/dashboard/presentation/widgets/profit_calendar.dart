import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfitCalendar extends StatefulWidget {
  final bool isDark;
  const ProfitCalendar({super.key, this.isDark = false});

  @override
  State<ProfitCalendar> createState() => _ProfitCalendarState();
}

class _ProfitCalendarState extends State<ProfitCalendar> {
  // Mock data for profit
  final Map<int, double> _dailyProfitValues = {
    6: 1200,
    9: 800,
    15: 2100,
    20: 3000,
    27: 1500,
    19: 1000, // Added mock data
  };

  // Range definition
  final int _startDay = 1;
  final int _currentDay = 20; // Assuming today is the 20th

  String get _totalProfit {
    double total = 0;
    _dailyProfitValues.forEach((day, profit) {
      if (day >= _startDay && day <= _currentDay) {
        total += profit;
      }
    });
    return '\$${(total / 1000).toStringAsFixed(1)}k';
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDark ? const Color(0xFF1E1E24) : Colors.white;
    final textColor = widget.isDark ? Colors.white : Colors.black87;
    final subTextColor = widget.isDark ? Colors.grey : Colors.black54;

    return Container(
      padding: const EdgeInsets.all(12), // Reduced padding (24 -> 12)
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: widget.isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wrap content
        children: [
          // Header with Total Profit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'May 2020',
                    style: GoogleFonts.poppins(
                      fontSize: 16, // Reduced (20 -> 16)
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2), // Reduced (4 -> 2)
                  Row(
                    children: [
                      const Icon(
                        Icons.show_chart,
                        size: 14, // Reduced (16 -> 14)
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Total Profit: $_totalProfit',
                        style: GoogleFonts.poppins(
                          fontSize: 12, // Reduced (14 -> 12)
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    iconSize: 20, // Reduced icon size
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(Icons.chevron_left, color: subTextColor),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: widget.isDark
                          ? Colors.white.withOpacity(0.1)
                          : const Color(0xFF1E1E2D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      iconSize: 20, // Reduced icon size
                      padding: const EdgeInsets.all(4), // Reduced padding
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12), // Reduced (24 -> 12)
          // Days Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _WeekdayText('Mon', isDark: widget.isDark),
              _WeekdayText('Tue', isDark: widget.isDark),
              _WeekdayText('Wed', isDark: widget.isDark),
              _WeekdayText('Thu', isDark: widget.isDark),
              _WeekdayText('Fri', isDark: widget.isDark),
              _WeekdayText('Sat', isDark: widget.isDark),
              _WeekdayText('Sun', isDark: widget.isDark),
            ],
          ),
          const SizedBox(height: 8), // Reduced (16 -> 8)
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Column(
      children: [
        _buildRow(['', '', '', '', '1', '2', '3']),
        const SizedBox(height: 6), // Reduced (12 -> 6)
        _buildRow(['4', '5', '6', '7', '8', '9', '10']),
        const SizedBox(height: 6),
        _buildRow(['11', '12', '13', '14', '15', '16', '17']),
        const SizedBox(height: 6),
        _buildRow(['18', '19', '20', '21', '22', '23', '24']),
        const SizedBox(height: 6),
        _buildRow(['25', '26', '27', '28', '29', '30', '31']),
      ],
    );
  }

  Widget _buildRow(List<String> days) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: days.map((day) {
        if (day.isEmpty) return const SizedBox(width: 40);
        final dayNum = int.tryParse(day);
        if (dayNum == null) return const SizedBox(width: 40);

        // Range Logic
        final bool isStart = dayNum == _startDay;
        final bool isEnd = dayNum == _currentDay;
        final bool inRange = dayNum >= _startDay && dayNum <= _currentDay;

        // Visuals
        Color? bgColor;
        if (inRange) {
          bgColor = Colors.deepOrange.withOpacity(0.1);
        }

        BorderRadius? borderRadius;
        if (isStart) {
          borderRadius = const BorderRadius.horizontal(
            left: Radius.circular(12), // Reduced radius
          );
        } else if (isEnd) {
          borderRadius = const BorderRadius.horizontal(
            right: Radius.circular(12),
          );
        } else if (!inRange) {
          borderRadius = BorderRadius.circular(12);
        }

        final textColor = (isStart || isEnd)
            ? Colors.white
            : (widget.isDark ? Colors.white : Colors.black87);

        return Expanded(
          child: Container(
            height: 24, // Reduced Height (40 -> 24)
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: borderRadius,
            ),
            alignment: Alignment.center,
            child: Container(
              width: 22, // Reduced size (32 -> 22)
              height: 22, // Reduced size (32 -> 22)
              alignment: Alignment.center,
              decoration: (isStart || isEnd)
                  ? const BoxDecoration(
                      color: Colors.deepOrange,
                      shape: BoxShape.circle,
                    )
                  : null,
              child: Text(
                day,
                style: GoogleFonts.poppins(
                  fontSize: 10, // Reduced Font Size (14 -> 10)
                  color: textColor,
                  fontWeight: (isStart || isEnd)
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _WeekdayText extends StatelessWidget {
  final String text;
  final bool isDark;

  const _WeekdayText(this.text, {this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 10, // Reduced Font Size (12 -> 10)
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      ),
    );
  }
}
