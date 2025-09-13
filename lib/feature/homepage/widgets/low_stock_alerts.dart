import 'package:empire/core/utilis/app_theme.dart';
import 'package:empire/feature/homepage/widgets/custom_icon_widget.dart';
import 'package:empire/feature/homepage/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';



class LowStockAlerts extends StatelessWidget {
  const LowStockAlerts({super.key});

  final List<Map<String, dynamic>> lowStockItems = const [
    {
      "id": 1,
      "name": "iPhone 15 Pro Case",
      "image":
          "https://images.unsplash.com/photo-1601593346740-925612772716?w=300&h=300&fit=crop",
      "currentStock": 5,
      "minStock": 20,
      "category": "Accessories",
      "sku": "ACC-001",
      "urgency": "Critical",
    },
    {
      "id": 2,
      "name": "Wireless Charging Pad",
      "image":
          "https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=300&h=300&fit=crop",
      "currentStock": 8,
      "minStock": 25,
      "category": "Electronics",
      "sku": "ELC-045",
      "urgency": "High",
    },
    {
      "id": 3,
      "name": "Premium Laptop Stand",
      "image":
          "https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=300&h=300&fit=crop",
      "currentStock": 12,
      "minStock": 30,
      "category": "Office",
      "sku": "OFF-023",
      "urgency": "Medium",
    },
    {
      "id": 4,
      "name": "Bluetooth Earbuds",
      "image":
          "https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=300&h=300&fit=crop",
      "currentStock": 3,
      "minStock": 15,
      "category": "Audio",
      "sku": "AUD-012",
      "urgency": "Critical",
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
              Row(
                children: [
                  Text(
                    'Low Stock Alerts',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.errorLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${lowStockItems.length}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.errorLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/admin-product-management');
                },
                child: Text(
                  'Manage',
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
            itemCount: lowStockItems.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final item = lowStockItems[index];
              return _buildStockAlertCard(context, item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStockAlertCard(BuildContext context, Map<String, dynamic> item) {
    final urgency = item["urgency"] as String;
    final urgencyColor = _getUrgencyColor(urgency);

    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.lightTheme.colorScheme.surface,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: item["image"] as String,
                  width: 15.w,
                  height: 15.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item["name"] as String,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: urgencyColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          urgency,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: urgencyColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Text(
                        'SKU: ${item["sku"]}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        item["category"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Stock: ',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondaryLight,
                              ),
                            ),
                            TextSpan(
                              text: '${item["currentStock"]}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: urgencyColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: ' / ${item["minStock"]}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _showRestockDialog(
                                  context, item["name"] as String);
                            },
                            child: Container(
                              padding: EdgeInsets.all(1.5.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CustomIconWidget(
                                iconName: 'add',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 16,
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/admin-product-management');
                            },
                            child: Container(
                              padding: EdgeInsets.all(1.5.w),
                              decoration: BoxDecoration(
                                color: AppTheme.textSecondaryLight
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CustomIconWidget(
                                iconName: 'edit',
                                color: AppTheme.textSecondaryLight,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'critical':
        return AppTheme.errorLight;
      case 'high':
        return AppTheme.warningLight;
      case 'medium':
        return AppTheme.lightTheme.colorScheme.primary;
      default:
        return AppTheme.textSecondaryLight;
    }
  }

  void _showRestockDialog(BuildContext context, String productName) {
    final TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Restock Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add stock for: $productName'),
              SizedBox(height: 2.h),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity to add',
                  hintText: 'Enter quantity',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Stock updated successfully for $productName'),
                  ),
                );
              },
              child: Text('Add Stock'),
            ),
          ],
        );
      },
    );
  }
}
