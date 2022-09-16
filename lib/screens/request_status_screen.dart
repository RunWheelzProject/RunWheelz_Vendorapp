import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/profile.dart';
import '../components/customer_appbar.dart';
import '../components/header_text.dart';
import '../components/item_row.dart';
import '../components/positioned_view.dart';
import '../manager/profile_manager.dart';
import '../manager/service_request_manager.dart';
import '../model/vendor.dart';
import '../model/vendor_mechanic.dart';
import '../resources/resources.dart' as res;
import '../resources/resources.dart';

import 'package:http/http.dart' as http;

import '../utils/add_space.dart';
import 'customer_board.dart';
import 'customer_favorite_mechnic.dart';
import 'customer_reqeust_history.dart';
import 'live_track_map.dart';

class VendorMechanicTrakcer {
  bool isStopped = false;
  int id = 0;
}

class RequestStatusDetailsV1 extends StatefulWidget {
  const RequestStatusDetailsV1({Key? key}) : super(key: key);
  @override
  RequestStatusDetailsState createState() => RequestStatusDetailsState();
}

class RequestStatusDetailsState extends State<RequestStatusDetailsV1> {
  bool isStopped = false;
  VendorMechanicTrakcer vendorMechanicTrakcer = VendorMechanicTrakcer();
  Timer? _timer;
  VendorMechanic? _vendorMechanic;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (isStopped) {
        timer.cancel();
      }
      getMechanicDetails(vendorMechanicTrakcer);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomerAppBar(child: _mainContainer());
  }

  Widget _mainContainer() {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          requestDetails(),
          const SizedBox(
            height: 10,
          ),
          vendorDetails() ??
              const SizedBox(
                height: 0,
              ),
          const SizedBox(
            height: 10,
          ),
          mechanicDetails() ??
              const SizedBox(
                height: 0,
              ),
          const SizedBox(
            height: 45,
          ),
          requestStatus(),
          const SizedBox(
            height: 10,
          ),
        ]));
  }

  Widget requestDetails() {
    ServiceRequestManager serviceRequestManager =
        Provider.of<ServiceRequestManager>(context, listen: false);
    return Container(
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
                  color: Colors.purple, border: Border(bottom: BorderSide())),
              child: const Text(
                "Request Details",
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Request ID: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                            serviceRequestManager.serviceRequestDTO.id
                                    .toString() ??
                                "",
                            style: const TextStyle(
                              fontSize: 16,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Service Type: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                            serviceRequestManager
                                    .serviceRequestDTO.serviceType ??
                                "",
                            style: const TextStyle(
                              fontSize: 16,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          "Make: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(serviceRequestManager.serviceRequestDTO.make ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                            ))
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
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                            serviceRequestManager
                                    .serviceRequestDTO.vehicleNumber ??
                                "",
                            style: const TextStyle(
                              fontSize: 16,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ))
          ],
        ));
  }

  Widget? vendorDetails() {
    ServiceRequestManager serviceRequestManager =
        Provider.of<ServiceRequestManager>(context, listen: false);
    if (_vendorMechanic != null) {
      return Container(
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
                    color: Colors.purple, border: Border(bottom: BorderSide())),
                child: const Text(
                  "Vendor Details",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Name: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(_vendorMechanic?.vendor?.ownerName ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Garage Name: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(_vendorMechanic?.vendor?.garageName ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Phone Number: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(_vendorMechanic?.vendor?.phoneNumber ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ))
            ],
          ));
    }
    return null;
  }

  Widget? mechanicDetails() {
    ServiceRequestManager serviceRequestManager =
        Provider.of<ServiceRequestManager>(context, listen: false);
    if (_vendorMechanic != null) {
      return Container(
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
                    color: Colors.purple, border: Border(bottom: BorderSide())),
                child: const Text(
                  "Mechanic Details",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Name: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(_vendorMechanic?.name ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Phone Number: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(_vendorMechanic?.phoneNumber ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ))
            ],
          ));
    }
    return null;
  }

  Future<void> getMechanicDetails(
      VendorMechanicTrakcer vendorMechanicTrakcer) async {
    ServiceRequestManager serviceRequestManager =
        Provider.of<ServiceRequestManager>(context, listen: false);
    http.Response response = await http.get(Uri.parse(
        "${res.APP_URL}/api/servicerequest/service_request/${serviceRequestManager.serviceRequestDTO.id}"));
    var json = jsonDecode(response.body);
    if (json["assignedToMechanic"] != 0) {
      setState(() => isStopped = true);
      response = await http.get(Uri.parse(
          "${res.APP_URL}/api/vendorstaff/${json["assignedToMechanic"]}"));
      json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() => _vendorMechanic = VendorMechanic.fromJson(json));
      }
      /*setState(() {
        _vendorAndMechanic = json;
      });
      log("mechanic: $json");*/
    }
  }

  Future<void> getMechanicData(
      VendorMechanicTrakcer vendorMechanicTrakcer) async {
    ServiceRequestManager serviceRequestManager =
        Provider.of<ServiceRequestManager>(context, listen: false);
    http.Response response = await http.get(Uri.parse(
        "${res.APP_URL}/api/servicerequest/service_request/${serviceRequestManager.serviceRequestDTO.id}"));
    var json = jsonDecode(response.body);
    //log("json: ${json["assignedToMechanic"]}");
    if (json["assignedToMechanic"] != 0) {
      //log("json: $json");
      setState(() => isStopped = true);
      // /api/vendorstaff
      response = await http.get(Uri.parse(
          "${res.APP_URL}/api/vendorstaff/${json["assignedToMechanic"]}"));
      json = jsonDecode(response.body);
      //log("mechanic: $json");
    }
  }

  Widget requestStatus() {
    ServiceRequestManager serviceRequestManager =
        Provider.of<ServiceRequestManager>(context, listen: false);
    ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                return CustomerDashBoard(isCustomer: true);
                //return LocationTrackingMap(id: _vendorMechanic?.id.toString() as String);
              }));
            },
            child: const Text("Cancel Request"),
          ),
          ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
              return CustomerDashBoard(isCustomer: true);
              //return LocationTrackingMap(id: _vendorMechanic?.id.toString() as String);
            }));
          },
          child: const Text("Track Mechanic"),
        )
    ]);
  }
}
