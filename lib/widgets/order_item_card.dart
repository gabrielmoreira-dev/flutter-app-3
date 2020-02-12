import 'dart:math';

import 'package:intl/intl.dart';
import 'package:app3_shop/providers/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderItemCard extends StatefulWidget {
  @override
  _OrderItemCardState createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final orderItem = Provider.of<OrderItem>(context, listen: false);
    final products = orderItem.products;

    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              '\$${orderItem.amount.toStringAsFixed(2)}',
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(orderItem.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(
                products.length * 20.0 + 10,
                180,
              ),
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (_, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      products[index].title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${products[index].quantity}x \$${products[index].price}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
