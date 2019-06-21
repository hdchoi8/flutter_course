import 'package:flutter/material.dart';

class Product {
  String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final bool isFavorite;
  final String userID;
  final String userEmail;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      @required this.userID,
      @required this.userEmail,
      this.isFavorite = false});
}
