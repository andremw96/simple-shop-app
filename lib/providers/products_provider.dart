import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Future<void> addProduct(Product product) {
    var url = Uri.https(
      "simple-shop-app-48eff-default-rtdb.asia-southeast1.firebasedatabase",
      "/products.json",
    );

    return http
        .post(url,
            body: json.encode({
              "title": product.title,
              "description": product.description,
              "imageUrl": product.imageUrl,
              "price": product.price,
              "isFavorite": product.isFavorite,
            }))
        .then(
      (response) {
        final newProduct = Product(
          id: DateTime.now().toString(),
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
        );
        _items.add(newProduct);
        notifyListeners();
      },
    ).catchError((error) {
      throw error;
    });
  }

  void updateProduct(String productId, Product product) {
    final productIndex =
        _items.indexWhere((element) => element.id == productId);

    if (productIndex >= 0) {
      _items[productIndex] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String productId) {
    _items.removeWhere((element) => element.id == productId);
    notifyListeners();
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
