import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/model/places_search.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/model/vendor_mechanic.dart';
import 'package:untitled/services/vendor_registration.dart';
import 'package:http/http.dart' as http;
import '../model/role.dart';
import '../resources/resources.dart' as res;

class VendorMechanicManager extends ChangeNotifier {

 List<VendorMechanic> _vendorMechanicList = [];
 VendorMechanic _vendorMechanic = VendorMechanic();
 bool _isEnable = false;
 String _curDropDownValue = "";
 String _requestId = "";

 String get curDropDownValue => _curDropDownValue;
 String get requestId => _requestId;

 set requestId(String val) {
  _requestId = val;
  notifyListeners();
 }

set curDropDownValue(String val) {
 _curDropDownValue = val;
 notifyListeners();
}

 bool get isEnable => _isEnable;
 set isEnable(bool val ) {
  _isEnable = val;
  notifyListeners();
 }

 Future<List<VendorMechanic>> getMechanics() async {
  ///api/vendorstaff/getallmechanics
  http.Response response = await http.get(Uri.parse("${res.APP_URL}/api/vendorstaff/getallmechanics"));
  var jsonList = jsonDecode(response.body) as List;
  List<VendorMechanic> vendorMechanicList = [];

  return jsonList.map((mechanic) => VendorMechanic.fromJson(mechanic)).toList();

 }

 VendorMechanicManager() {
  getMechanics().then((mechanics) {
   log("mechanic: ${jsonEncode(mechanics[0])}");
   _vendorMechanicList = mechanics;
   _curDropDownValue = _vendorMechanicList[0].name!;
   notifyListeners();
  });
  notifyListeners();
 }
 set vendorMechanicList(List<VendorMechanic> vendorMechanic) {
  _vendorMechanicList = vendorMechanic;
  notifyListeners();
 }
 List<VendorMechanic> get vendorMechanicList => _vendorMechanicList;

 set vendorMechanic(VendorMechanic vendorMechanic) {
  _vendorMechanic = vendorMechanic;
  notifyListeners();
 }
 VendorMechanic get vendorMechanic => _vendorMechanic;

}