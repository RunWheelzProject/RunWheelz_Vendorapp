import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:untitled/main.dart';
import 'package:untitled/manager/service_request_manager.dart';
import 'package:untitled/manager/vendor_mechanic_manager.dart';
import 'package:untitled/model/servie_request.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/rw_staff_management_screen.dart';
import 'package:untitled/screens/rw_vendor_management_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/screens/vendor_select_mechanic.dart';
import 'package:untitled/services/vendor_registration.dart';

import '../manager/profile_manager.dart';
import '../manager/vendor_manager.dart';
import '../model/staff.dart';
import '../model/vendor_mechanic.dart';
import '../services/staff_service.dart';
import 'package:http/http.dart' as http;
import '../resources/resources.dart' as res;

class ServiceRequestArgs {
  int? id;
  String? serviceType;
  String? make;
  String? vehicleNumber;
  double? latitude;
  double? longitude;
  int? acceptedByVendor;
  int? assignedToMechanic;
  String? status;
  String? comments;

  ServiceRequestArgs(
      {this.id,
      this.serviceType,
      this.make,
      this.vehicleNumber,
      this.latitude,
      this.longitude,
      this.acceptedByVendor,
      this.assignedToMechanic,
      this.status,
      this.comments});
}

class VendorRequestAcceptScreen extends StatelessWidget {
  static const routeName = '/vendor_accept_screen';

  /*void getRequestData(BuildContext context) async {

    final args = ModalRoute.of(context)!.settings.arguments as ServiceRequestArgs;
    final ServiceRequestManager serviceRequestManager = Provider.of<ServiceRequestManager>(context, listen: false);
    log("requestId: ${args.requestID}");

    http.Response response = await http.get(Uri.parse("${res.APP_URL}/api/servicerequest/service_request/${args.requestID}"));
    var responseJson = jsonDecode(response.body);
    log("request: $responseJson");
    serviceRequestManager.serviceRequestDTO = ServiceRequestDTO.fromJson(responseJson);
  }*/


  List<String> mechanics = ['Select Mechanic', "Ravi"];

  @override
  Widget build(BuildContext context) {

    VendorMechanicManager vendorMechanicManager = Provider.of<VendorMechanicManager>(context);
    VendorMechanic vendorMechanic = vendorMechanicManager.vendorMechanicList[0];
    final args = ModalRoute.of(context)!.settings.arguments as ServiceRequestArgs;
    /*final args = ServiceRequestArgs(
      id: 1,
      serviceType: "Breakdown",
      make: "TVS",
      vehicleNumber: "787878",
      latitude: 23.7890,
      longitude: 89.0000,
      acceptedByVendor: 3,
      assignedToMechanic: 2,
      status: "NONE",
      comments: "TEST",
    );*/

    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () => {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return const VendorDashBoard();
            }))
          },
          child: const Icon(Icons.arrow_back),
        ),
        appBar: AppBar(
          title: const Center(
            child: Text(
              "Accept Request",
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        body: Center(
          child: Container(
            height: 450,
            margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, spreadRadius: 10, blurRadius: 30),
                ]),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Service Type: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(args.serviceType ?? "")
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      "make: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(args.make ?? "")
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      "Vehicle Number: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(args.vehicleNumber ?? "")
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      "Latitude: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("127.11")
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      "Longitude: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("77.23")
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: const [
                    Text(
                      "Location: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("lingampalley")
                  ],
                ),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    const Text("Mechanic", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    const SizedBox(width: 20,),
                    DropdownButton<String>(
                        value: vendorMechanicManager.vendorMechanicList[0].name,
                        items: vendorMechanicManager.vendorMechanicList.map<DropdownMenuItem<String>>((item) {
                          return DropdownMenuItem<String>(
                              value: item.name,
                              child: Text(item.name ?? "")
                          );
                        }).toList(),
                        onChanged: (val) {
                          vendorMechanic = vendorMechanicManager.vendorMechanicList.firstWhere((element) => element.name == val);
                        }
                    ),
                  ],
                ),
                SizedBox(
                  height: 70,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (args.status == "ACCEPTED") {
                            showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Service Request'),
                                  content: const Text(
                                      "Request already accepted by other vendor"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Done'),
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return const VendorDashBoard();
                                        }));
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            http.Response response = await http.get(Uri.parse("${res.APP_URL}/api/servicerequest/service_request/${args.id}"));
                            var json = jsonDecode(response.body);
                            ServiceRequestDTO serviceRequestDTO = ServiceRequestDTO.fromJson(json);
                            serviceRequestDTO.status = 'ACCEPTED';
                            serviceRequestDTO.acceptedByVendor = Provider.of<VendorManager>(context, listen: false).vendorRegistrationRequest.id;
                            serviceRequestDTO.assignedToMechanic = vendorMechanic.id;
                            Map<String, String> headers = {
                              'Content-type': 'application/json',
                              'Accept': 'application/json',
                            };
                            response = await http.put(
                                Uri.parse("${res.APP_URL}/api/servicerequest/update"),
                                body: jsonEncode(serviceRequestDTO),
                                headers: headers
                            );

                            response =
                            await http.get(Uri.parse("${res.APP_URL}/api/vendorstaff/sendNotification/?deviceToken=${vendorMechanic.deviceToken}&requestId=${serviceRequestDTO.id}"));
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return VendorSelectMechanicScreen();
                            }));
                          }
                        },
                        child: const Text("Accept")))
              ],
            ),
          ),
        ));
  }
}
