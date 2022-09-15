import 'package:flutter/material.dart';
import 'package:untitled/model/customer.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/model/vendor_mechanic.dart';
import '../model/staff.dart';

class ProfileManager extends ChangeNotifier {
  StaffDTO staffDTO = StaffDTO();
  VendorDTO vendorDTO = VendorDTO();
  VendorMechanic vendorMechanic = VendorMechanic();
  CustomerDTO customerDTO = CustomerDTO();
  bool _isEnable = false;

  bool get isEnable => _isEnable;

  set isEnable(bool val) {
    _isEnable = val;
    notifyListeners();
  }

}