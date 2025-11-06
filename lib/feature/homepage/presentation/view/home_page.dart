import 'package:empire/core/utilis/app_theme.dart';
import 'package:empire/feature/homepage/widgets/custom_icon_widget.dart';
import 'package:empire/feature/homepage/widgets/low_stock_alerts.dart';
import 'package:empire/feature/homepage/widgets/metrics_cards.dart';
import 'package:empire/feature/homepage/widgets/revenue_chart_card.dart';
import 'package:empire/feature/homepage/widgets/top_products_section.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/quick_actions_section.dart';
import '../../widgets/recent_orders_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;
  String selectedDateRange = 'Last 7 days';
  // final List<String> dateRanges = [
  //   'Today',
  //   'Last 7 days',
  //   'Last 30 days',
  //   'Last 3 months',
  // ];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await _loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,

      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _onRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              _isLoading ? _buildLoadingSliver() : _buildDashboardContent(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      elevation: 0,
      backgroundColor: AppTheme.lightTheme.cardColor,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.primary,
                  AppTheme.lightTheme.colorScheme.primary.withValues(
                    alpha: 0.7,
                  ),
                ],
              ),
            ),
            child: Center(
              child: Text(
                'A',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Dashboard',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Welcome back, Administrator',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // actions: [
      //   Stack(
      //     children: [
      //       IconButton(
      //         onPressed: () {
      //           _showNotificationsDialog();
      //         },
      //         icon: const CustomIconWidget(
      //           iconName: 'notifications',
      //           color: AppTheme.textPrimaryLight,
      //           size: 24,
      //         ),
      //       ),
      //       Positioned(
      //         right: 8,
      //         top: 8,
      //         child: Container(
      //           width: 8,
      //           height: 8,
      //           decoration: const BoxDecoration(
      //             color: AppTheme.errorLight,
      //             shape: BoxShape.circle,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      //   PopupMenuButton<String>(
      //     icon: const CustomIconWidget(
      //       iconName: 'date_range',
      //       color: AppTheme.textPrimaryLight,
      //       size: 24,
      //     ),
      //     onSelected: (String value) {
      //       setState(() {
      //         selectedDateRange = value;
      //       });
      //       _loadDashboardData();
      //     },
      //     itemBuilder: (BuildContext context) => dateRanges.map((String range) {
      //       return PopupMenuItem<String>(
      //         value: range,
      //         child: Row(
      //           children: [
      //             CustomIconWidget(
      //               iconName: selectedDateRange == range
      //                   ? 'radio_button_checked'
      //                   : 'radio_button_unchecked',
      //               color: selectedDateRange == range
      //                   ? AppTheme.lightTheme.colorScheme.primary
      //                   : AppTheme.textSecondaryLight,
      //               size: 20,
      //             ),
      //             SizedBox(width: 2.w),
      //             Text(range),
      //           ],
      //         ),
      //       );
      //     }).toList(),
      //   ),
      //   SizedBox(width: 2.w),
      // ],
    );
  }

  Widget _buildLoadingSliver() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            SizedBox(height: 2.h),
            Text(
              'Loading dashboard data...',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return SliverList(
      delegate: SliverChildListDelegate([
        SizedBox(height: 1.h),
        const RevenueChartCard(),
        SizedBox(height: 2.h),
        const MetricsCards(),
        SizedBox(height: 2.h),
        const QuickActionsSection(),
        SizedBox(height: 1.h),
        const RecentOrdersList(),
        SizedBox(height: 1.h),
        const TopProductsSection(),
        SizedBox(height: 1.h),
        const LowStockAlerts(),
        SizedBox(height: 10.h),
      ]),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        boxShadow: const [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem('Dashboard', 'dashboard', true, '/admin-dashboard'),
            _buildNavItem(
              'Products',
              'inventory',
              false,
              '/admin-product-management',
            ),
            _buildNavItem('Orders', 'list_alt', false, '/order-history'),
            _buildNavItem('Customers', 'people', false, '/customer-home'),
            _buildNavItem('Analytics', 'analytics', false, '/admin-dashboard'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    String label,
    String iconName,
    bool isActive,
    String route,
  ) {
    return InkWell(
      onTap: () {
        if (!isActive) {
          Navigator.pushNamed(context, route);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isActive
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isActive
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.textSecondaryLight,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationsDialog() {
    final List<Map<String, dynamic>> notifications = [
      {
        "title": "Low Stock Alert",
        "message": "iPhone 15 Pro Case is running low (5 units left)",
        "time": "2 minutes ago",
        "type": "warning",
        "isRead": false,
      },
      {
        "title": "New Order",
        "message": "Order #ORD-2025-006 received from Sarah Johnson",
        "time": "15 minutes ago",
        "type": "info",
        "isRead": false,
      },
      {
        "title": "Payment Received",
        "message": "Payment of \$245.99 confirmed for Order #ORD-2025-001",
        "time": "1 hour ago",
        "type": "success",
        "isRead": true,
      },
      {
        "title": "Customer Review",
        "message": "New 5-star review for Wireless Headphones Pro",
        "time": "2 hours ago",
        "type": "info",
        "isRead": true,
      },
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Notifications'),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Mark All Read'),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 40.h,
            child: ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final isRead = notification["isRead"] as bool;

                return ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _getNotificationColor(
                        notification["type"] as String,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: _getNotificationIcon(
                        notification["type"] as String,
                      ),
                      color: _getNotificationColor(
                        notification["type"] as String,
                      ),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    notification["title"] as String,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification["message"] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        notification["time"] as String,
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(color: AppTheme.textSecondaryLight),
                      ),
                    ],
                  ),
                  trailing: isRead
                      ? null
                      : Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'warning':
        return AppTheme.warningLight;
      case 'success':
        return AppTheme.successLight;
      case 'error':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _getNotificationIcon(String type) {
    switch (type) {
      case 'warning':
        return 'warning';
      case 'success':
        return 'check_circle';
      case 'error':
        return 'error';
      default:
        return 'info';
    }
  }
}
