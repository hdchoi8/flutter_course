import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../helper/ensure-visible.dart';
import '../models/product.dart';
// import '../scoped-models/products.dart';
import '../scoped-models/main.dart';
import '../widgets/form_inputs/location.dart';

class ProductEditpage extends StatefulWidget {
  final bool isCreateMode;

  ProductEditpage([this.isCreateMode]);

  @override
  State<StatefulWidget> createState() {
    return _ProductEditpageState();
  }
}

class _ProductEditpageState extends State<ProductEditpage> {
  Map<String, dynamic> _formdata = {
    'title': "",
    'description': "",
    'price': 0.0,
    'image': ""
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  Widget _buildNameTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        focusNode: _titleFocusNode,
        decoration: InputDecoration(labelText: '제품명'),
        onSaved: (String value) {
          print("form saved : product Name");
          _formdata['title'] = value;
        },
        initialValue: product == null ? "" : product.title,
        validator: (String value) {
          if (value.isEmpty) {
            return '제품명을 입력해주세요.';
          }
        },
      ),
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        decoration: InputDecoration(labelText: '제품설명'),
        maxLines: 4,
        initialValue: product == null ? "" : product.description,
        onSaved: (String value) {
          print("form saved : product Description");
          _formdata['description'] = value;
        },
      ),
    );
  }

  Widget _buildPriceTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        focusNode: _priceFocusNode,
        decoration: InputDecoration(labelText: '가격'),
        keyboardType: TextInputType.number,
        initialValue: product == null ? "" : product.price.toString(),
        onSaved: (String value) {
          print("form saved : product Price");
          _formdata['price'] = double.parse(value);
          _formdata['image'] =
              "https://www.friars.co.uk/images/lindt-gold-milk-chocolate-bar-p504-7263_image.jpg";
        },
      ),
    );
  }

  void _onSubmitForm(MainModel model) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    Product product = model.selectedProduct;
    _formKey.currentState.save();

    Product newProduct = new Product(
        id: product == null ? "" : product.id,
        title: _formdata['title'],
        description: _formdata['description'],
        price: _formdata['price'],
        image: _formdata['image'],
        userID: model.authenticatedUser.id,
        userEmail: model.authenticatedUser.email);

    if (product == null) {
      bool isSuccess = await model.addProduct(newProduct);
      if (isSuccess) {
        model.selectProduct(null);
        Navigator.pushReplacementNamed(context, "/products");
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Something went wrong"),
              content: Text("Please try again"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Okey"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      model.updateProduct(newProduct).then((String data) {
        Navigator.pushReplacementNamed(context, "/products");
      });
    }
  }

  Widget _buildSubmitButton(BuildContext context, MainModel model) {
    return RaisedButton(
      color: Theme.of(context).accentColor,
      textColor: Colors.white,
      child: Text("SAVE"),
      onPressed: () => _onSubmitForm(model),
    );
  }

  Widget _buildProductEditBody(BuildContext context, MainModel model) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double paddingWidth = deviceWidth - targetWidth;
    Product product = model.selectedProduct;
    if (model.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
            width: targetWidth,
            margin: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: paddingWidth / 2),
                children: <Widget>[
                  _buildNameTextField(product),
                  _buildDescriptionTextField(product),
                  _buildPriceTextField(product),
                  SizedBox(
                    height: 10.0,
                  ),
                  LocationInput(),
                  SizedBox(height: 10.0),
                  _buildSubmitButton(context, model)
                ],
              ),
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("product_edit: build");
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        if (widget.isCreateMode == true) {
          model.selectProduct(null); // 아무것도 선택이 안된 것으로 셋팅한다.
        }
        Product product = model.selectedProduct;
        if (product != null) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Edit Product"),
            ),
            body: _buildProductEditBody(context, model),
          );
        } else {
          return _buildProductEditBody(context, model);
        }
      },
    );
  }
}
