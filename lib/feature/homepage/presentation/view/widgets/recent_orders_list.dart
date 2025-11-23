import 'package:empire/core/utilis/app_theme.dart';
import 'package:empire/feature/homepage/presentation/view/widgets/custom_icon_widget.dart';
import 'package:empire/feature/homepage/presentation/view/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
 

 

class RecentOrdersList extends StatefulWidget {
  const RecentOrdersList({super.key});

  @override
  State<RecentOrdersList> createState() => _RecentOrdersListState();
}

class _RecentOrdersListState extends State<RecentOrdersList> {
  final List<Map<String, dynamic>> recentOrders = [
    {
      "id": "#ORD-2025-001",
      "customer": "Sarah Johnson",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "amount": "\$245.99",
      "status": "Processing",
      "statusColor": 0xFFD97706,
      "time": "2 hours ago",
      "items": 3,
    },
    {
      "id": "#ORD-2025-002",
      "customer": "Michael Chen",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "amount": "\$189.50",
      "status": "Shipped",
      "statusColor": 0xFF059669,
      "time": "4 hours ago",
      "items": 2,
    },
    {
      "id": "#ORD-2025-003",
      "customer": "Emma Rodriguez",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "amount": "\$567.25",
      "status": "Delivered",
      "statusColor": 0xFF2563EB,
      "time": "6 hours ago",
      "items": 5,
    },
    {
      "id": "#ORD-2025-004",
      "customer": "David Wilson",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "amount": "\$89.99",
      "status": "Pending",
      "statusColor": 0xFF64748B,
      "time": "8 hours ago",
      "items": 1,
    },
    {
      "id": "#ORD-2025-005",
      "customer": "Lisa Thompson",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "amount": "\$324.75",
      "status": "Cancelled",
      "statusColor": 0xFFDC2626,
      "time": "1 day ago",
      "items": 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Orders',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/order-history');
                },
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentOrders.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final order = recentOrders[index];
              return _buildOrderCard(order);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CustomImageWidget(
                    imageUrl: order["avatar"] as String,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order["customer"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        order["id"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      order["amount"] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      order["time"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'shopping_bag',
                      color: AppTheme.textSecondaryLight,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${order["items"]} items',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Color(order["statusColor"] as int)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order["status"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Color(order["statusColor"] as int),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: CustomIconWidget(
                    iconName: 'more_vert',
                    color: AppTheme.textSecondaryLight,
                    size: 20,
                  ),
                  onSelected: (String value) {
                    _handleOrderAction(value, order["id"] as String);
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'view',
                      child: Text('View Details'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'update',
                      child: Text('Update Status'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'contact',
                      child: Text('Contact Customer'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleOrderAction(String action, String orderId) {
    switch (action) {
      case 'view':
        Navigator.pushNamed(context, '/order-history');
        break;
      case 'update':
        _showUpdateStatusDialog(orderId);
        break;
      case 'contact':
        _showContactDialog(orderId);
        break;
    }
  }

  void _showUpdateStatusDialog(String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Order Status'),
          content: Text('Update status for order $orderId?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order status updated successfully')),
                );
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showContactDialog(String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Customer'),
          content: Text('Send message to customer for order $orderId?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Message sent to customer')),
                );
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }
}
