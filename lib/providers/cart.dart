import 'package:app3_shop/providers/cart_item.dart';
import 'package:flutter/foundation.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items;

  Cart() {
    _items = {};
  }

  Map<String, CartItem> get items => {..._items};

  int get itemsCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((_, item) => total += item.price * item.quantity);
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (cartItem) => CartItem(
              id: cartItem.id,
              title: cartItem.title,
              price: cartItem.price,
              quantity: cartItem.quantity + 1));
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

  void removeItem(String productId) {
    if (_items.containsKey(productId)) _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (item) => CartItem(
          id: item.id,
          title: item.title,
          price: item.price,
          quantity: item.quantity - 1,
        ),
      );
      notifyListeners();
    } else {
      removeItem(productId);
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
