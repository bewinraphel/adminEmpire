// lib/feature/metrics/presentation/widgets/metrics_cards.dart
import 'package:empire/core/di/service_locator.dart';
import 'package:empire/feature/homepage/domain/entities/metric_entity.dart';
import 'package:empire/feature/homepage/presentation/bloc/metric_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class MetricsCards extends StatelessWidget {
  const MetricsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MetricsBloc>()..add(const MetricsDataRequested()),
      child: const _MetricsCardsContent(),
    );
  }
}

class _MetricsCardsContent extends StatelessWidget {
  const _MetricsCardsContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MetricsBloc, MetricsState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            children: [
              _buildRealtimeToggle(context, state),
              SizedBox(height: 2.h),
              _buildMetricsGrid(state, context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRealtimeToggle(BuildContext context, MetricsState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Live Updates', style: Theme.of(context).textTheme.bodySmall),
        SizedBox(width: 2.w),
        Switch(
          value: state.isRealTime,
          onChanged: (value) {
            context.read<MetricsBloc>().add(MetricsRealTimeToggled(value));
          },
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(MetricsState state, BuildContext context) {
    if (state.isLoading) {
      return _buildLoadingGrid();
    } else if (state.error != null) {
      return _buildErrorState(state.error!, context);
    } else if (state.metricsData.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 1.3,
      ),
      itemCount: state.metricsData.length,
      itemBuilder: (context, index) {
        final metric = state.metricsData[index];
        return _buildMetricCard(metric: metric);
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 1.3,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _buildMetricCardShimmer();
      },
    );
  }

  Widget _buildErrorState(String error, BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.error_outline, size: 48, color: Colors.red),
        SizedBox(height: 2.h),
        Text(
          'Unable to Load Metrics',
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
            context.read<MetricsBloc>().add(const MetricsDataRequested());
          },
          child: const Text('Retry'),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Icon(
          Icons.analytics_outlined,
          size: 48,
          color: Colors.grey.withOpacity(0.5),
        ),
        SizedBox(height: 2.h),
        Text(
          'No Metrics Data',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Metrics will appear here once you have data',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({required MetricsData metric}) {
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
                    metric.title,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Color(metric.color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getIcon(metric.iconName),
                    color: Color(metric.color),
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              metric.value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                Text(
                  metric.change,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: metric.isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 1.w),
                Icon(
                  metric.isPositive ? Icons.trending_up : Icons.trending_down,
                  color: metric.isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCardShimmer() {
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
                Container(
                  width: 40.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.circle, color: Colors.grey[400], size: 20),
                ),
              ],
            ),
            Container(
              width: 60.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: 30.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'attach_money':
        return Icons.attach_money;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'people':
        return Icons.people;
      case 'warning':
        return Icons.warning;
      default:
        return Icons.help_outline;
    }
  }
}
