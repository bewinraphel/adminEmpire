import 'package:empire/core/utilis/app_theme.dart';
import 'package:empire/feature/homepage/widgets/custom_icon_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RevenueChartCard extends StatefulWidget {
  const RevenueChartCard({super.key});

  @override
  State<RevenueChartCard> createState() => _RevenueChartCardState();
}

class _RevenueChartCardState extends State<RevenueChartCard> {
  String selectedPeriod = 'Weekly';
  final List<String> periods = ['Daily', 'Weekly', 'Monthly'];

  final List<Map<String, dynamic>> revenueData = [
    {"day": "Mon", "revenue": 12500.0, "orders": 45},
    {"day": "Tue", "revenue": 15800.0, "orders": 52},
    {"day": "Wed", "revenue": 18200.0, "orders": 61},
    {"day": "Thu", "revenue": 14600.0, "orders": 48},
    {"day": "Fri", "revenue": 22400.0, "orders": 73},
    {"day": "Sat", "revenue": 28900.0, "orders": 89},
    {"day": "Sun", "revenue": 25300.0, "orders": 82},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Revenue Analytics',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPeriod,
                      isDense: true,
                      items: periods.map((String period) {
                        return DropdownMenuItem<String>(
                          value: period,
                          child: Text(
                            period,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedPeriod = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              height: 25.h,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5000,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < revenueData.length) {
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                revenueData[value.toInt()]["day"] as String,
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 10000,
                        reservedSize: 50,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              '\$${(value / 1000).toStringAsFixed(0)}k',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline.withValues(
                        alpha: 0.3,
                      ),
                    ),
                  ),
                  minX: 0,
                  maxX: (revenueData.length - 1).toDouble(),
                  minY: 0,
                  maxY: 30000,
                  lineBarsData: [
                    LineChartBarData(
                      spots: revenueData.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          (entry.value["revenue"] as double),
                        );
                      }).toList(),
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.primary.withValues(
                            alpha: 0.7,
                          ),
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppTheme.lightTheme.colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.lightTheme.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
                            AppTheme.lightTheme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final flSpot = barSpot;
                          final dataIndex = flSpot.x.toInt();
                          if (dataIndex >= 0 &&
                              dataIndex < revenueData.length) {
                            final data = revenueData[dataIndex];
                            return LineTooltipItem(
                              '${data["day"]}\n\$${(data["revenue"] as double).toStringAsFixed(0)}\n${data["orders"]} orders',
                              AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }
                          return null;
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total Revenue', '\$137,700', '+12.5%', true),
                _buildStatItem('Avg. Order', '\$312', '+8.2%', true),
                _buildStatItem('Conversion', '3.4%', '-2.1%', false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    String change,
    bool isPositive,
  ) {
    return Column(
      children: [
        Text(label, style: AppTheme.lightTheme.textTheme.bodySmall),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.5.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: isPositive ? 'trending_up' : 'trending_down',
              color: isPositive ? AppTheme.successLight : AppTheme.errorLight,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              change,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isPositive ? AppTheme.successLight : AppTheme.errorLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
