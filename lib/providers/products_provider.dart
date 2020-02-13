import 'dart:convert';

import 'package:app3_shop/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      _items.where((item) => item.isFavorite).toList();

  Product findById(String id) {
    return _items.firstWhere((p) => p.id == id);
  }

  Future<void> fetchProduts() async {
    const url = 'https://flutter-app3-shop.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      data.forEach((prodId, productData){
        loadedProducts.add(Product(
          id: prodId,
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite']
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://flutter-app3-shop.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          },
        ),
      );

      _items.add(
        Product(
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name'],
        ),
      );
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void updateProduct(Product product) {
    final productIndex = _items.indexWhere((p) => p.id == product.id);
    if (productIndex >= 0) {
      _items[productIndex] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
