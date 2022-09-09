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


class CustomerArgs {
  int? id;
  String? name;
  String? phoneNumber;

  CustomerArgs({
    this.id,
    this.name,
    this.phoneNumber
  });
}

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
  CustomerArgs? customerArgs;

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
      this.comments,
        this.customerArgs
      });
}

class VendorRequestAcceptScreen extends StatefulWidget {
  static const routeName = '/vendor_accept_screen';
  const VendorRequestAcceptScreen({Key? key}) : super(key: key);


  @override
  _VendorRequestAcceptScreen createState() => _VendorRequestAcceptScreen();
}

class _VendorRequestAcceptScreen extends State<VendorRequestAcceptScreen> {
  List<VendorMechanic> _vendorMechanics = [];
  VendorMechanic _selectedMechanic = VendorMechanic();
  String _dropDownMechanicValue = "";

  @override
  void initState() {
    super.initState();
    getMechanics().then((mechanics) {
      setState(() => _vendorMechanics = mechanics);
      _dropDownMechanicValue = _vendorMechanics[0].name ?? "";
      _selectedMechanic = _vendorMechanics[0];
    })
    .catchError((error) => log("error"));
  }

  Future<List<VendorMechanic>> getMechanics() async {
    http.Response response = await http.get(Uri.parse("${res.APP_URL}/api/vendorstaff/getallmechanics"));
    var jsonList = jsonDecode(response.body) as List;
    List<VendorMechanic> vendorMechanicList = [];

    return jsonList.map((mechanic) => VendorMechanic.fromJson(mechanic)).toList();

  }

  @override
  Widget build(BuildContext context) {
/*
    VendorMechanicManager vendorMechanicManager = Provider.of<VendorMechanicManager>(context);
    VendorMechanic vendorMechanic = vendorMechanicManager.vendorMechanicList[0];*/
    final args = ModalRoute.of(context)!.settings.arguments as ServiceRequestArgs;

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
          automaticallyImplyLeading: false,
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
            height: 500,
            margin: const EdgeInsets.only(top: 0, left: 20, right: 20),
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
                const SizedBox(
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
                const SizedBox(
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
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: const [
                    Text(
                      "Latitude: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("127.11")
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: const [
                    Text(
                      "Longitude: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("77.23")
                  ],
                ),
                const SizedBox(
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

                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text(
                      "Customer Name: ",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(args.customerArgs?.phoneNumber ?? "")
                  ],
                ),
                const SizedBox(height: 30,),
                Row(
                  children: [
                    const Text("Mechanic", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    const SizedBox(width: 20,),
                    DropdownButton<String>(
                        value: _dropDownMechanicValue,
                        items: _vendorMechanics.map<DropdownMenuItem<String>>((item) {
                          return DropdownMenuItem<String>(
                              value: item.name,
                              child: Text(item.name ?? "")
                          );
                        }).toList(),
                        onChanged: (val) {
                          _dropDownMechanicValue = val!;
                           _selectedMechanic = _vendorMechanics.firstWhere((element) => element.name == val);
                          log("vendoMechanicId: ${_selectedMechanic.id}");
                        }
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (args.status == "VENDOR_ACCEPTED") {
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
                            serviceRequestDTO.status = 'VENDOR_ACCEPTED';
                            serviceRequestDTO.acceptedByVendor = Provider.of<VendorManager>(context, listen: false).vendorRegistrationRequest.id;
                            serviceRequestDTO.assignedToMechanic = _selectedMechanic.id;
                            log("vendoMechanicId: ${_selectedMechanic.id}");
                            log("vendoMechanicId: ${_selectedMechanic.deviceToken}");
                            log("ServiceRequestDTO: ${jsonEncode(serviceRequestDTO)}");
                            Map<String, String> headers = {
                              'Content-type': 'application/json',
                              'Accept': 'application/json',
                            };
                            response = await http.put(
                                Uri.parse("${res.APP_URL}/api/servicerequest/update"),
                                body: jsonEncode(serviceRequestDTO),
                                headers: headers
                            );
                            log("url: ${res.APP_URL}/api/vendorstaff/sendNotification?deviceToken=${_selectedMechanic.deviceToken}&requestId=${serviceRequestDTO.id}}");
                            response =
                            await http.get(Uri.parse("${res.APP_URL}/api/vendorstaff/sendNotification?deviceToken=${_selectedMechanic.deviceToken}&requestId=${serviceRequestDTO.id}"));
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return const VendorDashBoard();
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
