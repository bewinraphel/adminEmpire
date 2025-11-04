 

import 'package:empire/core/di/service_locator.dart';
import 'package:empire/feature/revenue/domain/entity/revenue_entity.dart';
import 'package:empire/feature/revenue/presentation/bloc/revenue_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class RevenueChartCard extends StatelessWidget {
  const RevenueChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RevenueBloc>()..add(const RevenueDataRequested()),
      child: const _RevenueChartCardContent(),
    );
  }
}

class _RevenueChartCardContent extends StatelessWidget {
  const _RevenueChartCardContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RevenueBloc, RevenueState>(
      builder: (context, state) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, state),
                if (state.isLoading) ...[
                  SizedBox(height: 2.h),
                  const Center(child: CircularProgressIndicator()),
                ] else if (state.error != null) ...[
                  SizedBox(height: 2.h),
                  _buildErrorState(state.error!,context),
                ] else if (state.revenueData.isEmpty) ...[
                  SizedBox(height: 2.h),
                  _buildEmptyState(context),
                ] else ...[
                  SizedBox(height: 2.h),
                  _buildChart(state,context),
                  SizedBox(height: 2.h),
                  if (state.summary != null) _buildStats(state.summary!),
                ],
                SizedBox(height: 1.h),
                _buildRealtimeToggle(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, RevenueState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Revenue Analytics',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<RevenuePeriod>(
              value: state.period,
              isDense: true,
              items: RevenuePeriod.values.map((period) {
                return DropdownMenuItem<RevenuePeriod>(
                  value: period,
                  child: Text(
                    _getPeriodDisplayName(period),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (RevenuePeriod? newValue) {
                if (newValue != null) {
                  context.read<RevenueBloc>().add(RevenuePeriodChanged(newValue));
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRealtimeToggle(BuildContext context, RevenueState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Live Updates',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(width: 2.w),
        Switch(
          value: state.isRealTime,
          onChanged: (value) {
            context.read<RevenueBloc>().add(RevenueRealTimeToggled(value));
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 25.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart_outlined,
                  size: 48,
                  color: Colors.grey.withOpacity(0.5),
                ),
                SizedBox(height: 2.h),
                Text(
                  'No Revenue Data',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Revenue analytics will appear here once you start receiving orders',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.h),
        _buildEmptyStats(),
      ],
    );
  }

  Widget _buildErrorState(String error,BuildContext context) {
    return Column(
      children: [
        Container(
          height: 25.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Unable to Load Data',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp),
                ),
                SizedBox(height: 2.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<RevenueBloc>().add(const RevenueDataRequested());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.h),
        _buildEmptyStats(),
      ],
    );
  }

  Widget _buildEmptyStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('Total Revenue', '\$0', '0%', true, isPlaceholder: true),
        _buildStatItem('Avg. Order', '\$0', '0%', true, isPlaceholder: true),
        _buildStatItem('Conversion', '0%', '0%', true, isPlaceholder: true),
      ],
    );
  }

  Widget _buildChart(RevenueState state,BuildContext context) {
    final revenueData = state.revenueData;
    
    return Container(
      height: 25.h,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _calculateInterval(state.summary?.totalRevenue ?? 0),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.3),
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
                  if (value.toInt() >= 0 && value.toInt() < revenueData.length) {
                    return SideTitleWidget(
                      
                       
                  meta:meta ,
                      child: Text(
                        _formatDateForDisplay(revenueData[value.toInt()].date, state.period),
                        style: TextStyle(fontSize: 10.sp),
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
                interval: _calculateInterval(state.summary?.totalRevenue ?? 0),
                reservedSize: 50,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return SideTitleWidget(
                   meta: meta,
                
                    child: Text(
                      _formatCurrency(value),
                      style: TextStyle(fontSize: 10.sp),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          minX: 0,
          maxX: (revenueData.length - 1).toDouble(),
          minY: 0,
          maxY: _calculateMaxY(revenueData),
          lineBarsData: [
            LineChartBarData(
              spots: revenueData.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  entry.value.revenue,
                );
              }).toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
                  if (dataIndex >= 0 && dataIndex < revenueData.length) {
                    final data = revenueData[dataIndex];
                    return LineTooltipItem(
                      '${_formatDateForDisplay(data.date, state.period)}\n\$${data.revenue.toStringAsFixed(0)}\n${data.orders} orders',
                      TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                  return null;
                }).where((item) => item != null).toList().cast<LineTooltipItem>();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStats(RevenueSummary summary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          'Total Revenue', 
          _formatCurrency(summary.totalRevenue), 
          '${summary.revenueChange.toStringAsFixed(1)}%', 
          summary.revenueChange >= 0
        ),
        _buildStatItem(
          'Avg. Order', 
          _formatCurrency(summary.averageOrderValue), 
          '${summary.aovChange.toStringAsFixed(1)}%', 
          summary.aovChange >= 0
        ),
        _buildStatItem(
          'Conversion', 
          '${summary.conversionRate.toStringAsFixed(1)}%', 
          '${summary.conversionChange.toStringAsFixed(1)}%', 
          summary.conversionChange >= 0
        ),
      ],
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    String change,
    bool isPositive, {
    bool isPlaceholder = false,
  }) {
    return Column(
      children: [
        Text(
          label, 
          style: TextStyle(
            fontSize: 10.sp,
            color: isPlaceholder ? Colors.grey.withOpacity(0.5) : null,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isPlaceholder ? Colors.grey.withOpacity(0.5) : null,
          ),
        ),
        SizedBox(height: 0.5.h),
        if (!isPlaceholder)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green : Colors.red,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                change,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.remove,
                color: Colors.grey.withOpacity(0.5),
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                change,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
      ],
    );
  }

  // Helper Methods
  String _getPeriodDisplayName(RevenuePeriod period) {
    switch (period) {
      case RevenuePeriod.daily:
        return 'Daily';
      case RevenuePeriod.weekly:
        return 'Weekly';
      case RevenuePeriod.monthly:
        return 'Monthly';
    }
  }

  String _formatDateForDisplay(DateTime date, RevenuePeriod period) {
    switch (period) {
      case RevenuePeriod.daily:
        return DateFormat('E').format(date);
      case RevenuePeriod.weekly:
        return 'W${_getWeekNumber(date)}';
      case RevenuePeriod.monthly:
        return DateFormat('MMM').format(date);
    }
  }

  int _getWeekNumber(DateTime date) {
    final firstJan = DateTime(date.year, 1, 1);
    final daysDiff = date.difference(firstJan).inDays;
    return ((daysDiff + firstJan.weekday - 1) / 7).floor() + 1;
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(1)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  double _calculateMaxY(List<RevenueData> data) {
    if (data.isEmpty) return 10000;
    final maxRevenue = data.map((e) => e.revenue).reduce((a, b) => a > b ? a : b);
    final maxY = (maxRevenue * 1.2).ceilToDouble();
    return maxY > 0 ? maxY : 10000;
  }

  double _calculateInterval(double maxRevenue) {
    if (maxRevenue <= 1000) return 200;
    if (maxRevenue <= 5000) return 1000;
    if (maxRevenue <= 10000) return 2000;
    if (maxRevenue <= 50000) return 5000;
    if (maxRevenue <= 100000) return 10000;
    if (maxRevenue <= 500000) return 50000;
    if (maxRevenue <= 1000000) return 100000;
    return 200000;
  }
}