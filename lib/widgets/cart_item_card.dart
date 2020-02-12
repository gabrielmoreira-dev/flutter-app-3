import 'package:app3_shop/providers/cart.dart';
import 'package:app3_shop/providers/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemCard extends StatelessWidget {
  final String productId;

  CartItemCard(this.productId);

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<CartItem>(context, listen: false);

    return Dismissible(
      key: ValueKey(item.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text('\$${item.price}'),
                ),
              ),
            ),
            title: Text(item.title),
            subtitle: Text('Total: \$${item.quantity * item.price}'),
            trailing: Text('${item.quantity}x'),
          ),
        ),
      ),
    );
  }
}
