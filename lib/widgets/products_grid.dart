import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context, listen: false);
    final Products =
        showFavs == true ? productsData.favItems : productsData.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: Products.length,
      itemBuilder: (BuildContext context, i) => ChangeNotifierProvider.value(
        //create: (c) => Products[i],
        value: Products[i],
        child: ProductItem(
            // Products[i].id,
            //Products[i].title,
            // Products[i].imageUrl
            ),
      ),
    );
  }
}
