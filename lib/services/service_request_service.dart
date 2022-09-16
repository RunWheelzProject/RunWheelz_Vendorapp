
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:untitled/model/servie_request.dart';

import '../model/vendor.dart';
import '../resources/resources.dart' as res;

class BreakdownService {
  final Uri breakdownServiceRequestURL = Uri.parse("${res.APP_URL}/api/servicerequest/submit");

  Future<http.Response> customerRequest(ServiceRequestDTO serviceRequestDTO) async {

    String body = jsonEncode(serviceRequestDTO);
    log("customerRequest: $body");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    http.Response response = await http.post(breakdownServiceRequestURL, body: body, headers: headers);
    return response;
  }
}