import 'package:app3_shop/providers/cart.dart';
import 'package:app3_shop/providers/products_provider.dart';
import 'package:app3_shop/screens/cart_screen.dart';
import 'package:app3_shop/widgets/app_drawer.dart';
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
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() => _isLoading = true);
      Provider.of<ProductsProvider>(context).fetchProduts().then((_) {
        setState(() => _isLoading = false);
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context).fetchProduts();
  }

  void _selectCart() {
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
              onPressed: _selectCart,
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
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => this._refreshProducts(context),
              child: ProductsGrid(_showFavoritesOnly),
            ),
    );
  }
}
