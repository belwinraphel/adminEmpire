import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_state.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with TickerProviderStateMixin {
  late AnimationController _curveController;
  late Animation<double> _curveAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Selected Item Index
  // 0: Overview, 1: Add Product, 2: Calendar, 3: Analytics, 4: User, 5: Notif, 6: Video, 7: Settings
  int _selectedIndex = 0;
  double _currentCutoutY = 192.0; // Default to Overview position

  // Layout Constants
  static const double topPadding = 32;
  static const double logoHeight = 40;
  static const double logoGap = 32;
  static const double gap = 16;

  // Key positions (Centers)
  // Overview: 32 + 40 + 32 + 48 + 16 + (48/2) = 192
  // Add: 192 + 24 + 16 + 24 = 256
  // Calendar: 256 + 24 + 16 + 24 + 16 = 336 (Corrected gap calculation)
  // Analytics: 336 + 48 + 16 = 400
  // User: 400 + 48 + 16 = 464
  // Notif: 464 + 48 + 16 = 528
  // Video: 528 + 48 + 16 = 592
  // Settings: 592 + 48 + 16 = 656

  final List<double> _yPositions = [
    192.0, // Overview
    256.0, // Add Product
    336.0, // Calendar
    400.0, // Analytics
    464.0, // User
    528.0, // Notification
    592.0, // Video
    656.0, // Settings
  ];

  @override
  void initState() {
    super.initState();
    // Pulse Animation for the active button
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Curve Animation
    _curveController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _curveAnimation = Tween<double>(begin: _yPositions[0], end: _yPositions[0])
        .animate(
          CurvedAnimation(
            parent: _curveController,
            curve: Curves.easeInOutBack,
          ),
        );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _curveController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
      _curveAnimation =
          Tween<double>(
            begin: _currentCutoutY,
            end: _yPositions[index],
          ).animate(
            CurvedAnimation(
              parent: _curveController,
              curve: Curves.easeInOutBack,
            ),
          );
      _currentCutoutY = _yPositions[index];
    });

    _curveController.forward(from: 0.0);

    // Trigger Business Logic
    if (index == 0) {
      context.read<DashboardBloc>().add(
        const DashboardViewChanged(DashboardView.overview),
      );
    } else if (index == 1) {
      context.read<DashboardBloc>().add(
        const DashboardViewChanged(DashboardView.addProduct),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curveAnimation,
      builder: (context, child) {
        return Container(
          width: 90,
          margin: const EdgeInsets.all(16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Custom Shape Background
              Positioned.fill(
                child: CustomPaint(
                  painter: _SidebarPainter(
                    cutoutCenterY: _curveAnimation.value,
                    cutoutRadius: 38,
                    color: const Color(0xFF1E1E24),
                  ),
                ),
              ),

              // 2. Items Column
              Column(
                children: [
                  const SizedBox(height: topPadding),
                  // Logo
                  Container(
                    width: logoHeight,
                    height: logoHeight,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2C2C2C),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.local_hospital_rounded,
                        color: Color(0xFFFFCDD2),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: logoGap),

                  // Menu Icon (Static)
                  const _SidebarIcon(
                    icon: Icons.menu,
                    isSelected: false,
                    color: Colors.white54,
                  ),
                  const SizedBox(height: gap),

                  // 0. Overview
                  _buildAnimatedItem(0, Icons.grid_view),
                  const SizedBox(height: gap),

                  // 1. Add Product
                  _buildAnimatedItem(1, Icons.add, isSpecial: true),
                  const SizedBox(
                    height: gap * 2,
                  ), // Extra gap after Add Product is implicitly handled by layout, but strictly speaking between add and calendar was a larger gap in previous layout to accommodate the fixed cutout.
                  // Wait, if the cutout moves, the gap structure should be uniform OR we accept that the items are spaced evenly and the cutout moves.
                  // The previous layout had "gap * 2" after Add Product.
                  // If I keep uniform gaps, the Y positions change.
                  // Let's keep the gap * 2 for visual consistency with previous design,
                  // forcing the "Calendar" down. The Y position for calendar reflects this.
                  // 256 (Add center) + 24 (half) = 280.
                  // Previous: 280 + 32 (gap*2) = 312 top. + 24 = 336 center. Correct.

                  // 2. Calendar
                  _buildAnimatedItem(2, Icons.calendar_today_outlined),
                  const SizedBox(height: gap),

                  // 3. Analytics
                  _buildAnimatedItem(3, Icons.analytics_outlined),
                  const SizedBox(height: gap),

                  // 4. User
                  _buildAnimatedItem(4, Icons.person_outline),
                  const SizedBox(height: gap),

                  // 5. Notifications
                  _buildAnimatedItem(5, Icons.notifications_none_outlined),
                  const SizedBox(height: gap),

                  // 6. Video
                  _buildAnimatedItem(6, Icons.videocam_outlined),
                  const SizedBox(height: gap),

                  // 7. Settings
                  _buildAnimatedItem(7, Icons.hexagon_outlined),

                  const Spacer(),

                  // Profile
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white12, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://storage.googleapis.com/cms-storage-bucket/a9d6ce81aee44ae45bb6.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Icon(
                    Icons.logout_outlined,
                    color: Colors.white54,
                    size: 20,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedItem(
    int index,
    IconData icon, {
    bool isSpecial = false,
  }) {
    final isSelected = _selectedIndex == index;

    final bgDecoration = isSelected
        ? BoxDecoration(
            color: isSpecial ? const Color(0xFFFFCDD2) : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: isSpecial
                    ? const Color(0xFFFFCDD2).withOpacity(0.5)
                    : Colors.white.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          )
        : null;

    final iconColor = isSelected
        ? (isSpecial ? const Color(0xFFD32F2F) : Colors.black)
        : Colors.white54;

    final widget = GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: 48,
        height: 48,
        decoration: bgDecoration,
        child: Icon(
          isSpecial && !isSelected
              ? Icons.add
              : (isSpecial && isSelected ? Icons.close : icon),
          color: iconColor,
          size: 24,
        ),
      ),
    );

    if (isSelected) {
      return ScaleTransition(scale: _pulseAnimation, child: widget);
    }
    return widget;
  }
}

class _SidebarPainter extends CustomPainter {
  final double cutoutCenterY;
  final double cutoutRadius;
  final Color color;

  _SidebarPainter({
    required this.cutoutCenterY,
    required this.cutoutRadius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    const double radius = 32.0;

    // Start top left
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    // Draw down to cutout start
    final cutoutTop = cutoutCenterY - cutoutRadius;
    final cutoutBottom = cutoutCenterY + cutoutRadius;

    path.lineTo(size.width, cutoutTop - 10); // Smooth entry

    // Draw the cutout (Concave Bezier)
    // Control point 1 pulls inward
    path.cubicTo(
      size.width,
      cutoutTop + 10, // Control point top
      size.width - (cutoutRadius * 0.8),
      cutoutTop + 10,
      size.width - (cutoutRadius * 0.8),
      cutoutCenterY,
    );
    path.cubicTo(
      size.width - (cutoutRadius * 0.8),
      cutoutBottom - 10,
      size.width,
      cutoutBottom - 10, // Control point bottom
      size.width,
      cutoutBottom + 10,
    );

    // Continue down
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.close();

    // Shadow
    canvas.drawShadow(path, Colors.black, 4, true);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SidebarIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final Color? color;

  const _SidebarIcon({required this.icon, this.isSelected = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      child: Center(
        child: Icon(
          icon,
          color: color ?? (isSelected ? Colors.black : Colors.white54),
          size: 24,
        ),
      ),
    );
  }
}
