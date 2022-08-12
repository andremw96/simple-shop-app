import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  void addProduct(Product product) {
    final newProduct = Product(
      id: DateTime.now().toString(),
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );
    _items.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String productId, Product product) {
    final productIndex =
        _items.indexWhere((element) => element.id == productId);

    if (productIndex >= 0) {
      _items[productIndex] = product;
      notifyListeners();
    }
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
