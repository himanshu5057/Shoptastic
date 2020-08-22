import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/provider/order_item.dart';

class OrderDetail extends StatefulWidget {
  final OrderItem ord;
  OrderDetail(this.ord);
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  bool expand = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(7),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "\$${widget.ord.amount}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            subtitle:
                Text(DateFormat('yyyy/MM/dd, EE ').format(DateTime.now())),
            trailing: IconButton(
                icon: Icon(!expand ? Icons.expand_more : Icons.expand_less),
                onPressed: () {
                  setState(() {
                    expand = !expand;
                  });
                }),
          ),
          if (expand)
            Container(
                height: widget.ord.products.toList().length.toDouble() * 30,
                child: ListView(
                  children: widget.ord.products
                      .map((e) => Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Title(
                                  child: Text(e.title),
                                  color: Colors.black,
                                ),
                                Text("${e.quantity}x${e.price}")
                              ],
                            ),
                          ))
                      .toList(),
                ))
        ],
      ),
    );
  }
}
