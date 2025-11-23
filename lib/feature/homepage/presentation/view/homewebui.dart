import 'package:empire/core/utilis/app_theme.dart';
import 'package:empire/core/utilis/color.dart';
import 'package:empire/feature/homepage/presentation/view/widgets/metrics_cards.dart';

import 'package:empire/feature/homepage/presentation/view/widgets/revenvue_web.dart';
import 'package:flutter/material.dart';

class Homewebui extends StatefulWidget {
  final BoxConstraints constraints;
  const Homewebui({required this.constraints, super.key});

  @override
  State<Homewebui> createState() => _HomewebuiState();
}

class _HomewebuiState extends State<Homewebui> {
  int _selectedIndex = 0;
  final List<_NavItem> _navItems = [
    _NavItem(label: 'Dashboard', icon: 'dashboard', route: '/admin-dashboard'),
    _NavItem(
      label: 'Products',
      icon: 'inventory',
      route: '/admin-product-management',
    ),
    _NavItem(label: 'Orders', icon: 'list_alt', route: '/order-history'),
  ];
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: Colors.amberAccent,
          width: widget.constraints.maxWidth * 0.10,
        ),
        // Container(child: _buildNavigationRail(isDesktop: true)),
        SizedBox(
          width: widget.constraints.maxWidth * 0.70,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MetricsCards(isDesktop: true),
              SizedBox(width: 10),
              RevenueChartCardweb(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationRail({required bool isDesktop}) {
    return Container(
      height: 600,
      width: isDesktop ? 240 : 72,
      color: AppTheme.lightTheme.cardColor,
      child: NavigationRail(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
          final route = _navItems[index].route;
          // context.go(route); // or Navigator.pushNamed, GoRouter recommended
        },
        labelType: isDesktop
            ? NavigationRailLabelType
                  .none // Shows labels next to icons when extended
            : NavigationRailLabelType.selected,
        extended: isDesktop, // Shows labels on large screens
        backgroundColor: AppTheme.lightTheme.cardColor,
        selectedIconTheme: IconThemeData(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
        unselectedIconTheme: IconThemeData(color: Colors.grey.shade600),
        selectedLabelTextStyle: TextStyle(
          color: AppTheme.lightTheme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        destinations: _navItems
            .map(
              (item) => NavigationRailDestination(
                icon: Icon(_getIconData(item.icon)),
                selectedIcon: Icon(
                  _getIconData(item.icon),
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                label: Text(item.label),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String icon;
  final String route;
  _NavItem({required this.label, required this.icon, required this.route});
}

IconData _getIconData(String name) {
  switch (name) {
    case 'dashboard':
      return Icons.dashboard;
    case 'inventory':
      return Icons.inventory_2;
    case 'list_alt':
      return Icons.list_alt;
    default:
      return Icons.circle;
  }
}
