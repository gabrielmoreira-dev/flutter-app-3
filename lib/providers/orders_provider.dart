import 'dart:convert';

import 'package:app3_shop/providers/cart_item.dart';
import 'package:app3_shop/providers/order_item.dart';
import 'package:app3_shop/providers/product.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  Future<void> fetchOrders() async {
    const url = 'https://flutter-app3-shop.firebaseio.com/orders.json';

    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      if (data.isEmpty) return;
      data.forEach(
        (orderId, orderData) => loadedOrders.add(
          OrderItem(
            id: orderId,
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    title: item['title'],
                    quantity: item['quantity'],
                  ),
                )
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime']),
            amount: orderData['amount'],
          ),
        ),
      );
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    const url = 'https://flutter-app3-shop.firebaseio.com/orders.json';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'products': cartProducts
                .map(
                  (cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  },
                )
                .toList(),
            'dateTime': timeStamp.toIso8601String(),
          },
        ),
      );

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timeStamp,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (e) {
      print('error: $e');
      throw e;
    }
  }
}
