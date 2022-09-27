import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:searchable_listview/widgets/list_item.dart';
import 'package:untitled/components/confirm_location.dart';
import 'package:untitled/components/google_map.dart';
import 'package:untitled/manager/location_manager.dart';
import 'package:untitled/manager/vendor_manager.dart';
import 'package:untitled/model/servie_request.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/customer_board.dart';
import 'package:untitled/screens/vendor_registration_screen_v1.dart';
import '../manager/service_request_manager.dart';
import 'package:untitled/model/places_search.dart';
import 'package:http/http.dart' as http;

class GoogleMapLocationPickerV1 extends StatefulWidget {
  bool isCustomer;
  bool isVendor;
  bool isGeneral;
  List<PlaceSearchData> nearestLocations = [];
  LatLng? currentLocation;

  GoogleMapLocationPickerV1(
      {Key? key,
      this.isCustomer = false,
      this.isVendor = false,
      this.isGeneral = false,
        this.currentLocation
      })
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

  Future<List<PlaceSearchData>> getNearestLocations(String value) async {
    String apiKey =
        "AIzaSyBphyueg6xoPG3upFK_6KUzmR_mvbCdcsA";
    Uri uri = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value&key=$apiKey");
    log("uri: $uri");
    http.Response response = await http.get(uri);
    log("response: ${response.statusCode}");
    var jsonResponse = jsonDecode(response.body);
    var jsonResults = jsonResponse["predictions"] as List;
    List<PlaceSearchData> locations = [];
    for (var json in jsonResults) {
      locations.add(PlaceSearchData.fromJson(json));
    }
    return locations;
  }

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
    LocationManager locationManager = Provider.of<LocationManager>(context);
    VendorManager vendorManager = Provider.of<VendorManager>(context);
    ServiceRequestManager serviceRequestManager =
        Provider.of<ServiceRequestManager>(context);

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
              currentLocation: widget.currentLocation,
            ),
            if (widget.nearestLocations.isNotEmpty && _locationController.text.isNotEmpty)
              Positioned(
                top: 80,
                child: SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.white70,
                        child: ListView.separated(
                          itemCount: widget.nearestLocations.length,
                          itemBuilder: (BuildContext context, int position) {
                            return Item(
                              item: widget.nearestLocations[position],
                              googleMapLocationPickerV1: widget,
                              isVendor: widget.isVendor,
                              isCustomer: widget.isCustomer,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                        ))),
              ),
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                          labelText: "Search location",
                          labelStyle: TextStyle(color: Colors.deepPurple),
                          contentPadding: EdgeInsets.all(15),
                          suffixIcon: Icon(
                            Icons.search_outlined,
                            color: Colors.deepPurple,
                          ),
                          filled: true,
                          fillColor: Colors.white
                      ),
                      onChanged: (String value) {
                        getNearestLocations(value).then((locations) {
                          setState(() {
                            widget.nearestLocations = locations;
                          });
                        });
                      },
                    ))),
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

class Item extends StatefulWidget {
  PlaceSearchData item;
  bool isCustomer;
  bool isVendor;
  GoogleMapLocationPickerV1 googleMapLocationPickerV1;

  Item({super.key,
    required this.item,
    required this.googleMapLocationPickerV1,
    this.isVendor = false,
    this.isCustomer = false,
  });
  @override
  ItemState createState() => ItemState();

}

class ItemState extends State<Item> {


  @override
  Widget build(BuildContext context) {
    LocationManager locationManager = Provider.of<LocationManager>(context);
    VendorManager vendorManager = Provider.of<VendorManager>(context);
    ServiceRequestManager serviceRequestManager = Provider.of<ServiceRequestManager>(context);

    return ListItem(
        builder: (PlaceSearchData item) {
          return Row(
            children: [
              const Icon(Icons.location_on, color: Colors.red),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                  child: Text(
                item.description ?? "",
                overflow: TextOverflow.ellipsis,
              ))
            ],
          );
        },
        item: widget.item,
        onItemSelected: (PlaceSearchData item) async {
          final plist = GoogleMapsPlaces(
            apiKey: locationManager.apiKey,
            apiHeaders: await const GoogleApiHeaders().getHeaders(),
          );

          final detail = await plist.getDetailsByPlaceId(item.placeId ?? "");
          final geometry = detail.result.geometry!;
          setState(() {
            widget.googleMapLocationPickerV1.currentLocation = LatLng(geometry.location.lat, geometry.location.lng);
          });
          if (widget.isVendor) {
            vendorManager.vendorDTO.latitude = geometry.location.lat;
            vendorManager.vendorDTO.longitude = geometry.location.lng;
            setState(() {
              widget.googleMapLocationPickerV1.nearestLocations = [];
            });
          }

          if (widget.isCustomer) {
            serviceRequestManager.serviceRequestDTO.latitude = geometry.location.lat;
            serviceRequestManager.serviceRequestDTO.longitude = geometry.location.lng;
            setState(() {
              widget.googleMapLocationPickerV1.nearestLocations = [];
            });
          }

          LatLng newLocation = LatLng(geometry.location.lat, geometry.location.lng);
          List<Placemark> placeMarks = await placemarkFromCoordinates(geometry.location.lat, geometry.location.lng);
          locationManager.setCurrentLocation = '${placeMarks[0].locality}, ${placeMarks[0].subLocality}';
          locationManager.mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                  CameraPosition(target: newLocation, zoom: 14)));
          setState(() {
            widget.googleMapLocationPickerV1.nearestLocations = [];
          });

        });
  }
}
