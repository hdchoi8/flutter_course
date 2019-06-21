import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import './common.dart';
import '../models/auth.dart';

mixin UserModel on CommonModel {
  Timer _authTimer;

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode authMode = AuthMode.Login]) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    print("signIp: authdata = ${authData}");
    isLoading = true;
    notifyListeners();
    String url = authMode == AuthMode.Login ? signInUrl : signUpUrl;

    http.Response response = await http.post(
      url,
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'},
    );
    isLoading = false;
    notifyListeners();
    Map<String, dynamic> responseData = json.decode(response.body);
    String msg = authMode == AuthMode.Login
        ? "Login Successfully!!!"
        : "SignUp Successfully!!";

    bool successCode = false;
    if (responseData.containsKey('idToken')) {
      successCode = true;
      authenticatedUser = User(
          email: email,
          id: responseData['localid'],
          token: responseData['idToken']);

      int expiryTimeSeconds = int.parse(responseData['expiresIn']);
      autoLogOutTimeOut(expiryTimeSeconds);
      DateTime now = DateTime.now();
      DateTime timeToExpiry = now.add(Duration(seconds: expiryTimeSeconds));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("email", email);
      prefs.setString("id", responseData['localid']);
      prefs.setString("token", responseData['idToken']);
      prefs.setString("expiryTime", timeToExpiry.toIso8601String());
    } else {
      if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
        msg = "Unknown Email";
      } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
        msg = "Invalid password";
      } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
        msg = "Same Email alreay Exists!!!";
      } else {
        msg = "Somethin went wrong";
      }
    }
    print("signIn : ${json.decode(response.body)}");

    return {"successCode": successCode, 'msg': msg};
  }

  void autoAuthenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    if (token != null) {
      String email = prefs.getString('email');
      String id = prefs.getString('id');
      DateTime timeToExpiry =
          DateTime(int.parse(prefs.getString("expiryTime")));
      DateTime now = DateTime.now();

      if (timeToExpiry.isBefore(now)) {
        logOut();
        _authTimer.cancel();
      }
      authenticatedUser = User(email: email, id: id, token: token);
    }
  }

  void logOut() async {
    print("LogOut");
    authenticatedUser = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('email');
    prefs.remove('id');
  }

  void autoLogOutTimeOut(int timeOut) {
    _authTimer = Timer(Duration(seconds: timeOut), logOut);
    notifyListeners();
  }
}
