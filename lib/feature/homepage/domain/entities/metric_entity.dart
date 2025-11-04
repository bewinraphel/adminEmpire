// lib/feature/metrics/domain/entities/metrics_entity.dart
import 'package:equatable/equatable.dart';

class MetricsData extends Equatable {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final String iconName;
  final int color;

  const MetricsData({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.iconName,
    required this.color,
  });

  @override
  List<Object?> get props => [title, value, change, isPositive, iconName, color];
}

class MetricsSummary extends Equatable {
  final double totalSales;
  final int totalOrders;
  final int totalCustomers;
  final int lowStockItems;
  final double salesChange;
  final double ordersChange;
  final double customersChange;
  final double stockChange;

  const MetricsSummary({
    required this.totalSales,
    required this.totalOrders,
    required this.totalCustomers,
    required this.lowStockItems,
    required this.salesChange,
    required this.ordersChange,
    required this.customersChange,
    required this.stockChange,
  });

  @override
  List<Object?> get props => [
        totalSales,
        totalOrders,
        totalCustomers,
        lowStockItems,
        salesChange,
        ordersChange,
        customersChange,
        stockChange,
      ];
}