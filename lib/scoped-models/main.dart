import 'package:scoped_model/scoped_model.dart';
import './user.dart';
import './products.dart';
import './common.dart';

class MainModel extends Model with CommonModel, ProductsModel, UserModel {}
