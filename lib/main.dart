import 'package:app3_shop/providers/cart.dart';
import 'package:app3_shop/providers/orders_provider.dart';
import 'package:app3_shop/providers/products_provider.dart';
import 'package:app3_shop/screens/cart_screen.dart';
import 'package:app3_shop/screens/orders_screen.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ProductsProvider()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProvider.value(value: OrdersProvider()),
      ],
      child: MaterialApp(
        title: 'Shop App',
        home: ProductsOverviewScreen(),
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
        ),
        routes: {
          ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
          CartScreen.routeName: (_) => CartScreen(),
          OrdersScreen.routeName: (_) => OrdersScreen(),
        },
      ),
    );
  }
}
