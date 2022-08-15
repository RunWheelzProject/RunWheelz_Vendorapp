import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/model/places_search.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/services/staff_service.dart';

import '../model/role.dart';
import '../model/staff.dart';

class StaffManager extends ChangeNotifier {
  late StaffDTO _staffDTO = StaffDTO(role: RoleDTO());
  List<StaffDTO> _staffList = [];
  List<StaffDTO> _filteredList = [];
  bool _isRegistered = true;


  StaffManager() {
    StaffService().getAllStaff().then((staff) {
      for (StaffDTO item in staff) {
        _staffList.add(item);
      }
      notifyListeners();
    });
    getRegisteredList();
  }

  void getRegisteredList() {
    _filteredList = [];
    for (StaffDTO item in _staffList) {
      if (item.registrationStatus == true) _filteredList.add(item);
    }
    notifyListeners();
  }

  void getNotRegisteredList() {
    _filteredList = [];
    for (StaffDTO item in _staffList) {
      if (item.registrationStatus == false) _filteredList.add(item);
    }
    notifyListeners();
  }


  List<StaffDTO> get staffList => _staffList;
  List<StaffDTO> get filteredList => _filteredList;
  get staffDTO => _staffDTO;
  bool get isRegistered => _isRegistered;

  set isRegistered(bool val) => _isRegistered = val;
  set staffDTO(value) => _staffDTO = value;

  /*void setAllStaff() {

    StaffService().getAllStaff()
    .then((response) {
      log("${jsonDecode(response.body)}");
      var jsonResponse = jsonDecode(response.body) as List;
      _staffList = jsonResponse.where((element) => element["registrationStatus"] == true).toList()
          .map((json) => StaffDTO.fromJson(json)).toList();
      log("jsonResponse: ${jsonEncode(jsonResponse)}");
      //log("_staffList: $_staffList}");
    });
    notifyListeners();
  }*/

}