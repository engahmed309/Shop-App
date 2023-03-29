import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItemDetails extends StatelessWidget {
  String id;
  String itemId;
  String title;
  double price;
  int quantity;
  CartItemDetails({
    required this.id,
    required this.itemId,
    required this.title,
    required this.price,
    required this.quantity,
  });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: const Text("No"),
                  ),
                ],
                icon: const Icon(
                  Icons.delete,
                ),
                content: const Text(
                  "Remove this Item..",
                ),
                title: Text(
                  "Are you sure?",
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              );
            });
      },
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).dismissItem(itemId);
      },
      background: Container(
        padding: EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        color: Colors.red,
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(4.0),
              child: CircleAvatar(
                child: FittedBox(child: Text("\$${price.toString()}")),
              ),
            ),
            title: Text(title),
            subtitle: Text("\$${quantity * price}"),
            trailing: Text("$quantity x"),
          ),
        ),
      ),
    );
  }
}
