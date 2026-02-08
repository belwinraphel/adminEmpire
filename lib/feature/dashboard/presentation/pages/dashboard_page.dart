 
import 'package:empire/core/utils/responsive_layout.dart';
import 'package:empire/feature/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/employee_attendance_chart.dart';
import '../widgets/employee_table.dart';
import '../widgets/metrics_card.dart';
import '../widgets/performance_chart.dart';
import '../widgets/sidebar.dart';
import '../widgets/profit_calendar.dart';

import '../widgets/add_product_view.dart'; // Import this

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final isDark =
            state is DashboardLoaded && state.themeMode == ThemeMode.dark;
        final bgColor = isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF7F9FC);

        return Scaffold(
          backgroundColor: bgColor,
          drawer: ResponsiveLayout.isDesktop(context)
              ? null
              : const Drawer(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  width: 130, // Allow sidebar width + margins
                  child: Sidebar(),
                ),
          appBar: ResponsiveLayout.isDesktop(context)
              ? null
              : AppBar(
                  backgroundColor: bgColor,
                  elevation: 0,
                  iconTheme: IconThemeData(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  title: Text(
                    'Ecommerce Admin',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          body: ResponsiveLayout(
            mobile: _buildContent(context, state, isMobile: true),
            tablet: _buildContent(context, state, isTablet: true),
            desktop: Row(
              children: [
                const Sidebar(),
                Expanded(child: _buildContent(context, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    DashboardState state, {
    bool isMobile = false,
    bool isTablet = false,
  }) {
    if (state is DashboardLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is DashboardError) {
      return Center(
        child: Text(state.message, style: const TextStyle(color: Colors.red)),
      );
    } else if (state is DashboardLoaded) {
      if (state.currentView == DashboardView.addProduct) {
        return const AddProductView();
      }
      return _buildOverview(context, state, isMobile, isTablet);
    }
    return const SizedBox();
  }

  Widget _buildOverview(
    BuildContext context,
    DashboardLoaded state,
    bool isMobile,
    bool isTablet,
  ) {
    final isDark = state.themeMode == ThemeMode.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          if (!isMobile && !isTablet) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard',
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(color: textColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Overview of your store\'s performance',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: subTextColor),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],

          // Metrics Section
          if (isMobile) ...[
            // Mobile: Vertical Stack of Cards
            Column(
              children: state.stats.map((stat) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    height: 140,
                    child: MetricsCard(
                      title: stat.label,
                      value: stat.value,
                      percentageChange: stat.percentageChange,
                      isPositive: stat.isPositiveTrend,
                      weatherCondition: state.weatherCondition,
                      isDark: isDark,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ProfitCalendar(isDark: isDark),
          ] else if (isTablet) ...[
            // Tablet: Horizontal List + Stacked Calendar
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: state.stats.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final stat = state.stats[index];
                  return SizedBox(
                    width: 240,
                    child: MetricsCard(
                      title: stat.label,
                      value: stat.value,
                      percentageChange: stat.percentageChange,
                      isPositive: stat.isPositiveTrend,
                      weatherCondition: state.weatherCondition,
                      isDark: isDark,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ProfitCalendar(isDark: isDark),
          ] else ...[
            // Desktop Row Layout (4:1 split)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.stats.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 20),
                      itemBuilder: (context, index) {
                        final stat = state.stats[index];
                        return SizedBox(
                          width: 240,
                          child: MetricsCard(
                            title: stat.label,
                            value: stat.value,
                            percentageChange: stat.percentageChange,
                            isPositive: stat.isPositiveTrend,
                            weatherCondition: state.weatherCondition,
                            isDark: isDark,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(flex: 1, child: ProfitCalendar(isDark: isDark)),
              ],
            ),
          ],

          const SizedBox(height: 32),

          // Charts Section
          if (isMobile || isTablet) ...[
            SizedBox(height: 300, child: PerformanceChart(isDark: isDark)),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: EmployeeAttendanceChart(isDark: isDark),
            ),
          ] else ...[
            SizedBox(
              height: 400,
              child: Row(
                children: [
                  Expanded(flex: 3, child: PerformanceChart(isDark: isDark)),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: EmployeeAttendanceChart(isDark: isDark),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Employee Table
          EmployeeTable(employees: state.employees, isDark: isDark),
        ],
      ),
    );
  }
}
