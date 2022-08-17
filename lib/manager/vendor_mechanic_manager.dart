import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/model/places_search.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/services/vendor_registration.dart';

import '../model/role.dart';

class VendorMechanicManager extends ChangeNotifier {
  late VendorRegistrationRequest vendorRegistrationRequest = VendorRegistrationRequest();

  List<VendorRegistrationRequest> _vendorList = [];
  List<VendorRegistrationRequest> _filteredList = [];
  bool _isRegistered = true;
  bool _isEnabled = false;


  VendorManager() {
    VendorRegistrationService().getAllVendor().then((staff) {
      for (VendorRegistrationRequest item in staff) {
        _vendorList.add(item);
      }
      notifyListeners();
    });
    getRegisteredList();
  }

  void getRegisteredList() {
    _filteredList = [];
    for (VendorRegistrationRequest item in _vendorList) {
      if (item.registrationStatus == true) _filteredList.add(item);
    }
    notifyListeners();
  }

  void getNotRegisteredList() {
    _filteredList = [];
    for (VendorRegistrationRequest item in _vendorList) {
      if (item.registrationStatus == false) _filteredList.add(item);
    }
    notifyListeners();
  }


  List<VendorRegistrationRequest> get vendorList => _vendorList;
  get _vendorRegistrationRequest => vendorRegistrationRequest;

  List<VendorRegistrationRequest> get filteredList => _filteredList;
  bool get isRegistered => _isRegistered;
  bool get isEnabled => _isEnabled;
  set isRegistered(bool val) => _isRegistered = val;
  set isEnabled(bool val) {
    _isEnabled = val;
    notifyListeners();
  }

}