import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';

mixin CommonModel on Model {
  final String productsUrl =
      "https://flutter-course-551dc.firebaseio.com/products.json";
  final String productRootUrl =
      "https://flutter-course-551dc.firebaseio.com/products/";
  final String appKey = "AIzaSyBE3Ib8ltXiyGFySfGHKK0z51woF7D_3ys";
  final String _signUpUrl =
      "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=";
  String _signInUrl =
      "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=";
  bool isLoading = false;
  User authUser;

  String get signUpUrl {
    return _signUpUrl + appKey;
  }

  String get signInUrl {
    return _signInUrl + appKey;
  }

  Product convertMapToProduct(Map<String, dynamic> productMap) {
    Product product = new Product(
        id: productMap['id'],
        title: productMap['title'],
        description: productMap['description'],
        price: productMap['price'],
        image: productMap['image'],
        isFavorite: productMap['isFavorite'],
        userID: productMap['userID'],
        userEmail: productMap['userEmail']);
    return product;
  }

  Map<String, dynamic> convertProductToMap(Product product) {
    Map<String, dynamic> productMap = new Map();
    productMap['id'] = product.id;
    productMap['title'] = product.title;
    productMap['description'] = product.description;
    productMap['price'] = product.price;
    productMap['image'] = product.image;
    productMap['isFavorite'] = product.isFavorite;
    productMap['userID'] = product.userID;
    productMap['userEmail'] = product.userEmail;
    return productMap;
  }

  User get authenticatedUser {
    return authUser;
  }

  void set authenticatedUser(User user) {
    authUser = user;
  }
}
