import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/model/places_search.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/services/vendor_registration.dart';

import '../model/role.dart';

class VendorManager extends ChangeNotifier {
  late VendorRegistrationRequest vendorRegistrationRequest = VendorRegistrationRequest();

  List<VendorRegistrationRequest> _vendorList = [];


  VendorManager() {
    VendorRegistrationService().getAllVendor().then((staff) {
      for (VendorRegistrationRequest item in staff) {
        if (item.registrationStatus == true) _vendorList.add(item);
      }
      notifyListeners();
    });
  }

  List<VendorRegistrationRequest> get vendorList => _vendorList;
  get _vendorRegistrationRequest => vendorRegistrationRequest;

}