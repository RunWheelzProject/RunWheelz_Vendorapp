
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../model/vendor.dart';
import '../resources/resources.dart' as res;
class VendorMechanicService {

  final Uri vendorRegistrationRequestURL = Uri.parse("${res.APP_URL}/api/vendor/registrationrequest");
  final Uri updateVendorInfoURL = Uri.parse("${res.APP_URL}/api/vendor/editvendor");
  final Uri _getAllVendor = Uri.parse("${res.APP_URL}/api/vendor/getallvendors");
  final Uri _getVendorsNotRegistered = Uri.parse("${res.APP_URL}/api/vendor/getallvendorregistrationrequests");

  Future<List<VendorRegistrationRequest>> getAllVendor() async {
    http.Response response = await http.get(_getAllVendor);

    var jsonResponse = jsonDecode(response.body);
    List<VendorRegistrationRequest> list = [];
    for (var item in jsonResponse) {
      list.add(VendorRegistrationRequest.fromJson(item));
    }

    return list;

  }

  Future<List<VendorRegistrationRequest>> getVendorsNotRegistered() async {
    http.Response response = await http.get(_getVendorsNotRegistered);
    log("notRegistered: ${jsonEncode(response.body)}");
    var jsonResponse = jsonDecode(response.body);
    List<VendorRegistrationRequest> list = [];
    for (var item in jsonResponse) {
      list.add(VendorRegistrationRequest.fromJson(item));
    }

    return list;

  }

  Future<http.Response> vendorRegistrationRequest(VendorRegistrationRequest vendorRegistrationRequest) async {
    String body = jsonEncode(vendorRegistrationRequest);
    log("vendorRegistrationRequest: $body");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    http.Response response = await http.post(vendorRegistrationRequestURL, body: body, headers: headers);
    return response;
  }

  Future<http.Response> updateVendorInfo(VendorRegistrationRequest vendorRegistrationRequest) async {
    String body = jsonEncode(vendorRegistrationRequest);
    log("vendorRegistrationRequest: $body");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    http.Response response = await http.put(updateVendorInfoURL, body: body, headers: headers);
    return response;
  }

  Future<VendorRegistrationRequest> getVendorById(int id) async {
    http.Response response = await http.get(Uri.parse("${res.APP_URL}/api/vendor/$id"));
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {

      VendorRegistrationRequest vendorRegistrationRequest = VendorRegistrationRequest.fromJson(jsonResponse);
      return vendorRegistrationRequest;
    }

    throw jsonResponse["message"];

  }


}