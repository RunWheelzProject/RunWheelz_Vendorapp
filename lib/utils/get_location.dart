
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../manager/service_request_manager.dart';


Future<String> getServiceLocation(double lat, double long) async {

  List<Placemark> placeMarks = await placemarkFromCoordinates(lat, long);
  Placemark place = placeMarks[0];

  return '${place.locality}, ${place.subLocality}';
}