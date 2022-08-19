import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  String authToken;
  String userId;

  ProductsProvider(this.authToken, this.userId, this._items);

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var _url = Uri.parse(
        'https://simple-shop-app-48eff-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(_url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      _url = Uri.parse(
          "https://simple-shop-app-48eff-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken");
      final favoriteResposne = await http.get(_url);
      final favoriteData = json.decode(favoriteResposne.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final _url = Uri.parse(
        "https://simple-shop-app-48eff-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken");

    try {
      final response = await http.post(_url,
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "creatorId": userId,
          }));

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String productId, Product product) async {
    final productIndex =
        _items.indexWhere((element) => element.id == productId);

    if (productIndex >= 0) {
      final url = Uri.parse(
          "https://simple-shop-app-48eff-default-rtdb.asia-southeast1.firebasedatabase.app/products/$productId.json?auth=$authToken");
      await http.patch(
        url,
        body: json.encode(
          {
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
          },
        ),
      );

      _items[productIndex] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse(
        "https://simple-shop-app-48eff-default-rtdb.asia-southeast1.firebasedatabase.app/products/$productId.json?auth=$authToken");
    final existingProductIndex =
        _items.indexWhere((element) => element.id == productId);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw const HttpException("could not delete product.");
    }
    existingProduct = null;
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
