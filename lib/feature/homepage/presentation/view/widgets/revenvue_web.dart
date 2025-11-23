import 'package:empire/core/utilis/color.dart';
import 'package:empire/feature/homepage/presentation/view/widgets/quick_section_web.dart';
import 'package:empire/feature/revenue/domain/entity/revenue_entity.dart';
import 'package:empire/feature/revenue/presentation/bloc/revenue_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class RevenueChartCardweb extends StatelessWidget {
  const RevenueChartCardweb({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    return const _RevenueChartCardContentweb();
  }
}

class _RevenueChartCardContentweb extends StatelessWidget {
  const _RevenueChartCardContentweb();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<RevenueBloc, RevenueState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///header --Revenue & week
                _buildHeaderweb(context, state),
                SizedBox(height: 2.h),

                ///loading
                if (state.isLoading) ...[
                  SizedBox(height: 2.h),
                  const Center(child: CircularProgressIndicator()),
                ] else if (state.error != null) ...[
                  ///Error
                  SizedBox(height: 2.h),
                  _buildErrorStateweb(state.error!, context),
                ] else if (state.revenueData.isEmpty) ...[
                  ///Emty ui
                  SizedBox(height: 2.h),
                  _buildEmptyStateweb(context),
                ] else ...[
                  ////  ui
                  // SizedBox(height: screenHeight * 0.50),
                  SizedBox(
                    height: screenHeight * 0.50,
                    child: _buildChartweb(state, context),
                  ),
                ],
                // SizedBox(height: 1.h),
                // _buildRealtimeToggleweb(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderweb(BuildContext context, RevenueState state) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 1200;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.30,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Revenue Analytics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Container(
            height: screenHeight * 0.04,
            width: screenWidth * 0.07,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<RevenuePeriod>(
                  value: state.period,
                  isDense: true,
                  items: RevenuePeriod.values.map((period) {
                    return DropdownMenuItem<RevenuePeriod>(
                      value: period,
                      child: Text(
                        _getPeriodDisplayNameweb(period),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (RevenuePeriod? newValue) {
                    if (newValue != null) {
                      context.read<RevenueBloc>().add(
                        RevenuePeriodChanged(newValue),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealtimeToggleweb(BuildContext context, RevenueState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Live Updates', style: Theme.of(context).textTheme.bodySmall),
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

  Widget _buildEmptyStateweb(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    final emptyHeight = isDesktop ? 200 : 25.h;

    return Column(
      children: [
        Container(
          height: emptyHeight.toDouble(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart_outlined,
                  size: isDesktop ? 64.0 : 48.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
                SizedBox(height: 2.h),
                Text(
                  'No Revenue Data',
                  style: TextStyle(
                    fontSize: isDesktop ? 18.sp : 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Revenue analytics will appear here once you start receiving orders',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isDesktop ? 14.sp : 12.sp,
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.h),
        _buildEmptyStats(isDesktop),
      ],
    );
  }

  Widget _buildErrorStateweb(String error, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    final errorHeight = isDesktop ? 200 : 25.h;

    return Column(
      children: [
        Container(
          height: errorHeight.toDouble(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 2.h),
                Text(
                  'Unable to Load Data',
                  style: TextStyle(
                    fontSize: isDesktop ? 18.sp : 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: isDesktop ? 14.sp : 12.sp),
                ),
                SizedBox(height: 2.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<RevenueBloc>().add(
                      const RevenueDataRequested(),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.h),
        _buildEmptyStats(isDesktop),
      ],
    );
  }

  Widget _buildEmptyStats(bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItemweb(
          'Total Revenue',
          '\$0',
          '0%',
          true,
          isPlaceholder: true,
        ),
        _buildStatItemweb('Avg. Order', '\$0', '0%', true, isPlaceholder: true),
        _buildStatItemweb('Conversion', '0%', '0%', true, isPlaceholder: true),
      ],
    );
  }

  Widget _buildChartweb(RevenueState state, BuildContext context) {
    final revenueData = state.revenueData;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    final maxX = (revenueData.length - 1).toDouble();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(color: ColoRs.fieldcolor),
            borderRadius: BorderRadius.circular(10),
          ),
          width: screenWidth * 0.30,
          child: RepaintBoundary(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _calculateInterval(
                    state.summary?.totalRevenue ?? 0,
                  ),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                  ),
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
                      reservedSize: 40,
                      interval: 10,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < revenueData.length) {
                          return SideTitleWidget(
                            meta: meta,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                _formatDateForDisplay(
                                  revenueData[value.toInt()].date,
                                  state.period,
                                ),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _calculateInterval(
                        state.summary?.totalRevenue ?? 0,
                      ),
                      reservedSize: 60,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            _formatCurrency(value),
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                minX: 0,
                maxX: maxX,
                minY: 0,
                maxY: _calculateMaxY(revenueData),
                lineBarsData: [
                  LineChartBarData(
                    spots: revenueData
                        .asMap()
                        .entries
                        .map(
                          (entry) =>
                              FlSpot(entry.key.toDouble(), entry.value.revenue),
                        )
                        .toList(),
                    isCurved: true,
                    preventCurveOverShooting: true,
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
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
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
                      return touchedBarSpots
                          .map((barSpot) {
                            final flSpot = barSpot;
                            final dataIndex = flSpot.x.toInt();
                            if (dataIndex >= 0 &&
                                dataIndex < revenueData.length) {
                              final data = revenueData[dataIndex];
                              return LineTooltipItem(
                                '${_formatDateForDisplay(data.date, state.period)}\n\$${data.revenue.toStringAsFixed(0)}\n${data.orders} orders',
                                const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }
                            return null;
                          })
                          .where((item) => item != null)
                          .toList()
                          .cast<LineTooltipItem>();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 3.w),
        if (state.summary != null)
          _buildStatsweb(state.summary!, true, context),
        const QuickActionsSectionweb(),
      ],
    );
  }

  Widget _buildStatsweb(
    RevenueSummary summary,
    bool isDesktop,
    BuildContext context,
  ) {
    final screenheight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      elevation: 3,
      color: ColoRs.whiteColor,
      child: Container(
        width: screenWidth * 0.10,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          border: Border.all(color: ColoRs.fieldcolor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _buildStatItemweb(
                'Total Revenue',
                _formatCurrency(summary.totalRevenue),
                '${summary.revenueChange.toStringAsFixed(1)}%',
                summary.revenueChange >= 0,
              ),
            ),
            Expanded(
              child: _buildStatItemweb(
                'Avg. Order',
                _formatCurrency(summary.averageOrderValue),
                '${summary.aovChange.toStringAsFixed(1)}%',
                summary.aovChange >= 0,
              ),
            ),
            Expanded(
              child: _buildStatItemweb(
                'Conversion',
                '${summary.conversionRate.toStringAsFixed(1)}%',
                '${summary.conversionChange.toStringAsFixed(1)}%',
                summary.conversionChange >= 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItemweb(
    String label,
    String value,
    String change,
    bool isPositive, {
    bool isPlaceholder = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isPlaceholder ? Colors.grey.withOpacity(0.5) : null,
          ),
          textAlign: TextAlign.center, // Center on responsive rows
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isPlaceholder ? Colors.grey.withOpacity(0.5) : null,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.5.h),
        if (!isPlaceholder)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                change,
                style: TextStyle(
                  fontSize: 14,
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          )
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.remove, color: Colors.grey.withOpacity(0.5), size: 20),
              const SizedBox(width: 10),
              Text(
                change,
                style: TextStyle(
                  fontSize: 14,

                  color: Colors.grey.withOpacity(0.5),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
      ],
    );
  }

  // Helper Methods (unchanged, but added responsive tweaks where used)
  String _getPeriodDisplayNameweb(RevenuePeriod period) {
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
    if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
    return '\$${value.toStringAsFixed(0)}';
  }

  double _calculateMaxY(List<RevenueData> data) {
    if (data.isEmpty) return 10000;
    final maxRevenue = data
        .map((e) => e.revenue)
        .reduce((a, b) => a > b ? a : b);
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
