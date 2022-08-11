import 'dart:convert';
import 'dart:developer';

import 'package:untitled/model/places_search.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/model/role.dart';
import '../resources/resources.dart' as res;

class RolesService {

  Uri uri = Uri.parse("${res.APP_URL}/api/admin/getAllRoles");
  Future<List<RoleDTO>> getAllRoles() async {
    http.Response response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);
    log("Roles: $jsonResponse");
    List<RoleDTO> list = [];
    for (var item in jsonResponse) {
      list.add(RoleDTO.fromJson(item));
    }
    return list;

  }

}