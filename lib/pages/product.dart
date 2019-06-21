import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_course/widgets/ui_elements/title_default.dart';
import '../widgets/ui_elements/title_default.dart';
import '../models/product.dart';
import '../scoped-models/main.dart';

class ProductPage extends StatelessWidget {
  final String _productId;

  ProductPage(this._productId);

  _showWarningDiaglog(BuildContext context, MainModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure?"),
          content: Text("This action cannot be undone!!!"),
          actions: <Widget>[
            FlatButton(
              child: Text("DISCARD"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("CONTINUE"),
              onPressed: () {
                model.deleteProduct().then((String result) {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                });
              },
            )
          ],
        );
      },
    );
  }

  Widget _buildAddressPriceRow(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Union Square, San Francisco',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            "|",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          '\$' + product.price.toString(),
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        )
      ],
    );
  }

  Widget _buildScaffoldBody(BuildContext context, MainModel model) {
    model.selectProduct(_productId);
    final Product product = model.selectedProduct;
    return Center(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Image.network(product.image),
        Container(
          padding: EdgeInsets.all(10.0),
          child: TitleDefault(product.title),
        ),
        _buildAddressPriceRow(product),
        SizedBox(
          height: 5.0,
        ),
        Text(product.userEmail),
        Container(
          padding: EdgeInsets.all(10.0),
          child: RaisedButton(
            color: Theme.of(context).accentColor,
            child: Text("Delete"),
            onPressed: () => _showWarningDiaglog(context, model),
          ),
        )
      ]),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        model.selectProduct(_productId);
        final Product product = model.selectedProduct;
        return Scaffold(
          appBar: AppBar(
            title: Text(product.title),
          ),
          body: _buildScaffoldBody(context, model),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          print("Back Button Pressed");
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: _buildScaffold(context));
  }
}
