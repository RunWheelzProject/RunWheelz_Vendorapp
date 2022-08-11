
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../model/vendor.dart';
import '../resources/resources.dart' as res;
class VendorRegistrationService {

  final Uri vendorRegistrationRequestURL = Uri.parse("${res.APP_URL}/api/vendor/registrationrequest");
  final Uri updateVendorInfoURL = Uri.parse("${res.APP_URL}/api/vendor/editvendor");

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

}