import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/products/products.dart';
import '../scoped-models/main.dart';
import '../widgets/ui_elements/logout_list_tile.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;

  ProductsPage(this.model);

  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    print("ProductPage initState....");
    if (widget.model.authenticatedUser == null) {
      Navigator.of(context).pushReplacementNamed("/");
    }
    widget.model.fetchProducts();
    super.initState();
  }

  Widget _buildProductsList(MainModel model) {
    Widget contents = Center(child: Text("No Product List!!!"));
    if (model.displayProductsList.length > 0 && !model.isLoading) {
      contents = Products(model);
    } else if (model.isLoading) {
      contents = Center(
        child: CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(onRefresh: model.fetchProducts, child: contents);
  }

  @override
  Widget build(BuildContext context) {
    print("products : build()");
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text("Choose"),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage Products'),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/admin");
              },
            ),
            LogoutListTile(),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("EasyList"),
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
            return IconButton(
              icon: Icon(model.displayOnlyFavorites
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () {
                model.toggleDisplayOnlyFavorites();
              },
            );
          })
        ],
      ),
      body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return _buildProductsList(model);
        },
      ),
    );
  }
}
