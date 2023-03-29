import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/product_provider.dart';
import '../widgets/user_product.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products-screen";

  Future<void> refreshItems(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchAndSetProd();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("User Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshItems(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (BuildContext context, int index) => UserProductItem(
              id: productsData.items[index].id,
              title: productsData.items[index].title,
              imageUrl: productsData.items[index].imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}
