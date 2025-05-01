import 'package:flutter/material.dart';
import 'package:hungerz_kitchen/Pages/home.dart';
import 'package:hungerz_kitchen/Pages/insight.dart';
import 'package:hungerz_kitchen/Pages/pastOrders.dart';

class PageRoutes {
  static const String homePage = 'home_page';
  static const String insightPage = 'insight_page';
  static const String pastOrders = 'past_orders';

  Map<String, WidgetBuilder> routes() {
    return {
      homePage: (context) => HomePage(),
      insightPage: (context) => InsightPage(),
      pastOrders: (context) => PastOrders(),
    };
  }
}
