import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/confirm_location.dart';
import 'package:untitled/components/google_map.dart';
import 'package:untitled/components/searched_location_listview.dart';
import 'package:untitled/manager/location_manager.dart';
import 'package:untitled/manager/vendor_manager.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/vendor_registration_screen_v1.dart';
import 'package:untitled/utils/add_space.dart';


class GoogleMapLocationPickerV1 extends StatefulWidget {
  const GoogleMapLocationPickerV1({Key? key}) : super(key: key);

  @override
  GoogleMapLocationPickerState createState() => GoogleMapLocationPickerState();
}

class GoogleMapLocationPickerState extends State<GoogleMapLocationPickerV1> {
  late VendorRegistrationRequest _vendorRegistrationRequest;
  late LocationManager _locationManager;
  final TextEditingController _locationController = TextEditingController();
  String location = "Search Location";
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _currentLocation = "";
  bool _isChecked = true;
  @override
  void initState() {
    super.initState();
    _vendorRegistrationRequest = Provider.of<VendorManager>(context, listen: false).vendorRegistrationRequest;
    _locationManager = Provider.of<LocationManager>(context, listen: false);
    _determinePosition().then((Position position) async {
      _latitude = position.latitude;
      _longitude = position.longitude;

      _vendorRegistrationRequest.longitude = _longitude;
      _vendorRegistrationRequest.latitude = _latitude;

      LatLng newLocation = LatLng(_latitude, _longitude);
      _locationManager.mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: newLocation, zoom: 17)));

      // function to get actual location from latitude and longitude values
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placeMarks[0];

      _locationManager.setCurrentLocation = '${place.locality}, ${place.subLocality}';

    }).catchError((onError) => log("GoogleMapError: $onError"));
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

    final TextTheme textTheme = Theme.of(context).textTheme;

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
                    return const VendorRegistrationV1();
                  }));
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        body: SafeArea(
            child: ListView(children: [
          Container(
              padding: const EdgeInsets.only(
                  top: 30, left: 20, right: 20, bottom: 10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(width: 2.0, color: Colors.grey))),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            shape: const CircleBorder(),
                            value: _isChecked,
                            onChanged: (value) {
                              log("_isLocationChecked: $value");
                              setState(() {
                                _isChecked = value as bool;
                              });
                            }
                        ),
                        addHorizontalSpace(5),
                        const Text(
                          "Use current location",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                    addVerticalSpace(20),
                    TextField(
                      controller: _locationController,
                      enabled: !_isChecked,
                      decoration: const InputDecoration(
                          hintText: 'Search a location',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.0)),
                          suffixIcon: Icon(
                            Icons.search_outlined,
                            color: Colors.black,
                          )),
                      onChanged: (value) {
                        log("value: $value");
                        _locationManager.searchLocations(value);
                        /*RPlaceAutoComplete()
                            .getAutoComplete(value)
                            .then((placeSearchData) {
                              _locationManager.setSearchedLocations = placeSearchData;
                          //_locationManager.searchedLocations(value);
                        });*/
                      },
                    ),
                  ])),
          Stack(children: [
            Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black12, width: 2)),
                    color: Colors.white),
                child: const RGoogleMap()),
            if (_locationManager.searchedLocations.isNotEmpty || _locationController.text.isNotEmpty)
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      backgroundBlendMode: BlendMode.darken),
                  child: const SearchedLocationListView()),
            const Positioned(
                top: 480,
                bottom: 0,
                child: ConfirmLocation())
          ]),
        ]))
    );
  }
}
