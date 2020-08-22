import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth.dart';
import '../order_detail.dart';
import '../provider/order_item.dart';
import '../screen/main_drawer.dart';

class OrderScreen extends StatelessWidget {
  // bool init = true;
  // bool loading = false;
  // @override
  // void didChangeDependencies() async {
  //   if (init) {
  //     setState(() {
  //       loading = true;
  //     });
  //     await Provider.of<Orders>(context).fetch();
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  //   init = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    // final order = Provider.of<Orders>(context);
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text("Orders"),
        ),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false)
              .fetch(Provider.of<Auth>(context, listen: false).token,Provider.of<Auth>(context, listen: false).userId),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(child: Text("something is wrong"));
              } else {
                return Consumer<Orders>(
                  builder: (ctx, order, child) => ListView.builder(
                      itemCount: order.orders().length,
                      itemBuilder: (ctx, i) => OrderDetail(order.orders()[i])),
                );
              }
            }
          },
        ));
  }
}
