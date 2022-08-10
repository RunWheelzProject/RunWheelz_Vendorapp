import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:untitled/screens/vendor_registration_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: GoogleMapLocationPicker(),
    );
  }
}

class GoogleMapLocationPicker extends StatefulWidget {
  const GoogleMapLocationPicker({Key? key}) : super(key: key);

  @override
  GoogleMapLocationPickerState createState() => GoogleMapLocationPickerState();
}

class GoogleMapLocationPickerState extends State<GoogleMapLocationPicker> {
  String apiKey = "AIzaSyBphyueg6xoPG3upFK_6KUzmR_mvbCdcsA";
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  LatLng startLocation = const LatLng(18.790894, 78.911850);
  String location = "Search Location";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Location"),
          backgroundColor: Colors.deepPurpleAccent,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return const VendorRegistration();
                      })); },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        body: Stack(children: [
          GoogleMap(
            zoomGesturesEnabled: true,
            initialCameraPosition: CameraPosition(
              target: startLocation,
              zoom: 14.0,
            ),
            mapType: MapType.normal,
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            onCameraMove: (CameraPosition cameraPosition) {
              cameraPosition = cameraPosition;
            },
            onCameraIdle: () async {
              List<Placemark> placeMarks = await placemarkFromCoordinates(
                  cameraPosition!.target.latitude,
                  cameraPosition!.target.longitude);
              setState(() {
                location =
                "${placeMarks.first.administrativeArea}, ${placeMarks.first.street}";
              });
            },
          ),
          Positioned(
              child: ElevatedButton(
              onPressed: () async {
                var place = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: apiKey,
                    mode: Mode.overlay,
                    types: [],
                    strictbounds: false,
                    components: [Component(Component.country, 'in')],
                    //google_map_webservice package
                    onError: (err) {
                      log("$err");
                    });
                if (place != null) {
                  setState(() {
                    location = place.description.toString();
                  });
                  log("current location: $place");
                  final plist = GoogleMapsPlaces(
                    apiKey: apiKey,
                    apiHeaders: await const GoogleApiHeaders().getHeaders(),
                  );
                  String placeId = place.placeId ?? "0";
                  final detail = await plist.getDetailsByPlaceId(placeId);
                  final geometry = detail.result.geometry!;
                  final lat = geometry.location.lat;
                  final lang = geometry.location.lng;
                  log("Lat: $lat, Lang: $lang");
                  var newLocation = LatLng(lat, lang);
                  mapController?.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: newLocation, zoom: 17)));
                }
              },
              child: const Text("Search Location"),
          ))
        ]));
  }
}
