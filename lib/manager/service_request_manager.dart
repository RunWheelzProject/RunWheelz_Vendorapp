import 'package:flutter/material.dart';
import 'package:untitled/model/servie_request.dart';
import '../resources/resources.dart' as res;


class ServiceRequestManager extends ChangeNotifier {
  int _requestId = 0;
  ServiceRequestDTO _serviceRequestDTO = ServiceRequestDTO();

  set serviceRequestDTO(ServiceRequestDTO serviceRequestDTO) {
    _serviceRequestDTO = serviceRequestDTO;
    notifyListeners();
  }
  set requestId(int id) {
    _requestId = id;
    notifyListeners();
  }

  int get requestId => _requestId;
  ServiceRequestDTO get serviceRequestDTO => _serviceRequestDTO;

}
