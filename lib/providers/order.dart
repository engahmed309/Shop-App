import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<cartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  final String token;
  Order(this.token, this._orders);
  Future<void> addOrder(List<cartItem> cartProducts, double total) async {
    //sending your order to fire base

    final url = Uri.parse(
        "https://shop-app-65b3e-default-rtdb.firebaseio.com/orders.json?auth=$token");
    var mydateTime = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'dateTime': mydateTime.toIso8601String(),
          'amount': total,
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity,
                  })
              .toList(),
        }));

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: mydateTime,
      ),
    );
  }

  //FETCHING ORDERS FROM FIREBASE
  Future<void> fetshAndSetOrders() async {
    final url = Uri.parse(
        'https://shop-app-65b3e-default-rtdb.firebaseio.com/orders.json?auth=$token');
    final response = await http.get(url);
    //print(json.decode(response.body));
    List<OrderItem> loadedOrders = [];
    if (json.decode(response.body) == null) {
      return;
    }
    var extractedOrders = json.decode(response.body) as Map<String, dynamic>;

    extractedOrders.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => cartItem(
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity'],
                  ))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
