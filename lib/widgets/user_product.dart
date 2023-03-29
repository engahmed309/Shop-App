import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snack/snack.dart';

import '../providers/product_provider.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  String id;
  String title;
  String imageUrl;
  UserProductItem({
    required this.id,
    required this.title,
    required this.imageUrl,
  });
  @override
  Widget build(BuildContext context) {
    var myCtx = context;
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text(title),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
            ),
            trailing: Container(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          EditProductScreen.routeName,
                          arguments: id);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      try {
                        await Provider.of<ProductProvider>(context,
                                listen: false)
                            .deleteProduct(id);
                      } catch (error) {
                        const SnackBar(
                          content: Text("Failed to delete item"
                          ,textAlign: TextAlign.center),
                          duration: Duration(seconds: 2),
                        ).show(myCtx);
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
    
  }
  
}
