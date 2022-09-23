/*
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
import 'package:untitled/model/servie_request.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/customer_board.dart';
import 'package:untitled/screens/vendor_registration_screen_v1.dart';
import 'package:untitled/utils/add_space.dart';

import '../manager/customer_managere.dart';
import '../manager/service_request_manager.dart';
import '../model/customer.dart';

class GoogleMapLocationPickerV1 extends StatefulWidget {
  bool isCustomer;
  bool isVendor;
  bool isGeneral;
  GoogleMapLocationPickerV1(
      {Key? key,
      this.isCustomer = false,
      this.isVendor = false,
      this.isGeneral = false})
      : super(key: key);

  @override
  GoogleMapLocationPickerState createState() => GoogleMapLocationPickerState();
}

class GoogleMapLocationPickerState extends State<GoogleMapLocationPickerV1> {
  VendorDTO? _vendorDTO;
  ServiceRequestDTO? _serviceRequestDTO;
  late LocationManager _locationManager;
  final TextEditingController _locationController = TextEditingController();
  String location = "Search Location";
  double _latitude = 0.0;
  double _longitude = 0.0;
  LatLng? currentLocation;
  bool _isChecked = true;

  @override
  void initState() {
    super.initState();
    _vendorDTO = Provider.of<VendorManager>(context, listen: false).vendorDTO;
    _serviceRequestDTO =
        Provider.of<ServiceRequestManager>(context, listen: false)
            .serviceRequestDTO;
    _locationManager = Provider.of<LocationManager>(context, listen: false);
    _determinePosition().then((Position position) async {
      _latitude = position.latitude;
      _longitude = position.longitude;
      currentLocation = LatLng(position.latitude, position.longitude);

      if (widget.isVendor) {
        _vendorDTO?.longitude = _longitude;
        _vendorDTO?.latitude = _latitude;
      }
      if (widget.isCustomer) {
        _serviceRequestDTO?.longitude = _longitude;
        _serviceRequestDTO?.latitude = _latitude;
      }

      LatLng newLocation = LatLng(_latitude, _longitude);
      _locationManager.mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: newLocation, zoom: 14)));
      // function to get actual location from latitude and longitude values
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placeMarks[0];

      _locationManager.setCurrentLocation =
          '${place.locality}, ${place.subLocality}';
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
                    return widget.isVendor
                        ? const VendorRegistrationV1()
                        : CustomerDashBoard(isCustomer: true);
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
                            //shape: const CircleBorder(),
                            value: _isChecked,
                            onChanged: (value) {
                              log("_isLocationChecked: $value");
                              setState(() {
                                _isChecked = value as bool;
                              });
                            }),
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
                child: RGoogleMap(
                  currentLocation: currentLocation,
                )),
            if (_locationManager.searchedLocations.isNotEmpty ||
                _locationController.text.isNotEmpty)
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      backgroundBlendMode: BlendMode.darken),
                  child: SearchedLocationListView(
                      isCustomer: widget.isCustomer,
                      isVendor: widget.isVendor)),
            */
/*Positioned(
                top: 380,
                bottom: 0,
                child: ConfirmLocation(
                    isCustomer: widget.isCustomer,
                    isVendor: widget.isVendor,
                    isGeneral: widget.isGeneral
                )
            )*/ /*

          ]),
        ])));
  }
}
*/

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
import 'package:untitled/model/servie_request.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/customer_board.dart';
import 'package:untitled/screens/vendor_registration_screen_v1.dart';
import 'package:untitled/utils/add_space.dart';

import '../manager/customer_managere.dart';
import '../manager/service_request_manager.dart';
import '../model/customer.dart';

class GoogleMapLocationPickerV1 extends StatefulWidget {
  bool isCustomer;
  bool isVendor;
  bool isGeneral;
  GoogleMapLocationPickerV1(
      {Key? key,
      this.isCustomer = false,
      this.isVendor = false,
      this.isGeneral = false})
      : super(key: key);

  @override
  GoogleMapLocationPickerState createState() => GoogleMapLocationPickerState();
}

class GoogleMapLocationPickerState extends State<GoogleMapLocationPickerV1> {
  VendorDTO? _vendorDTO;
  ServiceRequestDTO? _serviceRequestDTO;
  late LocationManager _locationManager;
  final TextEditingController _locationController = TextEditingController();
  String location = "Search Location";
  double _latitude = 0.0;
  double _longitude = 0.0;
  LatLng? currentLocation;
  bool _isChecked = true;

  @override
  void initState() {
    super.initState();
    _vendorDTO = Provider.of<VendorManager>(context, listen: false).vendorDTO;
    _serviceRequestDTO =
        Provider.of<ServiceRequestManager>(context, listen: false)
            .serviceRequestDTO;
    _locationManager = Provider.of<LocationManager>(context, listen: false);
    _determinePosition().then((Position position) async {
      _latitude = position.latitude;
      _longitude = position.longitude;
      currentLocation = LatLng(position.latitude, position.longitude);

      if (widget.isVendor) {
        _vendorDTO?.longitude = _longitude;
        _vendorDTO?.latitude = _latitude;
      }
      if (widget.isCustomer) {
        _serviceRequestDTO?.longitude = _longitude;
        _serviceRequestDTO?.latitude = _latitude;
      }

      LatLng newLocation = LatLng(_latitude, _longitude);
      _locationManager.mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: newLocation, zoom: 14)));
      // function to get actual location from latitude and longitude values
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placeMarks[0];

      _locationManager.setCurrentLocation =
          '${place.locality}, ${place.subLocality}';
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
                    return widget.isVendor
                        ? const VendorRegistrationV1()
                        : CustomerDashBoard(isCustomer: true);
                  }));
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        body: SafeArea(
          child: Stack(children: [
            RGoogleMap(
              currentLocation: currentLocation,
            ),
            if (_locationManager.isEmpty)
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      backgroundBlendMode: BlendMode.darken),
                  child: SearchedLocationListView(
                      isCustomer: widget.isCustomer,
                      isVendor: widget.isVendor
                  )
              ),
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Search location",
                          labelStyle: TextStyle(color: Colors.deepPurple),
                          contentPadding: EdgeInsets.all(15),
                          suffixIcon: Icon(
                            Icons.search_outlined,
                            color: Colors.deepPurple,
                          ),
                          filled: true,
                          fillColor: Colors.white),
                      onChanged: (String value) {
                        _locationManager.searchLocations(value);
                      },
                    )
                )
            ),
            Positioned(
                bottom: 0,
                child: ConfirmLocation(
                  isVendor: widget.isVendor,
                  isCustomer: widget.isCustomer,
                  isGeneral: widget.isGeneral,
                )),
          ]),
        ));
  }
}
