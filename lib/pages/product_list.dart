import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './product_edit.dart';
import '../models/product.dart';
import '../scoped-models/main.dart';

class ProductListPage extends StatelessWidget {
  Widget _buildProductListTile(
      BuildContext context, int index, Product product, MainModel model) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.image),
      ),
      title: Text(product.title),
      subtitle: Text('\$${product.price.toString()}'),
      trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            model.selectProduct(product.id);
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ProductEditpage(),
              ),
            );
          }),
    );
  }

  Widget _productListViewBuilder(
      BuildContext context, int index, MainModel model) {
    Product product = model.products[index];
    return Dismissible(
      key: Key(product.title),
      background: Container(color: Colors.red),
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
          model.selectProduct(product.id);
          model.deleteProduct();
        }
      },
      child: Column(
        children: <Widget>[
          _buildProductListTile(context, index, product, model),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildProductListView(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _productListViewBuilder(context, index, model);
          },
          itemCount: model.products.length,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildProductListView(context);
  }
}
