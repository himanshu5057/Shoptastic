import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expTime;

  String _userId;
  Timer _authTimer;

  String get userId {
    return _userId;
  }

  String get token {
    if (_token != null &&
        _expTime.isAfter(DateTime.now()) &&
        _expTime != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    var url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAZm2UhgG8WCA-iRJeKCZL0CgGo6e4kkcQ';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      // print(json.decode(response.body));
      _token = json.decode(response.body)['idToken'];
      _expTime = DateTime.now().add(Duration(
          seconds: int.parse(json.decode(response.body)['expiresIn'])));
      _userId = json.decode(response.body)['localId'];
      if (json.decode(response.body)['error'] != null) {
        throw json.decode(response.body)['error']['message'].toString();
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      var url =
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAZm2UhgG8WCA-iRJeKCZL0CgGo6e4kkcQ';
      var response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      _token = json.decode(response.body)['idToken'];
      _expTime = DateTime.now().add(Duration(
          seconds: int.parse(json.decode(response.body)['expiresIn'])));
      _userId = json.decode(response.body)['localId'];
      autoLogout();

      if (json.decode(response.body)['error'] != null) {
        throw json.decode(response.body)['error']['message'].toString();
      }
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userLoginData = json.encode({
        'token': _token,
        'userId': _userId,
        'expTime': _expTime.toIso8601String(),
      });
      prefs.setString('userLoginData', userLoginData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expTime = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final expiry = _expTime.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expiry), logout);
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userLoginData')) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userLoginData')) as Map<String, dynamic>;
    if (DateTime.now().isAfter(DateTime.parse(extractedData['expTime']))) {
      return false;
    }
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expTime = extractedData['expTime'];
    notifyListeners();
    autoLogout();
    return true;
  }
}
