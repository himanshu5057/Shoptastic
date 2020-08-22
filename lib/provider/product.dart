import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ProductModal with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  bool fav;
  final double price;
  final String imageURL;
  ProductModal(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageURL,
      @required this.price,
      this.fav = false});
  Future<void> toggleFav(String token, String userId) async {
    final old = fav;
    fav = !fav;
    notifyListeners();
    var url =
        'https://shop-cca63.firebaseio.com/favs/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(url, body: json.encode(fav));
      if (response.statusCode >= 400) {
        fav = old;
        notifyListeners();
      }
    } catch (error) {
      fav = old;
      notifyListeners();
    }
  }
}
