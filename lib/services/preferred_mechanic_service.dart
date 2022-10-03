
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:untitled/screens/preferred_mechanics.dart';

import '../model/preferred_mechanic_dto.dart';
import '../model/servie_request.dart';
import '../model/vendor.dart';
import '../resources/resources.dart' as res;
class PreferredMechanicService {

  final String _URLGetAllPreferredMechanics = "${res.APP_URL}/api/preferred_mechanic/get_mechanic_by_id";
  Uri _URLAddMechanic = Uri.parse("${res.APP_URL}/api/preferred_mechanic/add");
  final Uri _URLSendNotification = Uri.parse("${res.APP_URL}/api/preferred_mechanic/send_notification");

  Future<List<PreferredMechanicDTO>> getAllPreferredMechanics(int id) async {
    http.Response response = await http.get(Uri.parse("$_URLGetAllPreferredMechanics?id=$id"));

    var jsonResponse = jsonDecode(response.body);

    List<PreferredMechanicDTO> list = [];

    if (response.statusCode == 200) {
      for (var item in jsonResponse) {
        list.add(PreferredMechanicDTO.fromJson(item));
      }

      return list;
    }

    throw Exception("error returning preferred mechanic list");

  }

  Future<PreferredMechanicDTO> addMechanic(int customerID, int vendorID) async {
    _URLAddMechanic = Uri.parse("$_URLAddMechanic?customerID=$customerID&vendorMechanicID=$vendorID");
    http.Response response = await http.get(_URLAddMechanic);
    log("notRegistered: ${jsonEncode(response.body)}");
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return PreferredMechanicDTO.fromJson(jsonResponse);
    }

    throw Exception("could not add preferred mechanic");
  }

  Future<ServiceRequestDTO> sendNotification(ServiceRequestDTO serviceRequestDTO) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var body = jsonEncode(serviceRequestDTO);

    log("bod: body");

    http.Response response = await http.put(
        _URLSendNotification,
        body: body,
        headers: headers
    );

    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return ServiceRequestDTO.fromJson(jsonResponse);
    }

    throw Exception("could not send notification");
  }

}