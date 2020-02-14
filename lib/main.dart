import 'package:app3_shop/providers/auth.dart';
import 'package:app3_shop/providers/cart.dart';
import 'package:app3_shop/providers/orders_provider.dart';
import 'package:app3_shop/providers/products_provider.dart';
import 'package:app3_shop/screens/auth-screen.dart';
import 'package:app3_shop/screens/cart_screen.dart';
import 'package:app3_shop/screens/edit_product_screen.dart';
import 'package:app3_shop/screens/orders_screen.dart';
import 'package:app3_shop/screens/product_detail_screen.dart';
import 'package:app3_shop/screens/products_overview_screen.dart';
import 'package:app3_shop/screens/user_products_screen.dart';
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
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          builder: (context, auth, previousProducts) => ProductsProvider(
            auth.token,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, OrdersProvider>(
          builder: (context, auth, previousOrders) => OrdersProvider(
            auth.token,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
        ChangeNotifierProvider.value(value: Cart()),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Shop App',
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          routes: {
            ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
            CartScreen.routeName: (_) => CartScreen(),
            OrdersScreen.routeName: (_) => OrdersScreen(),
            UserProductsScreen.routeName: (_) => UserProductsScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen(),
            ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
          },
        ),
      ),
    );
  }
}
