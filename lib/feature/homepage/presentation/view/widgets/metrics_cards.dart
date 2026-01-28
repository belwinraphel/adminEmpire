import 'package:empire/core/extension/responsive.dart';
import 'package:empire/feature/homepage/domain/entities/metric_entity.dart';
import 'package:empire/feature/homepage/presentation/bloc/metric_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class MetricsCards extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;

  const MetricsCards({
    super.key,
    this.isDesktop = false,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return _MetricsCardsContent(isDesktop: isDesktop);
  }
}

class _MetricsCardsContent extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;

  const _MetricsCardsContent({this.isDesktop = false, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MetricsBloc, MetricsState>(
      builder: (context, state) {
        return Column(
          children: [
            isDesktop
                ? _buildMetricsGridweb(state, context)
                : _buildMetricsGrid(state, context),
            // isDesktop
            //     ? _buildRealtimeToggleweb(context, state)
            //     : _buildMetricsGrid(state, context),
            // SizedBox(height: 2.h),
          ],
        );
      },
    );
  }

  Widget _buildRealtimeToggle(BuildContext context, MetricsState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Live Updates', style: Theme.of(context).textTheme.bodySmall),
        SizedBox(width: 2.w),
        Switch(
          value: state.isRealTime,
          onChanged: (value) {
            context.read<MetricsBloc>().add(MetricsRealTimeToggled(value));
          },
        ),
      ],
    );
  }

  Widget _buildRealtimeToggleweb(BuildContext context, MetricsState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Live Updates', style: Theme.of(context).textTheme.bodySmall),
        SizedBox(width: 2.w),
        Switch(
          value: state.isRealTime,
          onChanged: (value) {
            context.read<MetricsBloc>().add(MetricsRealTimeToggled(value));
          },
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(MetricsState state, BuildContext context) {
    if (state.isLoading) {
      return _buildLoadingGrid();
    } else if (state.error != null) {
      return _buildErrorState(state.error!, context);
    } else if (state.metricsData.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double childAspectRatio;

        if (constraints.maxWidth >= 1100) {
          crossAxisCount = 4;
          childAspectRatio = 1.5;
        } else if (constraints.maxWidth >= 650) {
          crossAxisCount = 3;
          childAspectRatio = 1.4;
        } else {
          crossAxisCount = 2;
          childAspectRatio = 1.3;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: state.metricsData.length,
          itemBuilder: (context, index) {
            final metric = state.metricsData[index];
            return _buildMetricCard(metric: metric);
          },
        );
      },
    );
  }

  Widget _buildMetricsGridweb(MetricsState state, BuildContext context) {
    if (state.isLoading) {
      return _buildLoadingWebGrid();
    } else if (state.error != null) {
      return _buildErrorState(state.error!, context);
    } else if (state.metricsData.isEmpty) {
      return _buildEmptyState();
    }

    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);

    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: !isDesktop ? 2 : 4,
        crossAxisSpacing: !isDesktop ? 12 : 20,
        mainAxisSpacing: 20,
        childAspectRatio: !isDesktop ? 1.2 : 120 / 100,
      ),
      itemCount: state.metricsData.length,
      itemBuilder: (context, index) {
        final metric = state.metricsData[index];
        final accentColor = Color(metric.color);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ───── HEADER (Title + Icon) ─────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    metric.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getIcon(metric.iconName),
                      color: accentColor,
                      size: 20,
                    ),
                  ),
                ],
              ),

              /// ───── VALUE ─────
              Text(
                metric.value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: MediaQuery.of(context).size.width * 0.01,
                  letterSpacing: -0.5,
                ),
              ),

              const Spacer(),

              /// ───── CHANGE ─────
              Wrap(
                children: [
                  Icon(
                    metric.isPositive
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    size: MediaQuery.of(context).size.width * 0.001,
                    color: metric.isPositive ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    metric.change,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.width * 0.007,
                      color: metric.isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'vs last period',
                    maxLines: 1,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: MediaQuery.of(context).size.width * 0.0089,
                      overflow: TextOverflow.clip,

                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 1.3,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _buildMetricCardShimmer();
      },
    );
  }

  Widget _buildLoadingWebGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 1.9,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _buildMetricWebCardShimmer();
      },
    );
  }

  Widget _buildErrorState(String error, BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.error_outline, size: 48, color: Colors.red),
        SizedBox(height: 2.h),
        Text(
          'Unable to Load Metrics',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          error,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.sp),
        ),
        SizedBox(height: 2.h),
        ElevatedButton(
          onPressed: () {
            context.read<MetricsBloc>().add(const MetricsDataRequested());
          },
          child: const Text('Retry'),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Icon(
          Icons.analytics_outlined,
          size: 48,
          color: Colors.grey.withOpacity(0.5),
        ),
        SizedBox(height: 2.h),
        Text(
          'No Metrics Data',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Metrics will appear here once you have data',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCardweb({required MetricsData metric}) {
    return RepaintBoundary(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      metric.title,
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Color(metric.color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIcon(metric.iconName),
                      color: Color(metric.color),
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 90),
              Text(
                metric.value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              Row(
                children: [
                  Text(
                    metric.change,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: metric.isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  Icon(
                    metric.isPositive ? Icons.trending_up : Icons.trending_down,
                    color: metric.isPositive ? Colors.green : Colors.red,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard({required MetricsData metric}) {
    return RepaintBoundary(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      metric.title,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Color(metric.color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIcon(metric.iconName),
                      color: Color(metric.color),
                      size: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                metric.value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              Row(
                children: [
                  Text(
                    metric.change,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: metric.isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  Icon(
                    metric.isPositive ? Icons.trending_up : Icons.trending_down,
                    color: metric.isPositive ? Colors.green : Colors.red,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricWebCardShimmer() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 2.w, bottom: 3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 10.w,
                  height: 1.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.circle, color: Colors.grey[400], size: 20),
                ),
              ],
            ),
            Container(
              width: 10.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: 10.w,
              height: 2.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCardShimmer() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 18.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.circle, color: Colors.grey[400], size: 20),
                ),
              ],
            ),
            Container(
              width: 20.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: 30.w,
              height: 2.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'attach_money':
        return Icons.attach_money_outlined;
      case 'shopping_bag':
        return Icons.shopping_bag_outlined;
      case 'people':
        return Icons.people_outline;
      case 'warning':
        return Icons.warning_amber_outlined;
      default:
        return Icons.help_outline;
    }
  }
}
