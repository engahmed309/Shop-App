import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/4.2%20auth_screen.dart.dart';

import '/screens/edit_product_screen.dart';
import '/providers/order.dart';
import '/screens/cart_screen.dart';
import '/screens/orders_screen.dart';
import '/screens/user_products_screen.dart';
import '/providers/cart.dart';
import '/providers/product_provider.dart';
import './screens/product_details_screen.dart';
import './screens/product_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Order(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: ProductProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            // ignore: deprecated_member_use
            accentColor: Colors.deepOrange),
        home: AuthScreen(),
        routes: {
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        }, 
      ),
    );

    // create: (ctx)=>ProductProvider(),
  }
}
