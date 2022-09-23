import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled/model/places_search.dart';
import 'package:untitled/services/places_autocomplete.dart';

class LocationManager extends ChangeNotifier {
  final String _apiKey = "AIzaSyBphyueg6xoPG3upFK_6KUzmR_mvbCdcsA";
  late String _currentLocation = "";
  late List<PlaceSearchData> _searchedLocations = [];
  late GoogleMapController? _mapController;
  bool _isEmpty = false;

  get apiKey => _apiKey;
  get currentLocation => _currentLocation.toString();
  get searchedLocations => _searchedLocations;
  get mapController => _mapController;

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
    notifyListeners();
  }

  set setCurrentLocation(String value) {
    _currentLocation = value;
    notifyListeners();
  }

  void searchLocations(String input) async {
    _searchedLocations = await RPlaceAutoComplete().getAutoComplete(input);
    log(jsonEncode(_searchedLocations));
    isEmpty = true;
    isEmpty = true;
    notifyListeners();
  }

  set setSearchedLocations(List<PlaceSearchData> searchedLocations) {
    _searchedLocations = searchedLocations;
    log("searchedLocation: ${jsonEncode(_searchedLocations)}");
    notifyListeners();
  }

  set isEmpty(bool val) {
    _isEmpty = val;
    notifyListeners();
  }
  bool get isEmpty => _isEmpty;

  void clearSearchedLocations() {
    _searchedLocations = [];
    isEmpty = false;
    notifyListeners();
  }

}