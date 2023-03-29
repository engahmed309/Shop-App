import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:snack/snack.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // ProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final product = Provider.of<Product>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            style: TextStyle(),
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);

              SnackBar(
                duration: Duration(seconds: 2),
                content: const Text(
                  "Added to yuor cart !",
                ),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {
                    cart.removeSingleItem(
                      product.id,
                    );
                  },
                ),
              ).show(context);
            },
          ),
          leading: Consumer<Product>(
            builder: (ctx, Product, _) => IconButton(
              icon: product.isFavourite
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                product.toggleFavouriteStatus();
              },
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
