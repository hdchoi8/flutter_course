import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import './common.dart';

mixin ProductsModel on CommonModel {
  List<Product> _products = new List<Product>();
  // int _selectedProductIndex;
  String _selectedProductId;
  bool _displayOnlyFavorites = false;

  List<Product> get products {
    return List.from(_products);
  }

  void selectProduct(String productId) {
    if (productId == null) {
      _selectedProductId = null;
      return;
    }
    Product product = _products.firstWhere((Product p) {
      return p.id == productId;
    });
    if (product != null) {
      _selectedProductId = productId;
    } else {
      _selectedProductId = null;
    }
  }

  String get selectedProductId {
    return _selectedProductId;
  }

  bool get displayOnlyFavorites {
    return _displayOnlyFavorites;
  }

  void toggleDisplayOnlyFavorites() {
    _displayOnlyFavorites = !_displayOnlyFavorites;
    notifyListeners();
  }

  List<Product> get displayProductsList {
    if (_displayOnlyFavorites) {
      return List.from(
          _products.where((Product product) => product.isFavorite).toList());
    } else {
      return List.from(_products);
    }
  }

  Product get selectedProduct {
    if (_selectedProductId == null) {
      return null;
    } else {
      return _products[selectedProductIdx];
    }
  }

  int get selectedProductIdx {
    if (_selectedProductId == null) {
      return null;
    } else {
      return _products.indexWhere((Product p) {
        return p.id == _selectedProductId;
      });
    }
  }

  Future<bool> addProduct(Product product) async {
    Map<String, dynamic> productMapData = convertProductToMap(product);
    isLoading = true;
    notifyListeners();
    String url = "$productsUrl?auth=${authenticatedUser.token}";
    var response = await http.post(url, body: json.encode(productMapData));

    int statusCode = response.statusCode;

    if (![200, 201].contains(statusCode)) {
      isLoading = false;
      notifyListeners();
      return false;
    }
    Map<String, dynamic> responseMap = json.decode(response.body);
    print(response.body);
    product.id = responseMap['name'];
    final Product newProduct = new Product(
        id: responseMap['name'],
        title: product.title,
        description: product.description,
        image: product.image,
        price: product.price,
        userEmail: product.userEmail,
        userID: product.userID);
    _products.add(newProduct);
    _selectedProductId = null;
    isLoading = false;
    notifyListeners();
    return true;
  }

  Future<String> updateProduct(Product product) async {
    Map<String, dynamic> productMap = convertProductToMap(product);
    isLoading = true;
    String pUrl =
        "$productRootUrl/${product.id}.json?auth=${authenticatedUser.token}";
    var data = await http.put(pUrl, body: json.encode(productMap));
    isLoading = false;
    _products[selectedProductIdx] = product;
    notifyListeners();
    return "Success";
  }

  Future<String> deleteProduct() async {
    if (_selectedProductId == null) {
      return "No operation";
    }
    Product product = _products.firstWhere((Product p) {
      return p.id == _selectedProductId;
    });
    String pUrl =
        "${productRootUrl}/${product.id}.json?auth=${authenticatedUser.token}";
    isLoading = true;
    _products.removeAt(selectedProductIdx);
    _selectedProductId = null;
    notifyListeners();
    var data = await http.delete(pUrl);
    isLoading = false;
    notifyListeners();
    return "Success";
  }

  void toggleFavoriteStatus() async {
    _products[selectedProductIdx] = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        isFavorite: !selectedProduct.isFavorite,
        userEmail: selectedProduct.userEmail,
        userID: selectedProduct.userID);
    String data = await updateProduct(_products[selectedProductIdx]);
    _selectedProductId = null;
    notifyListeners();
  }

  Future<bool> fetchProducts() async {
    print("fetchProducts....");
    if (authenticatedUser == null) {
      return false;
    }
    isLoading = true;
    notifyListeners();
    String url = "$productsUrl?auth=${authenticatedUser.token}";
    var response = await http.get(url);
    print(response.body);
    Map<String, dynamic> productsMapList = json.decode(response.body);
    List<Product> productsList = new List<Product>();
    if (productsMapList == null) {
      _products = null;
    } else {
      productsMapList.forEach((String productid, dynamic productMap) {
        Product product;
        product = convertMapToProduct(productMap);
        product.id = productid;
        productsList.add(product);
      });
      _products = productsList;
      print("fetchProducts : products length(${_products.length})");
    }
    isLoading = false;
    notifyListeners();
    return true;
  }
}
