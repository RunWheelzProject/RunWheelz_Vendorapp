import 'package:flutter/material.dart';
import '../resources/resources.dart' as res;


class ServiceRequestManager extends ChangeNotifier {
  int _requestId = 0;

  set requestId(int id) {
    _requestId = id;
    notifyListeners();
  }

  int get requestId => _requestId;

}
