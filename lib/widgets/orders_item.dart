import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order.dart' as or;

class OrdersItem extends StatefulWidget {
  final or.OrderItem order;
  OrdersItem(this.order);

  @override
  State<OrdersItem> createState() => _OrdersItemState();
}

class _OrdersItemState extends State<OrdersItem> {
  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              '\$${widget.order.amount}',
            ),
            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.Hm().format(widget.order.dateTime),
                ),
                Text(
                  DateFormat.yMEd().format(widget.order.dateTime),
                ),

              ],
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              icon: isExpanded == true
                  ? Icon(Icons.expand_less)
                  : Icon(Icons.expand_more),
            ),
          ),
          if (isExpanded)
            Container(
              height: min(
                widget.order.products.length * 20 + 10,
                180,
              ),
              child: ListView(
                children: widget.order.products
                    .map(
                      (prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prod.title,
                            style:  TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$${prod.price} x${prod.quantity}",

                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
