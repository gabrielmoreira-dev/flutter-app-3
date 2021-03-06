import 'package:app3_shop/providers/products_provider.dart';
import 'package:app3_shop/screens/edit_product_screen.dart';
import 'package:app3_shop/widgets/app_drawer.dart';
import 'package:app3_shop/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<ProductsProvider>(context).fetchProduts();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => this._refreshProducts(context),
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Consumer<ProductsProvider>(
              builder: (context, products, child) => ListView.builder(
                itemCount: products.items.length,
                itemBuilder: (context, index) => ChangeNotifierProvider.value(
                  value: products.items[index],
                  child: Column(
                    children: <Widget>[
                      UserProductItem(),
                      Divider(),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ),

    );
  }
}
