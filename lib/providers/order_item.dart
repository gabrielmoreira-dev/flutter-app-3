import 'package:app3_shop/providers/cart_item.dart';
import 'package:flutter/foundation.dart';

class OrderItem with ChangeNotifier{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}
