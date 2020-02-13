import 'package:app3_shop/providers/product.dart';
import 'package:app3_shop/providers/products_provider.dart';
import 'package:app3_shop/screens/edit_screen_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);

    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: product.id,
              ),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () =>
                  Provider.of<ProductsProvider>(context, listen: false)
                      .deleteProduct(product.id),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
