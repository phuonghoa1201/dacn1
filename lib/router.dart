import 'package:dacn1/features/product_details/screens/product_detail_screen.dart';
import 'package:dacn1/models/product.dart';
import 'package:flutter/material.dart';
import 'package:dacn1/features/auth/screens/auth_screen.dart';
import 'package:dacn1/common/widgets/bottom_bar.dart';
import 'package:dacn1/features/home/screen/home_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
<<<<<<< HEAD
    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailScreen(product: product),
=======
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
>>>>>>> 9aa24973453f410874b2304d1d2942748f27c315
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder:
            (_) => const Scaffold(
              body: Center(child: Text('Screen does not exist')),
            ),
      );
  }
}
