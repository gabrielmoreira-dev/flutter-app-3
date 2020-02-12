import 'package:app3_shop/model/cart_item.dart';
import 'package:flutter/foundation.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items;

  Cart(){
    _items = {}; 
  }

  Map<String, CartItem> get items => {..._items};

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (cartItem) => CartItem(
        id: cartItem.id,
        title: cartItem.title,
        price: cartItem.price,
        quantity: cartItem.quantity + 1
      ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1,
          ));
    }
    notifyListeners();
  }

  int get itemsCount => _items.length;


}
