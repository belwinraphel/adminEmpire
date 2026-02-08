import 'package:empire/feature/homepage/domain/entities/metric_entity.dart';
import 'package:empire/feature/homepage/presentation/bloc/metric_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class MetricsCards extends StatelessWidget {
  const MetricsCards({
    super.key,
    // These flags are now optional/ignored as the widget is internally responsive
    bool isDesktop = false,
    bool isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return const _MetricsCardsContent();
  }
}

class _MetricsCardsContent extends StatelessWidget {
  const _MetricsCardsContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MetricsBloc, MetricsState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildMetricsGrid(state, context),
            // Realtime toggle can be uncommented/re-enabled here if needed
            // _buildRealtimeToggle(context, state),
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
        double gridSpacing;

        if (constraints.maxWidth >= 1400) {
          // Large screens
          crossAxisCount = 4;
          childAspectRatio = 2.4; // Significantly increased (was 1.8)
          gridSpacing = 20;
        } else if (constraints.maxWidth >= 1100) {
          // Desktop
          crossAxisCount = 4;
          childAspectRatio = 2.1; // Significantly increased (was 1.6)
          gridSpacing = 16;
        } else if (constraints.maxWidth >= 800) {
          // Tablet
          crossAxisCount = 3;
          childAspectRatio = 1.8; // Significantly increased (was 1.4)
          gridSpacing = 16;
        } else if (constraints.maxWidth >= 600) {
          // Small Tablet / Large Phone
          crossAxisCount = 2;
          childAspectRatio = 1.8; // Significantly increased (was 1.5)
          gridSpacing = 12;
        } else {
          // Mobile
          crossAxisCount = 2;
          childAspectRatio = 1.5; // Significantly increased (was 1.3)
          gridSpacing = 10;
        }

        // Adjust aspect ratio for very small screens if needed
        if (constraints.maxWidth < 400) {
          childAspectRatio = 1.3;
        }

        return GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: constraints.maxWidth < 600 ? 0 : 10,
          ),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: gridSpacing,
            mainAxisSpacing: gridSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: state.metricsData.length,
          itemBuilder: (context, index) {
            final metric = state.metricsData[index];
            return _buildUnifiedMetricCard(context, metric);
          },
        );
      },
    );
  }

  Widget _buildUnifiedMetricCard(BuildContext context, MetricsData metric) {
    final theme = Theme.of(context);
    final accentColor = Color(metric.color);

    return Container(
      padding: const EdgeInsets.all(
        16,
      ), // Use fixed padding instead of sp for better control
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.35)),
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
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Distribute space evenly
        children: [
          /// ───── HEADER (Title + Icon) ─────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  metric.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6), // Smaller padding
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIcon(metric.iconName),
                  color: accentColor,
                  size: 18, // Slightly smaller icon
                ),
              ),
            ],
          ),

          // No Spacer() here - let MainAxisAlignment handle it or use flexible if needed,
          // but tighter control is better for short cards.

          /// ───── VALUE ─────
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              metric.value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                height: 1.1, // Tighter line height
              ),
            ),
          ),

          /// ───── CHANGE ─────
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(
                metric.isPositive
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 14,
                color: metric.isPositive ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                metric.change,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: metric.isPositive ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'vs last period',
                maxLines: 1,
                style: theme.textTheme.labelSmall?.copyWith(
                  overflow: TextOverflow.clip,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Default to 2 for loading shim
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
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            Container(
              width: 20.w,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: 30.w,
              height: 15,
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
