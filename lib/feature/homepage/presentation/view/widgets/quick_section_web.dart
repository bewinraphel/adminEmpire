import 'package:empire/core/utilis/app_theme.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/feature/homepage/presentation/view/widgets/custom_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class QuickActionsSectionweb extends StatelessWidget {
  const QuickActionsSectionweb({super.key});

  final List<Map<String, dynamic>> quickActions = const [
    {
      "title": "Add Product",
      "icon": "add_box",
      "color": 0xFF059669,
      "route": "/admin-product-management",
    },
    {
      "title": "Manage Orders",
      "icon": "list_alt",
      "color": 0xFF2563EB,
      "route": "/order-history",
    },
    {
      "title": "View Analytics",
      "icon": "analytics",
      "color": 0xFFD97706,
      "route": "/admin-product-management",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.20,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              itemCount: quickActions.length,
              itemBuilder: (context, index) {
                final action = quickActions[index];
                return _buildActionButtonweb(
                  context: context,
                  title: action["title"] as String,
                  iconName: action["icon"] as String,
                  color: Color(action["color"] as int),
                  route: action["route"] as String,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtonweb({
    required BuildContext context,
    required String title,
    required String iconName,
    required Color color,
    required String route,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: Colors.white,
                size: 49,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
