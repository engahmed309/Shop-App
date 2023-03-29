import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart';
import '../widgets/app_drawer.dart';
import '../providers/order.dart' show Order;
import '../widgets/orders_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orderScreen";

  
  @override
  // var _isLoading = false;
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) async {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     await Provider.of<Order>(context, listen: false).fetshAndSetOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  Widget build(BuildContext context) {
    // final orderData = Provider.of<Order>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text(
          "Orders",
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<Order>(context, listen: false).fetshAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
//implement some error handling here
              return Center(
                child: Text("An Error Happened"),
              );
            } else {
              return
              Consumer<Order>(builder:(ctx, orderData,child){
                return
                ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (ctx, i) => OrdersItem(orderData.orders[i]),
              );
              });
               
            }
          }
        },
      ),
    );
  }
}
