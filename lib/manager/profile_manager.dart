import 'package:flutter/material.dart';
import 'package:untitled/model/vendor.dart';
import '../model/staff.dart';

class ProfileManager extends ChangeNotifier {
  StaffDTO staffDTO = StaffDTO();
  VendorRegistrationRequest vendorRegistrationRequest = VendorRegistrationRequest();
  bool _isEnable = false;

  bool get isEnable => _isEnable;

  set isEnable(bool val) {
    _isEnable = val;
    notifyListeners();
  }

}