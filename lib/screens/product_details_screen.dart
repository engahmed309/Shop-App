import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/product_provider.dart";

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = "/product-detail";
  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct = Provider.of<ProductProvider>(context, listen: false)
        .findById(productID);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: 300,
              // width: double.infinity,
              child: Image.network(loadedProduct.imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                  elevation: 6,
                  child: Text(
                    "\$${loadedProduct.price.toString()}",
                    style: TextStyle(
                        fontSize: 40, color: Theme.of(context).primaryColor),
                  )),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                loadedProduct.description,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
