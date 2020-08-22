import 'dart:convert';
import 'package:flutter/material.dart';
import '../provider/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem with ChangeNotifier{
  final double amount;
  final List<CartItem> products;
  final String id;
  OrderItem(this.id, this.products, this.amount);
}


class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> orders() {
    return [..._orders];
  }

  Future<void> fetch(String token,String userId) async {
    final url = 'https://shop-cca63.firebaseio.com/order/$userId.json?auth=$token';
    var response = await http.get(url);
    List<OrderItem> loadedOrders = [];
    final extractedOrder = json.decode(response.body) as Map<String, dynamic>;
    if(extractedOrder==null){
      return;
    }
    extractedOrder.forEach(
      (orderId, orderDetails) {
        loadedOrders.add(OrderItem(
            orderDetails['id'],
            (orderDetails['products'] as List<dynamic>).map((e) => CartItem(
                id: e['id'],
                price: e['price'],
                title: e['title'],
                quantity: e['quantity'])).toList(),
            orderDetails['total']));
      },
    );
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> cartProducts, total,String token,String userId) async {
    final url = 'https://shop-cca63.firebaseio.com/order/$userId.json?auth=$token';
    var timestamp = DateTime.now().toIso8601String();
    await http.post(url,
        body: json.encode({
          'total': total,
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'price': e.price,
                    'quantity': e.quantity,
                    'title': e.title
                  })
              .toList()
        }));
    _orders.insert(0, OrderItem(timestamp, cartProducts, total));
    notifyListeners();
  }
  OrderItem findById(String id){
    return orders().firstWhere((element) => element.id==id);
  }
}
