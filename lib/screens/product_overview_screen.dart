import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../providers/cart.dart';
import '../widgets/21.2%20badge.dart.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';

enum menuOptions { Favourite, All }

class ProductOverViewScreen extends StatefulWidget {
  static const routeName = "/product-overView-screen";
  @override
  State<ProductOverViewScreen> createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var showFavOnly = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvider>(context).fetchAndSetProd().then(
            (_) => setState(
              () {
                _isLoading = false;
              },
            ),
          );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (menuOptions value) {
              setState(() {
                if (value == menuOptions.Favourite) {
                  showFavOnly = true;
                  // print("F");
                } else {
                  showFavOnly = false;
                  //  print("A");
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favourites"),
                value: menuOptions.Favourite,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: menuOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => MyBadge(
              color: Colors.red,
              value: cart.itemCount.toString(),
              child: ch!,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed("/CardScreen");
              },
            ),
          ),
        ],
        title: Text("Shop App"),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showFavOnly),
    );
  }
}
