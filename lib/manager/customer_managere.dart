import 'package:flutter/material.dart';
import 'package:untitled/model/customer.dart';
import 'package:untitled/services/staff_service.dart';

import '../model/role.dart';
import '../model/staff.dart';

class CustomerManager extends ChangeNotifier {
  late CustomerDTO _customerDTO = CustomerDTO();
  get customerDTO => _customerDTO;
  set customerDTO(value) => _customerDTO = value;
}