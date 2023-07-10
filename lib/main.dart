import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/4.2%20auth_screen.dart.dart';
import 'package:shop_app/screens/product_overview_screen.dart';

import '/screens/edit_product_screen.dart';
import '/providers/order.dart';
import '/screens/cart_screen.dart';
import '/screens/orders_screen.dart';
import '/screens/user_products_screen.dart';
import '/providers/cart.dart';
import '/providers/product_provider.dart';
import './screens/product_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (ctx) => Order("", []),
          update: (ctx, value, previousProducts) => Order(
            value.token!,
            previousProducts == null ? [] : previousProducts.orders,
          ),
        ),
        // ChangeNotifierProvider.value(
        //   value: Order(),
        // ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          create: (ctx) => ProductProvider("", []),
          update: (ctx, value, previousProducts) => ProductProvider(
            value.token!,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        // ChangeNotifierProvider.value(
        //   value: ProductProvider(Auth().token),
        // ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            // ignore: deprecated_member_use
          ),
          home: auth.isAuth ? ProductOverViewScreen() : AuthScreen(),
          routes: {
            ProductOverViewScreen.routeName: (ctx) => ProductOverViewScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );

    // create: (ctx)=>ProductProvider(),
  }
}
