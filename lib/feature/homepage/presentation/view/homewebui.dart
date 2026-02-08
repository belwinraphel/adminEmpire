import 'package:empire/feature/homepage/presentation/view/widgets/metrics_cards.dart';
import 'package:empire/feature/homepage/presentation/view/widgets/quick_section_web.dart';
import 'package:empire/feature/homepage/presentation/view/widgets/revenvue_web.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Homewebui extends StatefulWidget {
  final BoxConstraints constraints;
  const Homewebui({required this.constraints, super.key});

  @override
  State<Homewebui> createState() => _HomewebuiState();
}

class _HomewebuiState extends State<Homewebui> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MetricsCards(isDesktop: true),
          SizedBox(height: 2.h),
          _buildDashboardContent(context),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;

        if (screenWidth < 1400) {
          return const Column(
            children: [
              RevenueChartCardweb(),
              SizedBox(height: 20),
              QuickActionsSectionweb(),
            ],
          );
        } else {
          return const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: RevenueChartCardweb()),
              SizedBox(width: 20),
            ],
          );
        }
      },
    );
  }
}
