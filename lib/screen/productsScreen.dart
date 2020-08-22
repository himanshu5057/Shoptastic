import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
import '../provider/products.dart';
import '../screen/main_drawer.dart';
import '../productDetail.dart';
import '../badge.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool favs = false;
  bool changed = true;
  bool loading = false;
  @override
  void didChangeDependencies() {
    try{if (changed) {
      setState(() {
        loading = true;
      });
      Provider.of<Products>(context).fetchProductsData().then((_) {
        if(mounted){
        setState(() {
          loading = false;
        });
      }});
    }
    changed = false;
    super.didChangeDependencies();
  }catch(error){
    // print(error);
    throw error;
  }}

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final loadedProduct = favs ? productData.favs : productData.items;
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(title: Text("MyShop"), actions: <Widget>[
        PopupMenuButton(
          itemBuilder: (_) => [
            PopupMenuItem(
                child: ListTile(
              leading: Text("All Products"),
              onTap: () {
                setState(() {
                  favs = false;
                });
              },
            )),
            PopupMenuItem(
                child: ListTile(
              leading: Text("Favourites"),
              onTap: () {
                setState(() {
                  favs = true;
                });
              },
            ))
          ],
        ),
        Badge(
            child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pushNamed(context, './cart-screen')),
            value: cart.value.toString())
      ]),
      body: loading
          ? Align(
              alignment: Alignment.center, child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 15 / 14,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemBuilder: (ctx, i) {
                return ChangeNotifierProvider.value(
                    value: loadedProduct[i], child: ProductDetail());
              },
              itemCount: loadedProduct.length,
            ),
    );
  }
}
