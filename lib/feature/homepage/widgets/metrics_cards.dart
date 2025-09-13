import 'package:empire/core/utilis/app_theme.dart';
import 'package:empire/feature/homepage/widgets/custom_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MetricsCards extends StatelessWidget {
  const MetricsCards({super.key});

  final List<Map<String, dynamic>> metricsData = const [
    {
      "title": "Total Sales",
      "value": "\$45,280",
      "change": "+12.5%",
      "isPositive": true,
      "icon": "attach_money",
      "color": 0xFF059669,
    },
    {
      "title": "Orders",
      "value": "1,247",
      "change": "+8.2%",
      "isPositive": true,
      "icon": "shopping_bag",
      "color": 0xFF2563EB,
    },
    {
      "title": "Customers",
      "value": "892",
      "change": "+15.3%",
      "isPositive": true,
      "icon": "people",
      "color": 0xFFD97706,
    },
    {
      "title": "Low Stock",
      "value": "23",
      "change": "-5.1%",
      "isPositive": false,
      "icon": "warning",
      "color": 0xFFDC2626,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 2.h,
          childAspectRatio: 1.3,
        ),
        itemCount: metricsData.length,
        itemBuilder: (context, index) {
          final metric = metricsData[index];
          return _buildMetricCard(
            title: metric["title"] as String,
            value: metric["value"] as String,
            change: metric["change"] as String,
            isPositive: metric["isPositive"] as bool,
            iconName: metric["icon"] as String,
            color: Color(metric["color"] as int),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String change,
    required bool isPositive,
    required String iconName,
    required Color color,
  }) {
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
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: color,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimaryLight,
              ),
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: isPositive ? 'trending_up' : 'trending_down',
                  color: isPositive
                      ? AppTheme.successLight
                      : AppTheme.errorLight,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  change,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isPositive
                        ? AppTheme.successLight
                        : AppTheme.errorLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
