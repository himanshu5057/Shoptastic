import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Hello Friends"),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () {
              Navigator.of(context).pushNamed('./product-screen');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Cart"),
            onTap: () {
              Navigator.of(context).pushNamed("./cart-screen");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () {
              Navigator.of(context).pushNamed("./order-screen");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Edit Products"),
            onTap: () {
              Navigator.of(context).pushNamed("./edit-screen");
            },
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                    Navigator.of(context).pop();
                    Provider.of<Auth>(context,listen: false).logout();
                  })
        ],
      ),
    );
  }
}
