import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.datetime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final _url = Uri.https(
    "simple-shop-app-48eff-default-rtdb.asia-southeast1.firebasedatabase.app",
    "/orders.json",
  );

  Future<void> fetchAndSetOrders() async {
    final respons = await http.get(_url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(respons.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((key, value) {
      loadedOrders.add(
        OrderItem(
          id: key,
          amount: value["amount"],
          products: (value["products"] as List<dynamic>)
              .map(
                (e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price'],
                ),
              )
              .toList(),
          datetime: DateTime.parse(value["dateTime"]),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final response = await http.post(
      _url,
      body: json.encode(
        {
          "amount": total,
          "dateTime": timestamp.toIso8601String(),
          "products": cartProducts
              .map(
                (e) => {
                  "id": e.id,
                  "title": e.title,
                  "quantity": e.quantity,
                  "price": e.price,
                },
              )
              .toList()
        },
      ),
    );

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        datetime: timestamp,
      ),
    );
    notifyListeners();
  }
}
