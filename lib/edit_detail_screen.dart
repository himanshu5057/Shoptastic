import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/products.dart';

class EditDetailScreen extends StatelessWidget {
  final String id;
  final String title;
  final String imageurl;
  EditDetailScreen(this.id, this.title, this.imageurl);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageurl),
        ),
        title: Text(title),
        trailing: Container(
          width: 110,
          child: Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(5)),
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('./add-screen', arguments: id);
                  }),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    Provider.of<Products>(context, listen: false).delete(id);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
