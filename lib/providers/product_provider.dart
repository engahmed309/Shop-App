import 'dart:convert';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

import './product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // var _showFavouritesOnly=false ;
  List<Product> get items {
    // if (_showFavouritesOnly){
    // return _items.where((element) => element.isFavourite==true).toList();
    // }
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite == true).toList();
  }
  // void favOnly(){
  //   _showFavouritesOnly==true;
  //   notifyListeners();
  // }
  // void all(){
  //   _showFavouritesOnly==false;
  //   notifyListeners();
  // }

  findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  final String authToken;
  ProductProvider(this.authToken,this._items);

  Future<void> fetchAndSetProd() async {
    try {
      final url = Uri.parse(
          'https://shop-app-65b3e-default-rtdb.firebaseio.com/products.json?auth=$authToken');
      final response = await http.get(url);
      if (json.decode(response.body).isEmpty) {
        return;
      }
      final extractedData = json.decode(response.body) as Map;
      //print(extractedData);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavourite'],
        ));
      });
      if (loadedProducts.isNotEmpty) {
        _items = loadedProducts;
      } else {
        _items = [];
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shop-app-65b3e-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final value = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'isFavourite': product.isFavorite,
          'imageUrl': product.imageUrl,
        }),
      );

      final newProduct = Product(
        id: json.decode(value.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    var prodIndex = _items.indexWhere((element) => element.id == id);

    if (prodIndex >= 0) {
      var url = Uri.parse(
          'https://shop-app-65b3e-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));

      _items[prodIndex] = newProduct;
    }

    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    var url = Uri.parse(
        'https://shop-app-65b3e-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingIndex];
    _items.removeAt(existingIndex);
    notifyListeners();
    final response = await http.delete(
      url,
    );

    if (response.statusCode >= 400) {
      print("failed");
      _items.insert(existingIndex, existingProduct);
      notifyListeners();
      throw Exception();
    }
    print(response.statusCode);
    // existingProduct != null;
  }

  Future<void> changeFavStatus(String id, Product newProduct) async {
    var url = Uri.parse(
        'https://shop-app-65b3e-default-rtdb.firebaseio.com/products/$id.json');
    http.patch(url, body: json.encode({'isFavourite': newProduct.isFavorite}));
  }
}
