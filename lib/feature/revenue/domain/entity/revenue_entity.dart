class RevenueData {
  final DateTime date;
  final double revenue;
  final int orders;
 

  const RevenueData({
    required this.date,
    required this.revenue,
    required this.orders,
 
  });
}

class RevenueSummary {
  final double totalRevenue;
  final double averageOrderValue;
  final double conversionRate;
  final double revenueChange;
  final double aovChange;
  final double conversionChange;
  final int totalOrder;
  const RevenueSummary({
    required this.totalRevenue,
    required this.averageOrderValue,
    required this.conversionRate,
    required this.revenueChange,
    required this.aovChange,
    required this.conversionChange,
     required this.totalOrder,
  });
}

class RevenueDataModel extends RevenueData {
  const RevenueDataModel({
    required super.date,
    required super.revenue,
    required super.orders,
    
  });

  factory RevenueDataModel.fromJson(Map<String, dynamic> json) =>
      RevenueDataModel(
        date: DateTime.parse(json['date']),
        revenue: (json['revenue'] as num).toDouble(),
        orders: json['orders'] as int,
      );
}

enum RevenuePeriod { daily, weekly, monthly } 