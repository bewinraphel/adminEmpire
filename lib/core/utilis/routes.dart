import 'package:empire/feature/homepage/presentation/view/home_page.dart';

import 'package:flutter/material.dart';

class AppRoutes {
  static const String initial = '/';
  static const String productDetail = '/product-detail';
  // static const String productList = '/product-list';
  static const String adminProductManagement = "/admin-product-management";
  // static const String barcodeScanner = '/barcode-scanner';
  // static const String productAnalytics = '/product-analytics';
  // static const String inventoryManagement = '/inventory-management';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case productDetail:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case adminProductManagement:
        return MaterialPageRoute(builder: (_) => const HomePage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Page not found"))),
        );
    }
  }
}
