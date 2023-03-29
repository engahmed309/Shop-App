import 'package:flutter/material.dart';

class cartItem {
  String id;
  String title;
  double price;
  int quantity;
  cartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, cartItem> _items = {};
  Map<String, cartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }

  void addItem(
    String productId,
    String title,
    double price,
  ) {
    if (_items.containsKey(productId)) {
      //change Quantity
      _items.update(
        productId,
        (existingCartItem) => cartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => cartItem(
          id: productId,
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void dismissItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String itemId) {
    if (!_items.containsKey(itemId)) {
      return;
    }
    if (_items[itemId]!.quantity > 1) {
      _items.update(
        itemId,
        (items) => cartItem(
          id: items.id,
          title: items.title,
          price: items.price,
          quantity: items.quantity - 1,
        ),
      );
    } else {
      _items.remove(itemId);
    }
    notifyListeners();
  }

  void freeItems() {
    _items = {};
    notifyListeners();
  }
}
