import 'package:app3_shop/widgets/products_grid.dart';
import 'package:flutter/material.dart';

class ProductsOverviewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
      ),
      body: ProductsGrid(),
    );
  }
}

