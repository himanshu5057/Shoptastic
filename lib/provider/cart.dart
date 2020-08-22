import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final double price;
  final int quantity;
  final String title;
  CartItem(
      {@required this.id,
      @required this.price,
      @required this.title,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get value {
    return items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, int quantity, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => CartItem(
              id: value.id,
              price: value.price,
              title: value.title,
              quantity: value.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              price: price,
              title: title,
              quantity: 1));
    }

    notifyListeners();
  }

  void deleteItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void undo(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId].quantity == 1) {
        _items.remove(productId);
      }
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (value) => CartItem(
              id: value.id,
              price: value.price,
              title: value.title,
              quantity: value.quantity - 1));
    }

    notifyListeners();
  }
}
