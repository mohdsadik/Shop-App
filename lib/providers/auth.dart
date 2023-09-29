import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/splashscreen.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token = '';
  DateTime _expiryDate = DateTime.now();
  String _userId = '';
  Timer _authTimer = Timer(Duration(seconds: 0), () {});

  bool get isAuth {
    return _token.isNotEmpty;
  }

  String? get token {
    if (_expiryDate.isAfter(DateTime.now()) && _token.isNotEmpty) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(String email, String password, String urlSegment,
      BuildContext context) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDYTxSVLEoEXgPQEhuwhevMdw9yR6iaOzg');
    print("Before Try Block");
    try {
      print("In Try Block");
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      print("After Response");
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(responseData['expiresIn'])),
      );
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return SplashScreen();
      }));
      _autoLogout(context);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(
      String email, String password, BuildContext context) async {
    return _authenticate(email, password, 'signUp', context);
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    return _authenticate(email, password, 'signInWithPassword', context);
  }

  void logout(BuildContext context) {
    _token = '';
    _userId = '';
    _expiryDate = DateTime.now();

    _authTimer.cancel();
    notifyListeners();

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return AuthScreen();
    }));
  }

  void _autoLogout(BuildContext context) {
    _authTimer.cancel();

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), () {
      logout(context);
    });
  }
}
