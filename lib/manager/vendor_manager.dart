import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/model/places_search.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/services/vendor_registration.dart';

import '../model/role.dart';

class VendorManager extends ChangeNotifier {
  late VendorDTO vendorDTO = VendorDTO();

  List<VendorDTO> _vendorList = [];
  List<VendorDTO> _filteredList = [];
  bool _isRegistered = true;
  bool _isEnable = false;


  VendorManager() {
    VendorRegistrationService().getAllVendor().then((staff) {
      for (VendorDTO item in staff) {
        _vendorList.add(item);
      }
      notifyListeners();
    });
    getRegisteredList();
  }

  void getRegisteredList() {
    _filteredList = [];
    for (VendorDTO item in _vendorList) {
      if (item.registrationStatus == true) _filteredList.add(item);
    }
    notifyListeners();
  }

  void getNotRegisteredList() async {
    _filteredList = [];
    List<VendorDTO> vendors = await VendorRegistrationService().getVendorsNotRegistered();
    for (VendorDTO item in _vendorList) {
      if (item.registrationStatus == false) _filteredList.add(item);
    }
    notifyListeners();
  }


  List<VendorDTO> get vendorList => _vendorList;
  get _vendorRegistrationRequest => vendorDTO;

  List<VendorDTO> get filteredList => _filteredList;
  bool get isRegistered => _isRegistered;
  bool get isEnable => _isEnable;
  set isRegistered(bool val) => _isRegistered = val;
  set isEnable(bool val) {
    _isEnable = val;
    notifyListeners();
  }

}