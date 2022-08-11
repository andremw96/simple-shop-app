import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatelessWidget {
  const OrderItem({Key? key, required this.orderItem}) : super(key: key);

  final ord.OrderItem orderItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${orderItem.amount}"),
            subtitle: Text(
              DateFormat(" dd MMM yyyy hh:mm").format(orderItem.datetime),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.expand_more),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
