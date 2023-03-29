import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart';
import '/providers/cart.dart';
import '../widgets/cart_item.dart' as ca;

class CartScreen extends StatelessWidget {
  static String routeName = "/CardScreen";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(children: [
        Card(
          elevation: 6,
          margin: const EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Chip(
                  backgroundColor: Theme.of(context).primaryColor,
                  label: Text(
                    "\$${cart.totalAmount.toString()}",
                    style: Theme.of(context).primaryTextTheme.titleMedium,
                  ),
                  //child: Text()
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: orderButton(cart: cart),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cart.itemCount,
            itemBuilder: (BuildContext context, int index) {
              return ca.CartItemDetails(
                id: cart.items.values.toList()[index].id,
                itemId: cart.items.keys.toList()[index],
                title: cart.items.values.toList()[index].title,
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
              );
            },
          ),
        )
      ]),
    );
  }
}

class orderButton extends StatefulWidget {
  const orderButton({
    super.key,
    required this.cart,
  });

  final Cart cart;
  

  @override
  State<orderButton> createState() => _orderButtonState();
} bool _isLoading = false;

class _orderButtonState extends State<orderButton> {
  @override
  Widget build(BuildContext context) {
   
    return ElevatedButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Order>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cart.freeItems();
            },
      child: _isLoading ? Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: CircularProgressIndicator(
          
        ),
      ) : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Order Now"),
      ),
    );
  }
}
