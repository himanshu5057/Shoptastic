import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/cart.dart';

class CartItemDetail extends StatefulWidget {
  final String id;
  final String productId;
  final int quantity;
  final double price;
  final String title;

  CartItemDetail(
      this.productId, this.id, this.title, this.price, this.quantity);

  @override
  _CartItemDetailState createState() => _CartItemDetailState();
}

class _CartItemDetailState extends State<CartItemDetail> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.id),
      background: Container(
        child: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 30,
            )),
        color: Colors.red,
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).deleteItem(widget.id);
      },
      child: Card(
          margin: EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  leading: CircleAvatar(
                    child: FittedBox(child: Text(widget.price.toString())),
                  ),
                  title: Text(widget.title),
                  subtitle: Text("Total: \$${widget.price * widget.quantity}"),
                  trailing: Text(widget.quantity.toString() + "x"),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false)
                        .deleteItem(widget.id);
                  })
            ],
          )),
    );
  }
}
