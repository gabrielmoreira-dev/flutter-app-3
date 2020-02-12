import 'package:app3_shop/providers/cart.dart';
import 'package:app3_shop/screens/cart_screen.dart';
import 'package:app3_shop/widgets/badge.dart';
import 'package:app3_shop/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavoritesOnly = false;

  void selectCart(){
    Navigator.of(context).pushNamed(CartScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: <Widget>[
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: selectCart,
            ),
            builder: (context, cart, iconButton) => Badge(
              child: iconButton,
              value: cart.itemsCount.toString(),
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              setState(() {
                _showFavoritesOnly =
                    value == FilterOptions.Favorites ? true : false;
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.All,
              ),
              PopupMenuItem(
                child: Text('Favorites'),
                value: FilterOptions.Favorites,
              ),
            ],
          ),
        ],
      ),
      body: ProductsGrid(_showFavoritesOnly),
    );
  }
}
