import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_state.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final isDark =
            state is DashboardLoaded && state.themeMode == ThemeMode.dark;
        final backgroundColor = isDark
            ? const Color(0xFF1E1E24)
            : const Color(0xFFF5F5FA);
        final textColor = isDark ? Colors.white : const Color(0xFF2C2C2C);
        final subTextColor = isDark ? Colors.white70 : Colors.grey;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            if (!isDesktop) {
              // Mobile/Tablet Layout (Column)
              return SingleChildScrollView(
                child: Container(
                  color: backgroundColor,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildLeftPanel(textColor, subTextColor, isDark),
                      const SizedBox(height: 32),
                      _buildRightPanel(textColor, subTextColor, isDark),
                    ],
                  ),
                ),
              );
            }

            // Desktop Layout (Row)
            return Container(
              color: backgroundColor,
              padding: const EdgeInsets.all(32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildLeftPanel(textColor, subTextColor, isDark),
                  ),
                  const SizedBox(width: 48),
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      child: _buildRightPanel(textColor, subTextColor, isDark),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLeftPanel(Color textColor, Color subTextColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Category',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select category',
          style: TextStyle(color: subTextColor, fontSize: 14),
        ),
        const SizedBox(height: 32),
        // On mobile, we might want a limited height or full height?
        // GridView inside Column needs shrinkWrap or fixed height.
        // On desktop it was Expanded.
        // Let's use specific constraints or shrinkWrap.
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
          children: [
            _OptionCard(
              imagePath: 'assets/images/tshirt.png',
              label: 'Apparels',
              isSelected: true,
              onTap: () {},
              isDark: isDark,
            ),
            _OptionCard(
              imagePath: 'assets/images/sneaker.png',
              label: 'Sneakers',
              onTap: () {},
              isDark: isDark,
            ),
            _OptionCard(
              imagePath: 'assets/images/watch.png',
              label: 'Watches',
              onTap: () {},
              isDark: isDark,
            ),
            _OptionCard(
              icon: Icons.backpack,
              label: 'Bags',
              onTap: () {},
              isDark: isDark,
            ),
            _OptionCard(
              icon: Icons.check_circle_outline,
              label: 'Accessories',
              onTap: () {},
              isDark: isDark,
            ),
            _OptionCard(
              icon: Icons.sports_basketball,
              label: 'Sports',
              onTap: () {},
              isDark: isDark,
            ),
            _OptionCard(
              icon: Icons.diamond_outlined,
              label: 'Jewelry',
              onTap: () {},
              isDark: isDark,
            ),
            _OptionCard(
              icon: Icons.laptop_mac,
              label: 'Electronics',
              onTap: () {},
              isDark: isDark,
            ),
            _OptionCard(
              icon: Icons.add,
              label: 'More',
              onTap: () {},
              isDark: isDark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRightPanel(Color textColor, Color subTextColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Related Brands',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select brands associated with this category.',
          style: TextStyle(color: subTextColor, fontSize: 13),
        ),
        const SizedBox(height: 24),

        // Chips Row - Might need to be adaptable on mobile?
        // Fixed height 180 is fine, but width might be issue.
        // Using Flexible/Expanded within Row is fine.
        SizedBox(
          height: 180,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Col 1
              Expanded(
                child: Column(
                  children: [
                    _ColorfulChip(
                      icon: Icons.verified,
                      label: 'Nike',
                      color: const Color(0xFFFFF3E0),
                      iconColor: Colors.black87,
                      height: 80,
                    ),
                    const SizedBox(height: 16),
                    _ColorfulChip(
                      icon: Icons.waves,
                      label: 'Adidas',
                      color: const Color(0xFFE0F7FA),
                      iconColor: Colors.black87,
                      height: 80,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Col 2
              Expanded(
                flex: 1,
                child: Container(
                  height: 176,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFCDD2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star, color: Color(0xFFD32F2F)),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Add Feature',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black, // Always black as bg is pink
                        ),
                      ),
                      Text(
                        'Highlight Product',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Col 3
              Expanded(
                child: Column(
                  children: [
                    _ColorfulChip(
                      icon: Icons.spa,
                      label: 'Puma',
                      color: const Color(0xFFF3E5F5),
                      iconColor: Colors.black87,
                      height: 60,
                      isWide: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _ColorfulChip(
                            icon: Icons.check,
                            label: 'Reebok',
                            color: Colors.white,
                            iconColor: Colors.black87,
                            height: 80,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _ColorfulChip(
                            icon: Icons.circle,
                            label: 'NB',
                            color: const Color(0xFFFFCDD2),
                            iconColor: Colors.black87,
                            height: 80,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        // Wide Chips Row
        Row(
          children: [
            Expanded(
              child: _ColorfulChip(
                icon: Icons.local_offer,
                label: 'Offers',
                color: const Color(0xFFF3E5F5),
                iconColor: Colors.black87,
                height: 60,
                isWide: true,
                isCentered: false,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ColorfulChip(
                icon: null,
                label: 'Discount',
                color: const Color(0xFFEEEEEE),
                iconColor: Colors.transparent,
                height: 60,
                isWide: true,
                isCentered: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ColorfulChip(
                icon: null,
                label: 'Cupon',
                color: const Color(0xFFFFF3E0),
                iconColor: Colors.transparent,
                height: 60,
                isWide: true,
                isCentered: true,
              ),
            ),
          ],
        ),

        const SizedBox(height: 48),

        Text(
          'Products',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your products are listed here.',
          style: TextStyle(color: subTextColor, fontSize: 13),
        ),
        const SizedBox(height: 24),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 0.75,
          children: [
            _DetailCard(
              name: 'Nike Air Max',
              location: 'Warehouse A',
              role: 'In Stock',
              roleSub: '245 Units',
              date: '14 Aug 2023',
              time: '01:00 PM',
              isDark: isDark,
            ),
            _DetailCard(
              name: 'Adidas Ultraboost',
              location: 'Warehouse B',
              role: 'Low Stock',
              roleSub: '12 Units',
              date: '21 Aug 2023',
              time: '10:30 PM',
              isDark: isDark,
            ),
            _DetailCard(
              name: 'Puma RS-X',
              location: 'Warehouse A',
              role: 'In Stock',
              roleSub: '85 Units',
              date: '22 Aug 2023',
              time: '09:15 AM',
              isDark: isDark,
            ),
            _DetailCard(
              name: 'New Balance 550',
              location: 'Warehouse C',
              role: 'Out of Stock',
              roleSub: '0 Units',
              date: '23 Aug 2023',
              time: '03:45 PM',
              isDark: isDark,
            ),
          ],
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isDark;

  const _OptionCard({
    this.icon,
    this.imagePath,
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    // Gradients
    final selectedGradient = const LinearGradient(
      colors: [Color(0xFF7B61FF), Color(0xFF6C63FF)], // Vibrant Purple
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final unselectedGradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF2C2C2C), Color(0xFF1E1E24)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Colors.white, Color(0xFFF5F5FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    final borderColor = isDark
        ? Colors.white10
        : Colors.grey.withValues(alpha: 0.1);
    final defaultIconColor = isDark ? Colors.white54 : Colors.grey;
    final defaultTextColor = isDark ? Colors.white54 : Colors.grey;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: isSelected ? selectedGradient : unselectedGradient,
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? Border.all(color: Colors.transparent)
              : Border.all(color: borderColor),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              )
            else if (icon != null)
              Icon(
                icon,
                color: isSelected ? Colors.white : defaultIconColor,
                size: 32,
              ),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : defaultTextColor,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorfulChip extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color color;
  final Color iconColor;
  final double height;
  final bool isWide;
  final bool isCentered;

  const _ColorfulChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    required this.height,
    this.isWide = false,
    this.isCentered = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isWide && !isCentered
          ? Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: iconColor, size: 24),
                  const SizedBox(width: 12),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: iconColor, size: 24),
                  const SizedBox(height: 8),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String name;
  final String location;
  final String role;
  final String roleSub;
  final String date;
  final String time;
  final bool isDark;

  const _DetailCard({
    required this.name,
    required this.location,
    required this.role,
    required this.roleSub,
    required this.date,
    required this.time,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2C2C2C);
    final subTextColor = isDark
        ? Colors.white70
        : Colors.black.withOpacity(0.5);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(
                  'https://storage.googleapis.com/cms-storage-bucket/a9d6ce81aee44ae45bb6.png',
                ),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                location,
                style: TextStyle(fontSize: 12, color: subTextColor),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFFFF0F3,
                  ), // Keep pink for role as it contrasts well with dark grey too? Or maybe darker pink?
                  // Let's keep it 0xFFFFF0F3 but if it looks bad on dark, we might need a darker pink bg.
                  // For now, let's assume it works or just leave it.
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      role,
                      style: const TextStyle(
                        color: Color(0xFF2C2C2C),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      roleSub,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Date & Time Boxes
          Row(
            children: [
              Expanded(
                child: _DateBox(label: 'Date', value: date, isDark: isDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DateBox(label: 'Time', value: time, isDark: isDark),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _BlackButton(Icons.location_on, isDark: isDark),
              const SizedBox(width: 12),
              _BlackButton(Icons.calendar_month, isDark: isDark),
              const SizedBox(width: 12),
              _BlackButton(Icons.refresh, isDark: isDark),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _DateBox({
    required this.label,
    required this.value,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : const Color(0xFFF6F8FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4DB6AC), // Teal color
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF2C2C2C),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _BlackButton extends StatelessWidget {
  final IconData icon;
  final bool isDark;

  const _BlackButton(this.icon, {this.isDark = false});

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? Colors.white : const Color(0xFF1E1E24);
    final iconColor = isDark ? Colors.black : Colors.white;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Center(child: Icon(icon, color: iconColor, size: 20)),
    );
  }
}
