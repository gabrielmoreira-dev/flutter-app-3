import 'package:app3_shop/providers/orders_provider.dart';
import 'package:app3_shop/widgets/app_drawer.dart';
import 'package:app3_shop/widgets/order_item_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: orderData.orders.isEmpty
          ? Center(
              child: Text(
                'No orders included yet!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (_, index) => ChangeNotifierProvider.value(
                value: orderData.orders[index],
                child: OrderItemCard(),
              ),
            ),
      drawer: AppDrawer(),
    );
  }
}
