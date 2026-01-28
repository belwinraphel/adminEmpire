import 'package:empire/core/di/service_locator.dart';
import 'package:empire/feature/revenue/domain/entity/revenue_entity.dart';

import 'package:empire/feature/revenue/presentation/bloc/revenue_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReveneSummaryCard extends StatelessWidget {
  const ReveneSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RevenueBloc>()..add(const RevenueDataRequested()),
      child: BlocBuilder<RevenueBloc, RevenueState>(
        builder: (context, state) {
          final summary = state.summary;
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return RevenueErrorCard(state: state);
          }
          if (state.revenueData.isEmpty) {
            return RevenueErrorCard(state: state);
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _analyticsBigCard(
                  context: context,
                  state: state,
                  summary: summary!,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _analyticsBigCard({
    required BuildContext context,
    required RevenueState state,
    required RevenueSummary summary,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              _analyticsHeader(context, state),

              const SizedBox(height: 32),

              /// VERTICAL STATS
              _statTile(
                context,
                icon: Icons.payments_outlined,
                title: 'Total Revenue',
                value: _formatCurrency(summary.totalRevenue).toString(),
                change: summary.revenueChange,
              ),

              const SizedBox(height: 24),

              _statTile(
                context,
                icon: Icons.shopping_cart_outlined,
                title: 'Avg. Order Value',
                value: _formatCurrency(summary.averageOrderValue).toString(),
                change: summary.aovChange,
              ),

              const SizedBox(height: 24),

              _statTile(
                context,
                icon: Icons.trending_up_outlined,
                title: 'Conversion Rate',
                value: '${summary.conversionRate.toStringAsFixed(1)}%',
                change: summary.conversionChange,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _analyticErrorCard({
    required BuildContext context,
    required RevenueState state,
    required RevenueSummary summary,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                _analyticsHeader(context, state),

                const SizedBox(height: 32),

                /// VERTICAL STATS
                _statTile(
                  context,
                  icon: Icons.payments_outlined,
                  title: 'Total Revenue',
                  value: _formatCurrency(summary.totalRevenue),
                  change: summary.revenueChange,
                ),

                const SizedBox(height: 24),

                _statTile(
                  context,
                  icon: Icons.shopping_cart_outlined,
                  title: 'Avg. Order Value',
                  value: _formatCurrency(summary.averageOrderValue),
                  change: summary.aovChange,
                ),

                const SizedBox(height: 24),

                _statTile(
                  context,
                  icon: Icons.trending_up_outlined,
                  title: 'Conversion Rate',
                  value: '${summary.conversionRate.toStringAsFixed(1)}%',
                  change: summary.conversionChange,
                ),

                const SizedBox(height: 32),

                /// (Future sections like charts)
                // RevenueLineChart(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _analyticsHeader(BuildContext context, RevenueState state) {
    final theme = Theme.of(context);

    return Wrap(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Analytics',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
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

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.4),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<RevenuePeriod>(
              value: state.period,
              isDense: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: RevenuePeriod.values.map((period) {
                return DropdownMenuItem(
                  value: period,
                  child: Text(
                    period.name.toUpperCase(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: MediaQuery.of(context).size.width * 0.008,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<RevenueBloc>().add(RevenuePeriodChanged(value));
                }
              },
            ),
          ),
        ),
      ],
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

  String _formatCurrency(double value) {
    if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
    return '\$${value.toStringAsFixed(0)}';
  }
}

class RevenueErrorCard extends StatelessWidget {
  final RevenueState state;

  const RevenueErrorCard({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.withOpacity(0.7),
                ),
                const SizedBox(height: 16),
                Text(
                  'Error Loading Revenue Data',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  state.error ?? 'An error occurred',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<RevenueBloc>().add(
                      const RevenueDataRequested(),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
