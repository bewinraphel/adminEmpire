import 'package:empire/core/utilis/app_theme.dart';
import 'package:empire/feature/homepage/presentation/bloc/metric_bloc.dart';
import 'package:empire/feature/homepage/presentation/view/widget.dart';

import 'package:empire/feature/revenue/presentation/bloc/revenue_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _onRefresh() async {
    context.read<RevenueBloc>().add(const RevenueDataRequested());
    context.read<MetricsBloc>().add(const MetricsDataRequested());
  }

  @override
  Widget build(BuildContext context) {
   
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 768 && screenWidth <= 1200;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _onRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              const HomeAppBar(),
              SliverListSection(isDesktop: isDesktop, isTablet: isTablet),
            ],
          ),
        ),
      ),
      bottomNavigationBar: !isDesktop
          ? BottomNavigationSectiion(context: context)
          : null,
    );
  }
}
