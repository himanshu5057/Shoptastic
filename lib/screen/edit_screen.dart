import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/edit_detail_screen.dart';
import '../provider/products.dart';

class EditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed('./add-screen');
              })
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, i) => EditDetailScreen(products.prods[i].id,
            products.prods[i].title, products.prods[i].imageURL),
        itemCount: products.prods.length,
      ),
    );
  }
}
