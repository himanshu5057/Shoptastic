import 'dart:convert';
import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  String token;
  String userId;
  Products(this.token, this.userId);
  List<ProductModal> _prods=[];
  List<ProductModal> _item = [
    // ProductModal(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageURL:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    //   ProductModal(
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageURL:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   ),
    //   ProductModal(
    //     id: 'p3',
    //     title: 'Yellow Scarf',
    //     description: 'Warm and cozy - exactly what you need for the winter.',
    //     price: 19.99,
    //     imageURL:
    //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   ),
    //   ProductModal(
    //     id: 'p4',
    //     title: 'A Pan',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageURL:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   ),
  ];
  List<ProductModal> get favs {
    return _item.where((element) => element.fav).toList();
  }

  List<ProductModal> get items {
    return [..._item];
  }
  List<ProductModal> get prods{
    return [..._prods];
  }

  Future<void> fetchProductsData() async {
    var url = 'https://shop-cca63.firebaseio.com/products.json?auth=$token';
    var urlProds='https://shop-cca63.firebaseio.com/$userId.json?auth=$token';
    try {
      final response = await http.get(url);
      final responseProds=await http.get(urlProds);
      url = 'https://shop-cca63.firebaseio.com/favs/$userId.json?auth=$token';
      final favData = await http.get(url);
      final favResponse = json.decode(favData.body);
      List<ProductModal> loadedProduct = [];
      List<ProductModal> prodts=[];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final dataProds=json.decode(responseProds.body) as Map<String,dynamic>;
      if (extractedData == null) {
        return;
      }
      if(dataProds!=null){
      dataProds.forEach((prodID, prodData) {
        prodts.add(ProductModal(
            id: prodID,
            description: prodData['description'],
            imageURL: prodData['imageURL'],
            price: prodData['price'],
            title: prodData['title'],
            fav: favResponse==null?false: favResponse[prodID]??false 
        ));_prods=prodts;
        notifyListeners();});}
      extractedData.forEach((prodID, prodData) {
        loadedProduct.add(ProductModal(
            id: prodID,
            description: prodData['description'],
            imageURL: prodData['imageURL'],
            price: prodData['price'],
            title: prodData['title'],
            fav: favResponse==null?false: favResponse[prodID]??false
            ));

        _item = loadedProduct+prodts;
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(ProductModal product) async {
    var url = 'https://shop-cca63.firebaseio.com/$userId.json?auth=$token';
    try {
      final value = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageURL': product.imageURL,
          }));
      _prods.add(ProductModal(
          description: product.description,
          title: product.title,
          price: product.price,
          imageURL: product.imageURL,
          id: json.decode(value.body)['name'],
          fav: product.fav));
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  ProductModal findById(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(String id, ProductModal product) async {
    var index = _prods.indexWhere((element) => element.id == id);
    if (index >= 0) {
      final url =
          'https://shop-cca63.firebaseio.com/$userId/$id.json?auth=$token';
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageURL': product.imageURL,
          }));
      _prods[index] = product;
      notifyListeners();
    }
  }

  Future<void> delete(String id) async {
    _prods.removeWhere((val) => val.id == id);
    notifyListeners();
    final url =
        'https://shop-cca63.firebaseio.com/$userId/$id.json?auth=$token';
    await http.delete(url);
  }
}
