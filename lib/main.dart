import 'package:app3_shop/providers/products_provider.dart';
import 'package:app3_shop/screens/product_detail_screen.dart';
import 'package:app3_shop/screens/products_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ShopApp());
}

class ShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ProductsProvider(),
      child: MaterialApp(
        title: 'Shop App',
        home: ProductsOverviewScreen(),
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
        ),
        routes: {
          ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
        },
      ),
    );
  }
}
