import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/manager/manager.dart';
import 'package:untitled/model/places_search.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/services/places_autocomplete.dart';

class ApplicationManager extends ChangeNotifier {
  late String apiKey = "AIzaSyBphyueg6xoPG3upFK_6KUzmR_mvbCdcsA";
  late double latitude;
  late double longitude;
  late String currentLocation;
  late List<PlaceSearchData> searchedLocations = [];
  late VendorRegistrationRequest vendorRegistrationRequest = VendorRegistrationRequest();
  late GoogleMapController? mapController;


  get _latitude => latitude;
  get _longitude => longitude;
  get _currentLocation => currentLocation;
  get _vendorRegistrationRequest => vendorRegistrationRequest;


  void upLatLang(double lat, double long, String location) {
    latitude = lat;
    longitude = long;
    currentLocation = location;
    notifyListeners();
  }

  void searchLocation(String input) async {
    searchedLocations = await RPlaceAutoComplete().getAutoComplete(input);
    notifyListeners();
  }

  void clearLocations() {
    searchedLocations = [];
    notifyListeners();
  }

}