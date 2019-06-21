import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './product_card.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';

class Products extends StatelessWidget {
  final MainModel model;

  Products(this.model);

  Widget _buildProductlist(BuildContext context, MainModel model) {
    Widget productCard;
    int products_count = 0;
    List<Product> products = model.displayProductsList;
    if (!(products == null || products.length == 0)) {
      products_count = products.length;
    }
    if (products_count > 0) {
      productCard = ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              ProductCard(products[index]),
          itemCount: products_count);
    } else {
      productCard = Center(child: Text("No products found, please add some"));
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    print("[Product Widget] build()");

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildProductlist(context, model);
      },
    );
  }
}
