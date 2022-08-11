import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:untitled/model/role.dart';
import 'package:untitled/services/roles_service.dart';

class RoleManager extends ChangeNotifier{
  List<RoleDTO> _roleNames = [RoleDTO(id: 0, roleName: "Select Role")];

  RoleManager() {
    RolesService().getAllRoles().then((roles) {
      log("roles: ${jsonEncode(roles)}");
      for (RoleDTO item in roles) {
        _roleNames.add(item);
      }
    });
//    log("roles: ${jsonEncode(_roleNames.map((item) => item.roleName))}");
  }

  List<RoleDTO> get roleNames => _roleNames;

}