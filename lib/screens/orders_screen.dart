import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Order;
import 'package:shop_app/widgets/order_item.dart';

import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  static const routeName = "/order";

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // var _isLoading = false;

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((value) async {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await Provider.of<Order>(context, listen: false).fetchAndSetOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  Future<void>? _ordersFuture = null;
  Future _obtainOrdersFuture() {
    return Provider.of<Order>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text("Your Orders"),
        ),
        body: FutureBuilder(
            future: _ordersFuture,
            builder: (ctx, datasnapshot) {
              if (datasnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (datasnapshot.error != null) {
                  return const Center(child: Text("an error occured"));
                } else {
                  return Consumer<Order>(builder: (ctx, orders, child) {
                    return ListView.builder(
                      itemCount: orders.orders.length,
                      itemBuilder: (context, i) => OrderItem(
                        orderItem: orders.orders[i],
                      ),
                    );
                  });
                }
              }
            }));
  }
}
