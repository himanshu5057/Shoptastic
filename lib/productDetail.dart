import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './auth.dart';
import './provider/product.dart';
import './provider/cart.dart';

class ProductDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductModal>(context);
    final auth = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed('./description-screen', arguments: product.id);
        },
        child: Image.network(
          product.imageURL,
          fit: BoxFit.cover,
        ),
      ),
      footer: GridTileBar(
        title: Text(
          product.title,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.black54,
        leading: IconButton(
          icon: Icon(product.fav ? Icons.favorite : Icons.favorite_border),
          onPressed: () => product.toggleFav(
              Provider.of<Auth>(context, listen: false).token, auth.userId),
          color: Theme.of(context).accentColor,
        ),
        trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () async {
              cart.addItem(
                  product.id, product.title, cart.value, product.price);

              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Item is added to cart"),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      cart.undo(product.id);
                    }),
              ));
            },
            color: Colors.indigoAccent),
      ),
    );
  }
}
