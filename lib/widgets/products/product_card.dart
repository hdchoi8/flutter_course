import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './price_tag.dart';
import '../ui_elements/title_default.dart';
import './address_tag.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';

class ProductCard extends StatelessWidget {
  final Product _product;

  ProductCard(this._product);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(_product.image),
            height: 300.0,
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/food.jpg'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TitleDefault(_product.title),
              SizedBox(width: 8.0),
              PriceTag(_product.price.toString()),
            ],
          ),
          AddressTag("서울시 분당구"),
          SizedBox(height: 5.0),
          Container(
            decoration: BoxDecoration(
                color: Colors.purple,
                gradient: LinearGradient(
                    colors: [Colors.red, Colors.cyan],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft),
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                    color: Colors.green, width: 5.0, style: BorderStyle.solid)),
            child: Text(_product.description,
                style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 5.0),
          Text(_product.userEmail),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.pushNamed<bool>(context, '/product/' + _product.id);
                },
              ),
              ScopedModelDescendant<MainModel>(
                builder: (BuildContext context, Widget child, MainModel model) {
                  return IconButton(
                    icon: _product.isFavorite == true
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    color: Colors.red,
                    onPressed: () {
                      model.selectProduct(_product.id);
                      model.toggleFavoriteStatus();
                    },
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
