import 'package:flutter/material.dart';
import './provider/product.dart';
import 'package:provider/provider.dart';
import './provider/products.dart';

class AddDetails extends StatefulWidget {
  @override
  _AddDetailsState createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageurlFocusNode = FocusNode();
  bool change = true;
  bool saveState = false;
  var _imageURLcontroller = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = ProductModal(
      id: null, title: '', description: '', imageURL: '', price: 0);
  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  Future<void> saveForm() async {
    _form.currentState.validate();
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    setState(() {
      saveState = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error ocured'),
                  content: Text('Something went wrong'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK'))
                  ],
                ));
      }
    }
    setState(() {
      saveState = false;
    });

    Navigator.of(context).pop();
  }

  @override
  initState() {
    _imageurlFocusNode.addListener(() {
      if (!_imageurlFocusNode.hasFocus) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageurlFocusNode.dispose();
    _imageURLcontroller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (change) {
      final id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        _editedProduct = Provider.of<Products>(context).findById(id);
        initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
        };
        _imageURLcontroller.text = _editedProduct.imageURL;
      }
    }
    change = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Enter Details"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  saveForm();
                })
          ],
        ),
        body: Form(
          key: _form,
          child: Stack(children: <Widget>[
            if (saveState)
              Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            Padding(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  TextFormField(
                      initialValue: _editedProduct.title,
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return ('Please enter the Title');
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = ProductModal(
                            id: _editedProduct.id,
                            title: value,
                            description: _editedProduct.description,
                            imageURL: _editedProduct.imageURL,
                            price: _editedProduct.price,
                            fav: _editedProduct.fav);
                      }),
                  TextFormField(
                      initialValue: _editedProduct.price.toString(),
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the Price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter the valid value';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Enter a number greater than 0 ';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = ProductModal(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageURL: _editedProduct.imageURL,
                            fav: _editedProduct.fav,
                            price: double.parse(value));
                      }),
                  TextFormField(
                      initialValue: _editedProduct.description,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Description can't be empty";
                        }
                        if (value.length <= 10) {
                          return 'Description has to be atleast 10 characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = ProductModal(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            fav: _editedProduct.fav,
                            description: value,
                            imageURL: _editedProduct.imageURL,
                            price: _editedProduct.price);
                      }),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        padding: EdgeInsets.fromLTRB(3, 5, 0, 0),
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: Colors.grey[600])),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: FittedBox(
                            child: _imageURLcontroller.text.isEmpty
                                ? Text(
                                    "Enter the correct URL",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Image.network(_imageURLcontroller.text),
                          ),
                        ),
                      ),
                      SizedBox(width: 3),
                      Expanded(
                          child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageURLcontroller,
                              focusNode: _imageurlFocusNode,
                              onFieldSubmitted: (_) {
                                saveForm();
                              },
                              onSaved: (value) {
                                _editedProduct = ProductModal(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    fav: _editedProduct.fav,
                                    description: _editedProduct.description,
                                    imageURL: value,
                                    price: _editedProduct.price);
                              }))
                    ],
                  )
                ],
              ),
            ),
          ]),
        ));
  }
}
