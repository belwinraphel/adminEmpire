import 'package:empire/core/extension/responsive.dart';
import 'package:empire/core/utils/app_theme.dart';
import 'package:empire/feature/homepage/presentation/bloc/metric_bloc.dart';
import 'package:empire/feature/homepage/presentation/view/homewebui.dart';
import 'package:empire/feature/homepage/presentation/view/widget.dart';
import 'package:empire/feature/homepage/presentation/view/widgets/metrics_cards.dart';
import 'package:empire/feature/homepage/presentation/view/widgets/quick_actions_section.dart';
import 'package:empire/feature/homepage/presentation/view/widgets/revenue_chart_card.dart';
import 'package:empire/feature/revenue/presentation/bloc/revenue_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override 
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _onRefresh() async {
    context.read<RevenueBloc>().add(const RevenueDataRequested());
    context.read<MetricsBloc>().add(const MetricsDataRequested());
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return Homewebui(constraints: constraints);
        },
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _onRefresh,
          color: AppTheme.darkTheme.colorScheme.primary,
          child: const _HomeMobileLayout(),
        ),
      ),
      bottomNavigationBar: BottomNavigationSection(context: context),
    );
  }
}

class _HomeMobileLayout extends StatelessWidget {
  const _HomeMobileLayout();

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.isMobile(context) ? 2.w : 4.w;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            const MetricsCards(isDesktop: false),
            SizedBox(height: 2.h),
            const RevenueChartCard(),
            SizedBox(height: 2.h),
            const QuickActionsSection(),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
