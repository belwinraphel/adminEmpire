import 'package:empire/core/extension/responsive.dart';
import 'package:empire/feature/auth/presentation/widget/revenue_summary.dart';
import 'package:empire/feature/homepage/presentation/view/home_page.dart';
import 'package:empire/feature/homepage/presentation/view/widgets/menu.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatelessWidget {
  DashBoard({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Menu(scaffoldKey: _scaffoldKey),
                ),
              ),
            const Expanded(flex: 8, child: HomePage()),
            if (!Responsive.isMobile(context))
              const Expanded(flex: 4, child: ReveneSummaryCard()),
          ],
        ),
      ),
    );
  }
}
