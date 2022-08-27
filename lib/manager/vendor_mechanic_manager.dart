import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/model/places_search.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/model/vendor_mechanic.dart';
import 'package:untitled/services/vendor_registration.dart';

import '../model/role.dart';

class VendorMechanicManager extends ChangeNotifier {

 VendorMechanic vendorMechanic = VendorMechanic();
 bool _isEnable = false;

 bool get isEnable => _isEnable;
 set isEnable(bool val ) {
  _isEnable = val;
  notifyListeners();
 }
}