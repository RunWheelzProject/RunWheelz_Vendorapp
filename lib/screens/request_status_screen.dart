import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/profile.dart';
import '../components/card_header.dart';
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
  LatLng? _mechanicLatLng;

  List<Row> createRows(List<List<String?>> list) {
    List<Row> rows = [];
    log("service Details ${jsonEncode(list)}");
    for (var item in list) {
      log(jsonEncode(item));
      rows.add(
          Row(
            children: [
              Text(
                "${item[0]}: " ?? "",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(item[1] ?? "")
            ],
          )
      );
    }

    return rows;
  }

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
    ServiceRequestManager serviceRequestManager = Provider.of<ServiceRequestManager>(context, listen: false);

    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          CardHeader(
            title: "Request Details",
              children: createRows([
                ["Service Type", serviceRequestManager.serviceRequestDTO?.serviceType],
                ["Make", serviceRequestManager.serviceRequestDTO?.make],
                ["Vehicle Number", serviceRequestManager.serviceRequestDTO?.vehicleNumber],
                ["Location", "Lingampally"]
              ])
          ),
          const SizedBox(height: 20,),
          if (_vendorMechanic != null)
          CardHeader(
            title: "Vendor Details",
              children: createRows([
                ["Name", _vendorMechanic?.vendor?.ownerName],
                ["Phone", _vendorMechanic?.vendor?.phoneNumber],
              ])
          ),
          const SizedBox(height: 20,),
          if (_vendorMechanic != null)
          CardHeader(
            title: "Mechanic Details",
              children: createRows([
                ["Name", _vendorMechanic?.name],
                ["Phone", _vendorMechanic?.phoneNumber],
              ])
          ),
          requestStatus() ?? const SizedBox(height: 0,),
          const SizedBox(
            height: 10,
          ),
        ]));
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

  Widget? requestStatus() {
    ServiceRequestManager serviceRequestManager = Provider.of<ServiceRequestManager>(context, listen: false);
    ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
    if (_vendorMechanic != null) {
      log(jsonEncode(_vendorMechanic?.id));
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('location').snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        _mechanicLatLng = LatLng(
                            snapshot.data!.docs.singleWhere((element) => element.id == "12")['latitude'],
                            snapshot.data!.docs.singleWhere((element) => element.id == "12")['longitude']
                        );
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Distance: ", style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(double.parse((Geolocator.distanceBetween(
                                serviceRequestManager.serviceRequestDTO.latitude ?? 0.0,
                                serviceRequestManager.serviceRequestDTO.longitude ?? 0.0,
                                snapshot.data!.docs.singleWhere((element) => element.id == "12")['latitude'],
                                snapshot.data!.docs.singleWhere((element) => element.id == "12")['longitude']) / 1000)
                                .toStringAsFixed(2))
                                .toString()),
                            const SizedBox(width: 20,),
                            ElevatedButton(
                              child: const Text("Track Customer"),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        LocationTrackingMap(
                                          isCustomer: true,
                                          id: _vendorMechanic?.id
                                              .toString() ??
                                              "",
                                          requestId: serviceRequestManager
                                              .serviceRequestDTO.id
                                              .toString() ??
                                              "",
                                          customerLatLng: LatLng(
                                              serviceRequestManager
                                                  .serviceRequestDTO
                                                  ?.latitude ??
                                                  0.0,
                                              serviceRequestManager
                                                  .serviceRequestDTO
                                                  ?.longitude ??
                                                  0.0),
                                          mechanicLatLng:
                                          _mechanicLatLng as LatLng,
                                        ))
                                );
                              },
                            ),
                          ],
                        );
                      }),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement(
                          MaterialPageRoute(builder: (BuildContext context) {
                            return CustomerDashBoard(isCustomer: true);
                            //return LocationTrackingMap(id: _vendorMechanic?.id.toString() as String);
                          }));
                    },
                    child: const Text("Cancel Request"),
                  ),
                ],
              ),
            ),
          ]);
    } else {
      return null;
    }
  }
}
