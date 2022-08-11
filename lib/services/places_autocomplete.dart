import 'dart:convert';
import 'dart:developer';

import 'package:untitled/model/places_search.dart';
import 'package:http/http.dart' as http;
import '../resources/resources.dart' as res;

class RPlaceAutoComplete {

  //Uri uri = Uri.parse("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${}&types=(cities)&key=AIzaSyBphyueg6xoPG3upFK_6KUzmR_mvbCdcsA");
  String apiKey = "AIzaSyBphyueg6xoPG3upFK_6KUzmR_mvbCdcsA";
  Future<List<PlaceSearchData>> getAutoComplete(String input) async {
    Uri uri = Uri.parse("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey");
    http.Response response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);
    var jsonResults = jsonResponse["predictions"] as List;

    return jsonResults.map((place) => PlaceSearchData.fromJson(place)).toList();

  }

}