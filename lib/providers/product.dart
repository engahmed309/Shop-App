import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});
  void setFavState(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  void toggleFavoriteStatus(String token) async {
    
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    var url = Uri.parse(
        'https://shop-app-65b3e-default-rtdb.firebaseio.com/products/$id.json?auth=$token');
    try {
      final response = await http.patch(url,
          body: json.encode({'isFavourite': isFavorite}));
      if (response.statusCode >= 400) {
        setFavState(oldStatus);
      }
    } catch (error) {
      print(error);
      setFavState(oldStatus);
    }
  }
}
