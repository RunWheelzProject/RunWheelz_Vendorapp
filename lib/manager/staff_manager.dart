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


  List<StaffDTO> get staffList => _staffList;
  get staffDTO => _staffDTO;

  void setAllStaff() {

    StaffService().getAllStaff()
    .then((response) {
      var jsonResponse = jsonDecode(response.body) as List;
      var list = jsonResponse.where((element) => element["registrationStatus"] == true).toList();
      _staffList = jsonResponse.map((json) => StaffDTO.fromJson(json)).toList();

      /*for (var item in list) {
        _staffList.add(StaffDTO.fromJson(item));
      }*/
      log("jsonResponse: ${jsonEncode(jsonResponse)}");
      //log("_staffList: $_staffList}");
    });
    notifyListeners();
  }

}