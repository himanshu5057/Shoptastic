import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/auth.dart';
import 'package:shop/provider/order_item.dart';
import '../provider/cart.dart';
import '../cart_item_details.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final order = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Stack(children: <Widget>[
        if (isLoading)
          Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        Column(children: <Widget>[
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  "Total",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 20),
                ),
                Spacer(),
                Chip(
                  label: Text(
                    "\$${cart.totalAmount.toStringAsFixed(2)}",
                  ),
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                FlatButton(
                  onPressed: cart.totalAmount <= 0 || isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          await order.addOrders(
                              cart.items.values.toList(),
                              cart.totalAmount,
                              Provider.of<Auth>(context, listen: false).token,
                              Provider.of<Auth>(context, listen: false).userId);

                          cart.clear();
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.of(context).pushNamed('./order-screen');
                        },
                  child: Text(
                    "Order",
                  ),
                  textColor: Colors.deepOrangeAccent,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemBuilder: (ctx, i) {
                  return CartItemDetail(
                    cart.items.values.toList()[i].id,
                    cart.items.keys.toList()[i],
                    cart.items.values.toList()[i].title,
                    cart.items.values.toList()[i].price,
                    cart.items.values.toList()[i].quantity,
                  );
                },
                itemCount: cart.items.length),
          ),
        ]),
      ]),
    );
  }
}
