import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../models/auth.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _emailValue;
  String _passwordValue;
  String _confirmPasswordValue;
  bool _acceptTerms = false;
  AuthMode _authMode = AuthMode.Login;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DecorationImage _buildDecorationImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
        image: AssetImage('assets/background.jpg'));
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      autofocus: true,
      decoration: InputDecoration(
          labelText: 'Email', fillColor: Colors.grey[300], filled: true),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        String p =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

        if (value.isEmpty) {
          return "Email을 입력해주세요.";
        } else if (!RegExp(p).hasMatch(value.trim())) {
          return "잘못된 이메일 형식입니다.";
        }
      },
      onSaved: (value) {
        _emailValue = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      obscureText: true,
      onSaved: (value) {
        _passwordValue = value;
      },
      validator: (String value) {
        if (value.length < 5) {
          return "패스워드는 다섯자 이상이어야 합니다.";
        }
      },
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirm Password',
          fillColor: Colors.grey[300],
          filled: true),
      obscureText: true,
      onSaved: (value) {
        _confirmPasswordValue = value;
      },
      validator: (String value) {
        if (value.length < 5) {
          return "패스워드는 다섯자 이상이어야 합니다.";
        }
      },
    );
  }

  Widget _buildAcceptSwitchListTile() {
    return SwitchListTile(
      onChanged: (bool value) {
        setState(() {
          _acceptTerms = value;
        });
      },
      value: _acceptTerms,
      title: Text("Accept Terms"),
    );
  }

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate() || !_acceptTerms) {
      return null;
    }
    _formKey.currentState.save();

    Map<String, dynamic> resultData;
    resultData = await authenticate(_emailValue, _passwordValue, _authMode);

    if (resultData['successCode']) {
      Navigator.pushReplacementNamed(context, "/products");
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                _authMode == AuthMode.Login ? "LogIn Error" : "SignUp Error"),
            content: Text(resultData['msg']),
            actions: <Widget>[
              FlatButton(
                child: Text("Okey"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 550 : deviceWidth * 0.95;

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Container(
          width: targetWidth,
          decoration: BoxDecoration(
            image: _buildDecorationImage(),
          ),
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildEmailTextField(),
                    SizedBox(height: 5.0),
                    _buildPasswordTextField(),
                    SizedBox(height: 5.0),
                    _authMode == AuthMode.Signup
                        ? _buildConfirmPasswordTextField()
                        : Container(),
                    SizedBox(height: 5.0),
                    _buildAcceptSwitchListTile(),
                    FlatButton(
                      child: Text(_authMode == AuthMode.Signup
                          ? "Swith To Login"
                          : "Switch To SignUp"),
                      onPressed: () {
                        setState(() {
                          _authMode = _authMode == AuthMode.Signup
                              ? AuthMode.Login
                              : AuthMode.Signup;
                        });
                      },
                    ),
                    ScopedModelDescendant<MainModel>(builder:
                        (BuildContext context, Widget child, MainModel model) {
                      return model.isLoading == true
                          ? CircularProgressIndicator()
                          : RaisedButton(
                              child: Text(_authMode == AuthMode.Login
                                  ? "LOGIN"
                                  : "SIGNUP"),
                              color: Theme.of(context).accentColor,
                              onPressed: () => _submitForm(model.authenticate),
                            );
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
