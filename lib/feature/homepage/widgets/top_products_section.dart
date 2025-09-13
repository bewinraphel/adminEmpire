import 'package:empire/core/utilis/app_theme.dart';
import 'package:empire/feature/homepage/widgets/custom_icon_widget.dart';
import 'package:empire/feature/homepage/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TopProductsSection extends StatelessWidget {
  const TopProductsSection({super.key});

  final List<Map<String, dynamic>> topProducts = const [
    {
      "id": 1,
      "name": "Wireless Headphones Pro",
      "image":
          "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&h=300&fit=crop",
      "sales": 245,
      "revenue": "\$12,250",
      "rating": 4.8,
      "trend": "+15%",
      "isPositive": true,
    },
    {
      "id": 2,
      "name": "Smart Watch Series X",
      "image":
          "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300&h=300&fit=crop",
      "sales": 189,
      "revenue": "\$18,900",
      "rating": 4.6,
      "trend": "+8%",
      "isPositive": true,
    },
    {
      "id": 3,
      "name": "Premium Coffee Maker",
      "image":
          "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=300&h=300&fit=crop",
      "sales": 156,
      "revenue": "\$7,800",
      "rating": 4.5,
      "trend": "-3%",
      "isPositive": false,
    },
    {
      "id": 4,
      "name": "Gaming Mechanical Keyboard",
      "image":
          "https://images.unsplash.com/photo-1541140532154-b024d705b90a?w=300&h=300&fit=crop",
      "sales": 134,
      "revenue": "\$6,700",
      "rating": 4.7,
      "trend": "+12%",
      "isPositive": true,
    },
    {
      "id": 5,
      "name": "Bluetooth Speaker Mini",
      "image":
          "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=300&h=300&fit=crop",
      "sales": 98,
      "revenue": "\$2,940",
      "rating": 4.3,
      "trend": "+5%",
      "isPositive": true,
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
                'Top Products',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/product-catalog');
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
          SizedBox(
            height: 32.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: topProducts.length,
              separatorBuilder: (context, index) => SizedBox(width: 1.w),
              itemBuilder: (context, index) {
                final product = topProducts[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      width: 45.w,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppTheme.lightTheme.colorScheme.surface,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomImageWidget(
                      imageUrl: product["image"] as String,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product["name"] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        const CustomIconWidget(
                          iconName: 'star',
                          color: AppTheme.warningLight,
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${product["rating"]}',
                          style: AppTheme.lightTheme.textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${product["sales"]} sold',
                          style: AppTheme.lightTheme.textTheme.bodySmall
                              ?.copyWith(color: AppTheme.textSecondaryLight),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product["revenue"] as String,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: (product["isPositive"] as bool)
                                  ? 'trending_up'
                                  : 'trending_down',
                              color: (product["isPositive"] as bool)
                                  ? AppTheme.successLight
                                  : AppTheme.errorLight,
                              size: 14,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              product["trend"] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                    color: (product["isPositive"] as bool)
                                        ? AppTheme.successLight
                                        : AppTheme.errorLight,
                                    fontWeight: FontWeight.w500,
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
      ),
    );
  }
}
