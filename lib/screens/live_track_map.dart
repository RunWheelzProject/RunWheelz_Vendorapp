/*
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/screens/vendor_mechanic_accept_screen.dart';

import 'package:http/http.dart' as http;
import 'package:untitled/screens/vendor_mechanic_dashboard.dart';

import '../model/customer.dart';
import '../model/vendor.dart';
import '../resources/resources.dart' as res;

class LocationTrackingMap extends StatefulWidget {
  final String id;
  final String? requestId;

  LocationTrackingMap({required this.id, this.requestId});

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<LocationTrackingMap> {
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBphyueg6xoPG3upFK_6KUzmR_mvbCdcsA";
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;
  Customer? _customer;
  LatLng? customerLatLng;

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(double lat, double long) async {

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(customerLatLng?.latitude ?? 0.0, customerLatLng?.longitude ?? 0.0),
        PointLatLng(lat, long),
        travelMode: TravelMode.driving,
        wayPoints: []);
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }
    _addPolyLine();
  }

  Future<LatLng> getServiceRequestById(int? id) async {
    http.Response response = await
    http.get(Uri.parse("${res.APP_URL}/api/servicerequest/service_request/$id"));
    var json = jsonDecode(response.body);
    log("details: ${jsonEncode(json)}");
    return LatLng(json["latitude"], json["longitude"]);
  }

  @override
  void initState() {
    super.initState();
    getServiceRequestById(int.parse(widget.requestId ?? "0")).then((customer) {
      customerLatLng = customer;

      log("customerLatLng: ${jsonEncode(customerLatLng)}");
      _addMarker(LatLng(customerLatLng?.latitude ?? 0.0, customerLatLng?.longitude ?? 0.0), "origin",
          BitmapDescriptor.defaultMarker);
    }).catchError((error) => log("error: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () => {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return VendorMechanicDashBoard(requestId: "");
                })
            )
          },
          child: const Icon(Icons.arrow_back),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('location').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (_added) {
              log("mechanicId: ${widget.requestId}, ${widget.id}");
              mymap(snapshot);
              log("lat: ${snapshot.data!.docs.singleWhere(
                      (element) => element.id == widget.id)['latitude']}, long: ${
                  snapshot.data!.docs.singleWhere(
                          (element) => element.id == widget.id)['longitude']
              }");
              _addMarker(LatLng(
                  snapshot.data!.docs.singleWhere(
                          (element) => element.id == widget.id)['latitude'],
                  snapshot.data!.docs.singleWhere(
                          (element) => element.id == widget.id)['longitude']
              ), "destination",
                  BitmapDescriptor.defaultMarkerWithHue(90));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return GoogleMap(
              zoomGesturesEnabled: true,
              mapType: MapType.normal,
              markers: Set<Marker>.of(markers.values),
              //polylines: Set<Polyline>.of(polylines.values),
              initialCameraPosition: const CameraPosition(
                  target: LatLng(18.8157, 78.8764),
                  zoom: 14.47
              ),
              onMapCreated: (GoogleMapController controller) async {
                setState(() {
                  _controller = controller;
                  _added = true;
                });
              },
            );
          },
        )
    );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    _controller?.moveCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
              snapshot.data!.docs.singleWhere(
                      (element) => element.id == widget.id)['latitude'],
              snapshot.data!.docs.singleWhere(
                      (element) => element.id == widget.id)['longitude']),
          northeast: LatLng(18.8157, 78.8764),
        ),
        10.0,
      ),
      //test
    );
  }

}*/


import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:untitled/screens/customer_board.dart';
import 'package:untitled/screens/vendor_mechanic_dashboard.dart';


class LocationTrackingMap extends StatefulWidget {
  bool isCustomer;
  bool isMechanic;
  final String id;
  final String? requestId;
  final LatLng customerLatLng;
  final LatLng mechanicLatLng;
  LocationTrackingMap({
    super.key,
    required this.id,
    this.requestId,
    required this.customerLatLng,
    required this.mechanicLatLng,
    this.isCustomer = false,
    this.isMechanic = false,
  });

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<LocationTrackingMap> {
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBphyueg6xoPG3upFK_6KUzmR_mvbCdcsA";
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;


  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.green, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(double lat, double long) async {

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(widget.customerLatLng.latitude, widget.customerLatLng.longitude),
        PointLatLng(lat, long),
        travelMode: TravelMode.driving,
        wayPoints: []);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  @override
  void initState() {
    super.initState();
    _addMarker(widget.customerLatLng, "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker

    _addMarker(widget.mechanicLatLng, "destination",
        BitmapDescriptor.defaultMarker);

    _getPolyline(widget.mechanicLatLng.latitude, widget.mechanicLatLng.longitude);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () => {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  if (widget.isCustomer) return CustomerDashBoard();
                  return VendorMechanicDashBoard(requestId: '');
                }))
          },
          child: const Icon(Icons.arrow_back),
        ),
        body: GoogleMap(
              zoomGesturesEnabled: true,
              mapType: MapType.normal,
              markers: Set<Marker>.of(markers.values),
              polylines: Set<Polyline>.of(polylines.values),
              initialCameraPosition: const CameraPosition(
                  target: LatLng(18.8157, 78.8764),
                  zoom: 10.0
              ),
              onMapCreated: (GoogleMapController controller) async {
                log("YES ADDED");
                setState(() {
                  _controller = controller;
                  _added = true;
                });
              },
            ),
        );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {

    _controller?.moveCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
              snapshot.data!.docs.singleWhere(
                      (element) => element.id == widget.id)['latitude'],
              snapshot.data!.docs.singleWhere(
                      (element) => element.id == widget.id)['longitude']),
          northeast: LatLng(18.8157, 78.8764),
        ),
        10.0,
      ),
    );
  }

}