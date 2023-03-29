import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavourite = false});
       void setFavState(bool newValue){
        isFavourite=newValue;
        notifyListeners();
      }
  void toggleFavouriteStatus() async{
    final oldStatus= isFavourite;
     isFavourite = !isFavourite;
    notifyListeners();
    var url = Uri.parse(
        'https://shop-app-65b3e-default-rtdb.firebaseio.com/products/$id.json');
        try{
        final response =  await http.patch(url, body: json.encode({
    'isFavourite':isFavourite
   }));
   if(response.statusCode>=400){
    setFavState(oldStatus);
   }
        }catch(error){
          setFavState(oldStatus);
         
        }
  
   
   
  }
}
