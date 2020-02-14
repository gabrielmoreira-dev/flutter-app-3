import 'package:app3_shop/providers/orders_provider.dart';
import 'package:app3_shop/widgets/app_drawer.dart';
import 'package:app3_shop/widgets/order_item_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: FutureBuilder(
        future:
            Provider.of<OrdersProvider>(context, listen: false).fetchOrders(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error ocurred'),
              );
            } else {
              return Consumer<OrdersProvider>(
                builder: (context, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (_, index) => ChangeNotifierProvider.value(
                    value: orderData.orders[index],
                    child: OrderItemCard(),
                  ),
                ),
              );
            }
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
