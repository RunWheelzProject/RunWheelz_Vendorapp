import 'package:flutter/material.dart';
import '../resources/resources.dart' as res;


class LogInManager extends ChangeNotifier {

  final Map<String, List<String>> _selectURL = {
    "userLogIn": [
      "${res.APP_URL}/api/auth/login/sendotp?",
      "${res.APP_URL}/api/auth/login/verifyotp"
    ],
    "vendorRegistration": [
      "${res.APP_URL}/api/auth/register/vendor/sendOtp?",
      "${res.APP_URL}/api/auth/register/vendor/verifyotp"
    ],
    "staffRegistration": [
      "${res.APP_URL}/api/auth/register/runwheelz/staff/sendOtp?",
      "${res.APP_URL}/api/auth/register/runwheelz/staff/verifyotp"
    ],
    "mechanicRegistration": [
      "${res.APP_URL}/api/auth/register/vendor/mechanic/sendOtp?",
      "${res.APP_URL}/api/auth/register/vendor/mechanic/verifyotp"
    ],
  };

  late List<String>? _currentURLs = [];

  void setCurrentURLs(String urlType) {
    _currentURLs = _selectURL[urlType];
    notifyListeners();
  }

  List<String>? get currentURLs => _currentURLs;

}
