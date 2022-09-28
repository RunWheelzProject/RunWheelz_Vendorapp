import 'package:flutter/material.dart';
import 'package:untitled/model/customer.dart';
import 'package:untitled/services/staff_service.dart';

import '../model/role.dart';
import '../model/staff.dart';

class VendorWorksManager extends ChangeNotifier {
  bool _isAdmin = false;
  bool _isMarketingAgent = false;
  bool _isVendor = false;

  bool get isAdmin => _isAdmin;
  bool get isVendor => _isVendor;
  bool get isMarketingAgent => _isMarketingAgent;


  set isAdmin(bool val) {
    _isAdmin = val;
    notifyListeners();
  }


  set isVendor(bool val) {
    _isVendor = val;
    notifyListeners();
  }


  set isMarketingAgent(bool val) {
    _isMarketingAgent = val;
    notifyListeners();
  }
}