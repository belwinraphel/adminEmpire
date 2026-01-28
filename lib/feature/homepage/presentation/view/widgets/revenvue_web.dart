import 'package:empire/core/utilis/color.dart';
import 'package:empire/feature/homepage/presentation/view/widgets/ine_chart_caed.dart';

import 'package:empire/feature/revenue/domain/entity/revenue_entity.dart';
import 'package:empire/feature/revenue/presentation/bloc/revenue_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class RevenueChartCardweb extends StatelessWidget {
  const RevenueChartCardweb({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    return const _RevenueChartCardContentweb();
  }
}

class _RevenueChartCardContentweb extends StatelessWidget {
  const _RevenueChartCardContentweb();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<RevenueBloc, RevenueState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///header --Revenue & week
                _buildHeaderWeb(context, state),
                SizedBox(height: 2.h),

                ///loading
                if (state.isLoading) ...[
                  SizedBox(height: 2.h),
                  const Center(child: CircularProgressIndicator()),
                ] else if (state.error != null) ...[
                  ///Error
                  SizedBox(height: 2.h),
                  _buildErrorStateweb(state.error!, context),
                ] else if (state.revenueData.isEmpty) ...[
                  ///Emty ui
                  SizedBox(height: 2.h),
                  _buildEmptyStateweb(context),
                ] else ...[
                  LineChartCard(state: state),

                  //  ui
                  // SizedBox(height: screenHeight * 0.50),
                  // SizedBox(
                  //   height: screenHeight * 0.50,
                  //   child: _buildRevenueChartWeb(state, context),
                  // ),
                ],
                // SizedBox(height: 1.h),
                // _buildRealtimeToggleweb(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderWeb(BuildContext context, RevenueState state) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// ---------------- LEFT : TITLE ----------------
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Analytics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Overview of sales performance',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),

        /// ---------------- RIGHT : FILTER ----------------
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              DropdownButtonHideUnderline(
                child: DropdownButton<RevenuePeriod>(
                  value: state.period,
                  isDense: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: RevenuePeriod.values.map((period) {
                    return DropdownMenuItem<RevenuePeriod>(
                      value: period,
                      child: Text(
                        _getPeriodDisplayNameweb(period),
                        style: theme.textTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<RevenueBloc>().add(
                        RevenuePeriodChanged(value),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRealtimeToggleweb(BuildContext context, RevenueState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Live Updates', style: Theme.of(context).textTheme.bodySmall),
        SizedBox(width: 2.w),
        Switch(
          value: state.isRealTime,
          onChanged: (value) {
            context.read<RevenueBloc>().add(RevenueRealTimeToggled(value));
          },
        ),
      ],
    );
  }

  Widget _buildEmptyStateweb(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    final emptyHeight = isDesktop ? 200 : 25.h;

    return Column(
      children: [
        Container(
          height: emptyHeight.toDouble(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart_outlined,
                  size: isDesktop ? 64.0 : 48.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
                SizedBox(height: 2.h),
                Text(
                  'No Revenue Data',
                  style: TextStyle(
                    fontSize: isDesktop ? 18.sp : 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Revenue analytics will appear here once you start receiving orders',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isDesktop ? 10.sp : 12.sp,
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorStateweb(String error, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    final errorHeight = isDesktop ? 200 : 25.h;

    return Column(
      children: [
        Container(
          height: errorHeight.toDouble(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 2.h),
                Text(
                  'Unable to Load Data',
                  style: TextStyle(
                    fontSize: isDesktop ? 18.sp : 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: isDesktop ? 14.sp : 12.sp),
                ),
                SizedBox(height: 2.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<RevenueBloc>().add(
                      const RevenueDataRequested(),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.h),
        _buildEmptyStats(isDesktop),
      ],
    );
  }

  Widget _buildEmptyStats(bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItemweb(
          'Total Revenue',
          '\$0',
          '0%',
          true,
          isPlaceholder: true,
        ),
        _buildStatItemweb('Avg. Order', '\$0', '0%', true, isPlaceholder: true),
        _buildStatItemweb('Conversion', '0%', '0%', true, isPlaceholder: true),
      ],
    );
  }

  Widget _buildRevenueChartWeb(RevenueState state, BuildContext context) {
    final revenueData = state.revenueData;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: ColoRs.fieldcolor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue Overview',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),

          /// ✅ Same pattern as LineChartCard
          AspectRatio(
            aspectRatio: 16 / 6,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (revenueData.length - 1).toDouble(),
                minY: 0,
                maxY: _calculateMaxY(revenueData),

                /// ---------------- GRID ----------------
                gridData: const FlGridData(show: false),

                /// ---------------- BORDER ----------------
                borderData: FlBorderData(show: false),

                /// ---------------- TITLES ----------------
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < revenueData.length) {
                          return SideTitleWidget(
                            meta: meta,
                            space: 8,
                            child: Text(
                              _formatDateForDisplay(
                                revenueData[index].date,
                                state.period,
                              ),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: _calculateInterval(
                        state.summary?.totalRevenue ?? 0,
                      ),
                      getTitlesWidget: (value, meta) {
                        return Text(
                          _formatCurrency(value),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                /// ---------------- LINE ----------------
                lineBarsData: [
                  LineChartBarData(
                    spots: _buildRevenueSpots(revenueData),
                    isCurved: true,
                    curveSmoothness: 0.2,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    color: Theme.of(context).colorScheme.primary,

                    dotData: const FlDotData(show: false),

                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],

                /// ---------------- TOUCH ----------------
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        final index = spot.x.toInt();
                        final data = revenueData[index];
                        return LineTooltipItem(
                          '${_formatDateForDisplay(data.date, state.period)}\n'
                          '\$${data.revenue.toStringAsFixed(0)}\n'
                          '${data.orders} orders',
                          const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _buildRevenueSpots(List<RevenueData> data) {
    return data
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.revenue))
        .toList();
  }

  Widget _buildStatsWeb(
    RevenueSummary summary,
    bool isDesktop,
    BuildContext context,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: 260, // stable width (desktop friendly)
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _statTile(
            context,
            icon: Icons.payments_outlined,
            title: 'Total Revenue',
            value: _formatCurrency(summary.totalRevenue),
            change: summary.revenueChange,
          ),
          const SizedBox(height: 16),
          _statTile(
            context,
            icon: Icons.shopping_cart_outlined,
            title: 'Avg. Order',
            value: _formatCurrency(summary.averageOrderValue),
            change: summary.aovChange,
          ),
          const SizedBox(height: 16),
          _statTile(
            context,
            icon: Icons.trending_up_outlined,
            title: 'Conversion',
            value: '${summary.conversionRate.toStringAsFixed(1)}%',
            change: summary.conversionChange,
          ),
        ],
      ),
    );
  }

  Widget _statTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required double change,
  }) {
    final theme = Theme.of(context);
    final isPositive = change >= 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Icon Container
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 22, color: theme.colorScheme.primary),
        ),

        const SizedBox(width: 12),

        /// Text Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    isPositive
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    size: 16,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${change.toStringAsFixed(1)}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'vs last period',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItemweb(
    String label,
    String value,
    String change,
    bool isPositive, {
    bool isPlaceholder = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isPlaceholder ? Colors.grey.withOpacity(0.5) : null,
          ),
          textAlign: TextAlign.center, // Center on responsive rows
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isPlaceholder ? Colors.grey.withOpacity(0.5) : null,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.5.h),
        if (!isPlaceholder)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                change,
                style: TextStyle(
                  fontSize: 14,
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          )
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.remove, color: Colors.grey.withOpacity(0.5), size: 20),
              const SizedBox(width: 10),
              Text(
                change,
                style: TextStyle(
                  fontSize: 14,

                  color: Colors.grey.withOpacity(0.5),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
      ],
    );
  }

  // Helper Methods (unchanged, but added responsive tweaks where used)
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
