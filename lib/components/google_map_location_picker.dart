/*
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/google_map.dart';
import 'package:untitled/manager/manager.dart';
import 'package:untitled/screens/vendor_registration_screen.dart';
import 'package:untitled/utils/add_space.dart';

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
  //late Position _position;
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _currentLocation = "";
  String _savedAddress = "";
  Placemark? _place;
  Color? _inkHover;
  late RGoogleMap _map;



  @override
  void initState() {
    super.initState();

    // get the latitude and longitude values to get actual location
    _determinePosition().then((Position position) async {
      _latitude = position.latitude;
      _longitude = position.longitude;

      // function to get actual location from latitude and longtiude values
      List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placeMarks[0];
      log("place: $placeMarks");

      setState(() {
        _place = place;
        _currentLocation = '${place.locality}';
        _savedAddress = "${place.locality}, ${place.subAdministrativeArea}\n"
            "${place.administrativeArea}, ${place.country} - ${place.postalCode}";
      });
      log("currentLocation: $_currentLocation");
    }).catchError((onError) => log("GoogleMapError: $onError"));

    //Provider.of<LocationManager>(context).upLatLang(_latitude, _longitude, _currentLocation);
  }

  // function to get user phones latitude and longtiude values

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Location"),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const VendorRegistration();
                  }));
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        body: SingleChildScrollView(child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                  top: 40, bottom: 20, left: 20, right: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.arrow_circle_down_rounded,
                          size: 34,
                          color: Colors.deepPurple,),
                        addHorizontalSpace(20),
                        Text("Select a location", style: textTheme.headline6)
                      ],
                    ),
                    addVerticalSpace(27),
                    SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          //_map = RGoogleMap(newLocation: LatLng(_position.latitude, _position.longitude));

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
                            _latitude = lat;
                            _longitude = lang;
                            log("Lat: $lat, Lang: $lang");
                            var newLocation = LatLng(lat, lang);
                            List<Placemark> placeMarks = await placemarkFromCoordinates(lat,
                                lang);
                            log("$placeMarks");
                            Placemark placeMark = placeMarks[0];
                            _currentLocation = '${placeMark.locality}';
                            Provider.of<ApplicationManager>(context, listen: false).upLatLang(lat, lang, _currentLocation);
                            //log("managerLocation: ${Provider.of<LocationManager>(context, listen: false).managerLocation}");
                            */
/*_map.mapController?.animateCamera(CameraUpdate.newCameraPosition(
                                CameraPosition(target: newLocation, zoom: 17)));
                            *//*
Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return RGoogleMap(newLocation: newLocation,);
                                }));
                          }
                        },
                        child: const Text("Search Location"),
                      ),
                    ),
                    addVerticalSpace(25),
                    InkWell(
                        onTap: () {
                          Provider.of<ApplicationManager>(context, listen: false).upLatLang(_latitude, _longitude, _currentLocation);
                          log("currentLocation: ${Provider.of<ApplicationManager>(context, listen: false).currentLocation}");
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            final LatLng newLocation = LatLng(_latitude, _longitude);
                            return RGoogleMap(newLocation: newLocation);
                          }));
                        },
                        onHover: (val) {
                          if (val) {
                            setState(() => {
                              _inkHover = val ? Colors.grey : Colors.grey[50]
                            });
                          }
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                            children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_searching,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                addHorizontalSpace(10),
                                const Text("Use current location",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16))
                              ],
                            ),
                            addVerticalSpace(5),
                            Row(
                              children: [
                                addHorizontalSpace(35),
                                Text(
                                  _currentLocation,
                                  style: const TextStyle(color: Colors.black87),
                                  overflow: TextOverflow.clip,
                                )
                              ],
                            )
                          ]),
                          Column(
                            children: [
                              addHorizontalSpace(140),
                              const Icon(Icons.arrow_circle_right_rounded,
                                size: 34,
                                  color: Colors.deepPurple)],
                          )
                        ]))),
                  ])),

          Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                border:
                    Border(top: BorderSide(color: Colors.black12, width: 1)),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Saved Location", style: textTheme.subtitle1,),
                addVerticalSpace(10),
                addHorizontalSpace(30),
                Text(_savedAddress)
              ],
            )
          ),
          Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.black12, width: 1)),
                  color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Recent Search", style: textTheme.subtitle1,),
                addVerticalSpace(10),
                addHorizontalSpace(30),
                Text(_savedAddress)
              ],
            ),
          ),
          */
/*Container(
              height: 285,
              decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.black12, width: 2)),
                  color: Colors.white),
              child: GoogleMap(
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
              ))*//*

        ])));
  }
}
*/
