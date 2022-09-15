import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../components/header_text.dart';
import '../components/item_row.dart';
import '../components/positioned_view.dart';
import '../manager/profile_manager.dart';
import '../manager/service_request_manager.dart';
import '../resources/resources.dart' as res;
import '../resources/resources.dart';

import 'package:http/http.dart' as http;

import 'live_track_map.dart';

class VendorMechanicTrakcer {
  bool isStopped = false;
  int id = 0;
}

class RequestStatusDetails extends StatefulWidget {
  const RequestStatusDetails({Key? key}) : super(key: key);
  @override
  RequestStatusDetailsState createState() => RequestStatusDetailsState();
}

class RequestStatusDetailsState extends State<RequestStatusDetails> {
  bool isStopped = false;
  var _vendorAndMechanic;
  VendorMechanicTrakcer vendorMechanicTrakcer = VendorMechanicTrakcer();
  Timer? _timer;


  @override
  void initState(){
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
    return PositionedView(
      positionChildWidget: _mainContainer(),
    );
  }

  void getServiceDetails() {}


  Widget _mainContainer() {
    return Container(
        child: Column(children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          requestDetails(),
          const SizedBox(
            height: 5,
          ),
          vendorDetails() ?? SizedBox(height: 0,),
          const SizedBox(
            height: 5,
          ),

          mechanicDetails() ?? SizedBox(height: 0,),
          const SizedBox(
            height: 45,
          ),
          requestStatus(),
          const SizedBox(
            height: 5,
          ),
        ]));
  }

  Widget requestDetails() {
    ServiceRequestManager serviceRequestManager = Provider.of<ServiceRequestManager>(context, listen: false);
    return Container(
        padding: const EdgeInsets.all(5),
        //margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 1.5)
          //color: Colors.purple,
        ),
        child: Column(
          children: [
            const Text("Request Details",
                style: TextStyle(fontSize: 20, color: Colors.yellow)),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                const Text(
                  "Request ID: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                    serviceRequestManager.serviceRequestDTO.id.toString() ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))
              ],
            ),
            Row(
              children: [
                const Text(
                  "Service Type: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(serviceRequestManager.serviceRequestDTO.serviceType ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "Make: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(serviceRequestManager.serviceRequestDTO.make ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "Vehicle Number: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                    serviceRequestManager.serviceRequestDTO.vehicleNumber ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  Widget? vendorDetails() {
    ServiceRequestManager serviceRequestManager = Provider.of<ServiceRequestManager>(context, listen: false);
    if (_vendorAndMechanic != null) {
      var vendor = _vendorAndMechanic["vendor"] ?? "";

      return Container(
          padding: const EdgeInsets.all(5),
          // margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 1.5)),
          child: Column(
            children: [
              const Text("Vendor Details",
                  style: TextStyle(fontSize: 20, color: Colors.yellow)),
              const SizedBox(
                height: 30,
              ),
              if (serviceRequestManager.serviceRequestDTO.acceptedByVendor == null)
                /*const SpinKitFadingCircle(
                  color: Colors.white,
                  size: 100.0,
                ),*/
              Row(
                children: [
                  const Text(
                    "Name: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(vendor["ownerName"] ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    "GarageName: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(vendor["garrageName"] ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    "PhoneNumber: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(vendor["phoneNumber"] ?? "",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ));
    }
    return null;
  }

  Widget? mechanicDetails() {

    ServiceRequestManager serviceRequestManager =
    Provider.of<ServiceRequestManager>(context, listen: false);
    if (_vendorAndMechanic != null) {
      //var mechanic = _vendorAndMechanic["mechanic"] ?? "";

      return Container(
          padding: const EdgeInsets.all(5),
          // margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 1.5)),
          child: Column(
            children: [
              const Text("Mechanic Details",
                  style: TextStyle(fontSize: 20, color: Colors.yellow)),
              const SizedBox(
                height: 30,
              ),
              if (serviceRequestManager.serviceRequestDTO.acceptedByVendor ==
                  null)
                /*const SpinKitFadingCircle(
                  color: Colors.white,
                  size: 100.0,
                ),*/
              Row(
                children: [
                  const Text(
                    "Name: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text( _vendorAndMechanic["name"] ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))
                ],
              ),
              Row(
                children: [
                  const Text(
                    "PhoneNumber: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(_vendorAndMechanic["phoneNumber"] ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ));
    }
    return null;
  }

  Future<void> getMechanicDetails(VendorMechanicTrakcer vendorMechanicTrakcer) async {

    ServiceRequestManager serviceRequestManager =
    Provider.of<ServiceRequestManager>(context, listen: false);
    http.Response response = await
    http.get(Uri.parse("${res.APP_URL}/api/servicerequest/service_request/${serviceRequestManager.serviceRequestDTO.id}"));
    var json = jsonDecode(response.body);
    //log("json: ${json["assignedToMechanic"]}");
    if (json["assignedToMechanic"] != 0) {
      //log("json: $json");
      setState(() => isStopped = true);

      response = await
      http.get(Uri.parse("${res.APP_URL}/api/vendorstaff/${json["assignedToMechanic"]}"));
      json = jsonDecode(response.body);
      setState(() {
        _vendorAndMechanic = json;
      });
      //log("mechanic: $json");
    }
  }

  Future<void> getMechanicData(VendorMechanicTrakcer vendorMechanicTrakcer) async {
    ServiceRequestManager serviceRequestManager =
    Provider.of<ServiceRequestManager>(context, listen: false);
    http.Response response = await
    http.get(Uri.parse("${res.APP_URL}/api/servicerequest/service_request/${serviceRequestManager.serviceRequestDTO.id}"));
    var json = jsonDecode(response.body);
    //log("json: ${json["assignedToMechanic"]}");
    if (json["assignedToMechanic"] != 0) {
      //log("json: $json");
      setState(() => isStopped = true);
      // /api/vendorstaff
      response = await
      http.get(Uri.parse("${res.APP_URL}/api/vendorstaff/${json["assignedToMechanic"]}"));
      json = jsonDecode(response.body);
      //log("mechanic: $json");
    }
  }

  Widget requestStatus() {
    ServiceRequestManager serviceRequestManager = Provider.of<ServiceRequestManager>(context, listen: false);
    ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
    return Container(
        padding: const EdgeInsets.all(5),
        //  margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white, width: 1.5)),
        child: IconButton(
          icon: const Icon(Icons.directions, color: Colors.white,),
          onPressed: () {}
            /*Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => {}
                    //LocationTrackingMap(_vendorAndMechanic["id"].toString())));
          },*/
        //)
    ));
  }
}
