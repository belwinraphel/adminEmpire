import 'package:flutter/material.dart';

class QuickActionsSectionweb extends StatelessWidget {
  const QuickActionsSectionweb({super.key});

  final List<Map<String, dynamic>> quickActions = const [
    {
      "title": "Add Product",
      "icon": Icons.add_box_outlined,
      "color": Color(0xFF059669),
      "route": "/admin-product-management",
    },
    {
      "title": "Manage Orders",
      "icon": Icons.list_alt_outlined,
      "color": Color(0xFF2563EB),
      "route": "/order-history",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),

        ...quickActions.map(
          (action) => _menuItem(
            context: context,
            title: action['title'],
            icon: action['icon'],
            color: action['color'],
            route: action['route'],
          ),
        ),
      ],
    );
  }

  Widget _menuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.pushNamed(context, route),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Card(
          elevation: 9,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.surface,
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                /// Icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),

                const SizedBox(width: 14),

                /// Title
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                /// Arrow (menu affordance)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
