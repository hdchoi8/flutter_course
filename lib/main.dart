import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:map_view/map_view.dart';

import './pages/products.dart';
import './pages/products_admin.dart';
import './pages/product.dart';
import './pages/auth.dart';
import './scoped-models/main.dart';

const API_KEY = "AIzaSyBq-yjGMlSyF4hcKq3vJVq-XlHNvyRDBVk";
void main() {
  MapView.setApiKey(API_KEY);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();

  @override
  void initState() {
    _model.autoAuthenticate();
    super.initState();
  }

  Widget _buildMaterialApp(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple,
          brightness: Brightness.light),
      // home: AuthPage(),
      routes: {
        '/': (BuildContext context) {
          return ScopedModelDescendant(
            builder: (BuildContext context, Widget child, MainModel model) {
              return model.authenticatedUser == null
                  ? AuthPage()
                  : ProductsPage(_model);
            },
          );
        },
        '/products': (BuildContext context) => ProductsPage(_model),
        '/admin': (BuildContext context) => ProductsAdminPage()
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'product') {
          final String productId = pathElements[2];
          return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductPage(productId));
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => ProductsPage(_model));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        child: _buildMaterialApp(context), model: _model);
  }
}
