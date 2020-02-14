import 'dart:convert';

import 'package:app3_shop/model/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    final url = 'https://flutter-app3-shop.firebaseio.com/products/$id.json';

    this.isFavorite = !this.isFavorite;
    notifyListeners();

    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {'isFavorite': isFavorite},
        ),
      );

      if (response.statusCode >= 400) {
        this.isFavorite = !this.isFavorite;
        notifyListeners();

        throw HttpException('Could not update favorite status');
      }
    } catch (e) {
      this.isFavorite = !this.isFavorite;
      notifyListeners();
    }
  }
}
