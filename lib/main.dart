import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './add_detail.dart';
import './auth.dart';
import './provider/cart.dart';
import './provider/order_item.dart';
import './screen/auth_screen.dart';
import './screen/cartScreen.dart';
import './screen/edit_screen.dart';
import './screen/order_screen.dart';
import './screen/descriptionScreen.dart';
import './provider/products.dart';
import './screen/productsScreen.dart';

void main() {
  runApp(MainScreen());
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Products>(
            update: (_, auth, prdcts) => Products(
                  auth.token,
                  auth.userId,
                )),

        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(value: Orders()),
      ],
      child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
                theme: ThemeData(
                    primarySwatch: Colors.teal, accentColor: Colors.red[400]),
                title: 'myShop',
                home: auth.token != null
                    ? ProductScreen()
                    : FutureBuilder(
                        future: auth.autoLogin(),
                        builder: (ctx, authResult) =>
                            authResult.connectionState ==
                                    ConnectionState.waiting
                                ? Icon(Icons.timer)
                                : AuthScreen()),
                routes: {
                  './product-screen': (context) => ProductScreen(),
                  './description-screen': (context) => DescriptionScreen(),
                  './cart-screen': (context) => CartScreen(),
                  './order-screen': (context) => OrderScreen(),
                  './edit-screen': (context) => EditScreen(),
                  './add-screen': (context) => AddDetails(),
                  './auth-screen': (context) => AuthScreen(),
                },
              )),
    );
  }
}
