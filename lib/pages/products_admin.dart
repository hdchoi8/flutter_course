import 'package:flutter/material.dart';
import './product_edit.dart';
import './product_list.dart';
import '../widgets/ui_elements/logout_list_tile.dart';

class ProductsAdminPage extends StatelessWidget {
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          automaticallyImplyLeading: false,
          title: Text("Choose"),
        ),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text("All Products"),
          onTap: () {
            Navigator.pushReplacementNamed(context, "/products");
          },
        ),
        Divider(),
        LogoutListTile(),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildDrawer(context),
        appBar: AppBar(
            title: Text("Manage Products"),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.create), text: 'Create Product'),
                Tab(icon: Icon(Icons.list), text: 'My Products'),
              ],
            )),
        body: TabBarView(
          children: <Widget>[ProductEditpage(true), ProductListPage()],
        ),
      ),
    );
  }
}
