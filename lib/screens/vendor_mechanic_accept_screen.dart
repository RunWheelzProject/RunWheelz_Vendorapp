import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/rw_staff_management_screen.dart';
import 'package:untitled/screens/rw_vendor_management_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/screens/vendor_mechanic_dashboard.dart';
import 'package:untitled/screens/vendor_request_accept_screen.dart';
import 'package:untitled/screens/vendor_select_mechanic.dart';
import 'package:untitled/services/vendor_registration.dart';

import '../manager/profile_manager.dart';
import '../model/staff.dart';
import '../services/staff_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

import 'live_track_map.dart';

class VendorMechanicRequestAcceptScreen extends StatefulWidget {
  static const routeName = '/mechanic_accept_screen';
  const VendorMechanicRequestAcceptScreen({Key? key}) : super(key: key);

  @override
  _VendorMechanicRequestAcceptScreen createState() =>
      _VendorMechanicRequestAcceptScreen();
}

class _VendorMechanicRequestAcceptScreen
    extends State<VendorMechanicRequestAcceptScreen> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  List<String> stauts = ["started", "reached"];

  @override
  void initState() {
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  _getLocation() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as ServiceRequestArgs;
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance
          .collection('location')
          .doc(args.assignedToMechanic.toString())
          .set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
      }, SetOptions(merge: true));
    } catch (e) {
      //log(e);
    }
  }

  Future<void> _listenLocation() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as ServiceRequestArgs;
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      log(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      log("mechanic: ${args.assignedToMechanic.toString()}, lat1: ${currentlocation.latitude}, long1: ${currentlocation.longitude}");
      await FirebaseFirestore.instance
          .collection('location')
          .doc(args.assignedToMechanic.toString())
          .set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      log('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ServiceRequestArgs;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () => {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return VendorMechanicDashBoard(
              requestId: args.id.toString(),
            );
          }))
        },
        child: const Icon(Icons.arrow_back),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "New Request",
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
      body: Column(children: [
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white, width: 1.5),
                color: Colors.white),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Colors.purple,
                      border: Border(bottom: BorderSide())),
                  child: const Text(
                    "Service Details",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(children: [
                      Row(
                        children: [
                          const Text(
                            "Request ID: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(args.id.toString() ?? "")
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            "ServiceType: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(args.serviceType ?? "")
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Vehicle Number: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(args.vehicleNumber ?? "")
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Customer Name: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(args.customerArgs?.name ?? "")
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Customer Mobile Number: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(args.customerArgs?.phoneNumber ?? "")
                        ],
                      ),
                    ])),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _listenLocation();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return VendorMechanicDashBoard(
                              requestId: args.id.toString(),
                            );
                          }));
                        },
                        child: const Text("Accept")
                    ),
                  ],
                )
              ],
            ))
      ]),
    );
  }
}
