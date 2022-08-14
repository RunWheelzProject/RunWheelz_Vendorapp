import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:untitled/model/staff.dart';
import '../model/vendor.dart';
import '../resources/resources.dart' as res;


class StaffService {

  final Uri _getAllStaff = Uri.parse("${res.APP_URL}/api/staff/getAllStaff");
  final Uri updateStaffInfoURL = Uri.parse("${res.APP_URL}/api/staff/editVendor");

  Future<List<StaffDTO>> getAllStaff() async {
    http.Response response = await http.get(_getAllStaff);

    var jsonResponse = jsonDecode(response.body);
    List<StaffDTO> list = [];
    for (var item in jsonResponse) {
      list.add(StaffDTO.fromJson(item));
    }
    return list;

  }


  Future<http.Response> updateStaffInfo(StaffDTO staffDTO) async {
    String body = jsonEncode(staffDTO);
    log("vendorRegistrationRequest: $body");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    http.Response response = await http.put(updateStaffInfoURL, body: body, headers: headers);
    return response;
  }


}