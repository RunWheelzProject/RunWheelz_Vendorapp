import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/model/places_search.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/model/vendor_mechanic.dart';
import 'package:untitled/services/vendor_registration.dart';
import 'package:http/http.dart' as http;
import '../model/role.dart';
import '../resources/resources.dart' as res;

import 'package:location/location.dart' as loc;

class LiveTrackerManager extends ChangeNotifier {

  final loc.Location _location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  loc.Location get location => _location;
  StreamSubscription<loc.LocationData>? get locationSubscription => _locationSubscription;

}