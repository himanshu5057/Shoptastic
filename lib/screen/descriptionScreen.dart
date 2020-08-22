import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';
class DescriptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productid=ModalRoute.of(context).settings.arguments as String;
    final loadedProduct= Provider.of<Products>(context,listen: false).findById(productid);
    return Scaffold(
      appBar: AppBar(title: Text(loadedProduct.title),),
    );
  }
}