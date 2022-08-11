import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/model/places_search.dart';
import 'package:untitled/model/vendor.dart';

import '../model/role.dart';

class VendorManager extends ChangeNotifier {
  late VendorRegistrationRequest vendorRegistrationRequest = VendorRegistrationRequest(role: RoleDTO());


  get _vendorRegistrationRequest => vendorRegistrationRequest;

}