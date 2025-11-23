import 'package:empire/feature/homepage/domain/entities/metric_entity.dart';
import 'package:empire/feature/homepage/presentation/bloc/metric_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class MetricsCards extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;

  const MetricsCards({
    super.key,
    this.isDesktop = false,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return _MetricsCardsContent(isDesktop: isDesktop);
  }
}

class _MetricsCardsContent extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;

  const _MetricsCardsContent({this.isDesktop = false, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MetricsBloc, MetricsState>(
      builder: (context, state) {
        return Column(
          children: [
            isDesktop
                ? _buildMetricsGridweb(state, context)
                : _buildMetricsGrid(state, context),
            // isDesktop
            //     ? _buildRealtimeToggleweb(context, state)
            //     : _buildMetricsGrid(state, context),
            // SizedBox(height: 2.h),
          ],
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

  Widget _buildRealtimeToggleweb(BuildContext context, MetricsState state) {
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

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double childAspectRatio;

        if (constraints.maxWidth >= 1100) {
          crossAxisCount = 4;
          childAspectRatio = 1.5;
        } else if (constraints.maxWidth >= 650) {
          crossAxisCount = 3;
          childAspectRatio = 1.4;
        } else {
          crossAxisCount = 2;
          childAspectRatio = 1.3;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: state.metricsData.length,
          itemBuilder: (context, index) {
            final metric = state.metricsData[index];
            return _buildMetricCard(metric: metric);
          },
        );
      },
    );
  }

  Widget _buildMetricsGridweb(MetricsState state, BuildContext context) {
    if (state.isLoading) {
      return _buildLoadingGrid();
    } else if (state.error != null) {
      return _buildErrorState(state.error!, context);
    } else if (state.metricsData.isEmpty) {
      return _buildEmptyState();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final boundedWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;

        return SizedBox(
          width: boundedWidth * 0.70,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemCount: state.metricsData.length,
            itemBuilder: (context, index) {
              final metric = state.metricsData[index];
              return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10),
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
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(0),
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
                      const SizedBox(height: 20),
                      Text(
                        metric.value,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),

                      Row(
                        children: [
                          Text(
                            metric.change,
                            style: TextStyle(
                              fontSize: 18,
                              color: metric.isPositive
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Icon(
                            metric.isPositive
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: metric.isPositive
                                ? Colors.green
                                : Colors.red,
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
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

  Widget _buildMetricCardweb({required MetricsData metric}) {
    return RepaintBoundary(
      child: Card(
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
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(0),
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
              const SizedBox(height: 90),
              Text(
                metric.value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

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
      ),
    );
  }

  Widget _buildMetricCard({required MetricsData metric}) {
    return RepaintBoundary(
      child: Card(
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
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
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
                  width: 18.w,
                  height: 4.h,
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
              width: 20.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: 30.w,
              height: 2.h,
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
