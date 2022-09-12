import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/model/vendor_mechanic.dart';
import 'package:untitled/screens/live_track_map.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/rw_staff_management_screen.dart';
import 'package:untitled/screens/rw_vendor_management_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/screens/vendor_mechanic_dashboard.dart';
import 'package:untitled/services/vendor_registration.dart';
import '../model/customer.dart';
import '../resources/resources.dart' as res;
import 'package:http/http.dart' as http;
import '../manager/profile_manager.dart';
import '../manager/vendor_manager.dart';
import '../model/servie_request.dart';
import '../model/staff.dart';
import '../services/staff_service.dart';
import 'data_viewer_screen.dart';

class VendorInprogressScreen extends StatefulWidget {
  final String pageTitle;
  ServiceRequestDTO? serviceRequestDTO;
  bool isFromMechanic;

  VendorInprogressScreen(
      {Key? key, this.serviceRequestDTO, this.isFromMechanic = false, required this.pageTitle})
      : super(key: key);

  @override
  VendorInprogressScreenState createState() => VendorInprogressScreenState();
}

class VendorInprogressScreenState extends State<VendorInprogressScreen> {
  VendorMechanic? _vendorMechanic;
  Customer? _customer;
  String _dropDownMechanicValue = 'Select';
  LatLng? _mechanicLatLng;
  List<String> _statusUpdateList = [];


  Future<List<ServiceRequestDTO>> getNewRequests() async {
    VendorManager vendorManager =
        Provider.of<VendorManager>(context, listen: false);
    http.Response response = await http.get(Uri.parse(
        "${res.APP_URL}/api/servicerequest/by_vendor/${vendorManager.vendorRegistrationRequest.id}"));
    var jsonList = jsonDecode(response.body) as List;
    var jsonResponse = jsonDecode(response.body);
    List<ServiceRequestDTO> list = [];
    for (var item in jsonResponse) {
      list.add(ServiceRequestDTO.fromJson(item));
    }
    return list;
    //return jsonList.map((request) => { ServiceRequestDTO.fromJson(request)}).cast<ServiceRequestDTO>().toList();
  }

  Future<VendorMechanic> getMechanicById(int? id) async {
    http.Response response =
        await http.get(Uri.parse("${res.APP_URL}/api/vendorstaff/$id"));
    var jsonResponse = jsonDecode(response.body);
    return VendorMechanic.fromJson(jsonResponse);
    //return jsonList.map((request) => { ServiceRequestDTO.fromJson(request)}).cast<ServiceRequestDTO>().toList();
  }

  Future<Customer> getCustomerById(int? id) async {
    http.Response response =
        await http.get(Uri.parse("${res.APP_URL}/api/customer/$id"));
    var jsonResponse = jsonDecode(response.body);
    return Customer.fromJson(jsonResponse);
  }

  @override
  void initState() {
    super.initState();

    if (widget.pageTitle == "In Progress") {
      setState(() => _statusUpdateList = ['Select', 'VENDOR_PENDING', 'VENDOR_COMPLETED']);
    }

    if (widget.pageTitle == "New Requests") {
      setState(() => _statusUpdateList = ['Select', 'VENDOR_INPROGRESS', 'VENDOR_PENDING', 'VENDOR_COMPLETED']);
    }

    if (widget.pageTitle == "Pending Requests") {
      setState(() => _statusUpdateList = ['Select','VENDOR_COMPLETED']);
    }


    getMechanicById(widget.serviceRequestDTO?.assignedToMechanic)
        .then((mechanic) {
      setState(() => _vendorMechanic = mechanic);
    }).catchError((error) => log("$error"));

    getCustomerById(widget.serviceRequestDTO?.requestedCustomer)
        .then((customer) {
      setState(() => _customer = customer);
    }).catchError((error) => log("$error"));

    log("${jsonEncode(widget.serviceRequestDTO)}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          if (widget.isFromMechanic) {
            log("yesssssssssss");
            Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) {
              return VendorMechanicDashBoard(requestId: '');
            }));
          }else {
            getNewRequests().then((requests) {
              requests = requests
                  .where((element) => element.status == 'VENDOR_INPROGRESS')
                  .toList();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return VendorDataManagementPage(
                        pageTitle: "In Progress", serviceRequestList: requests);
                  }));
            }).catchError((error) => log("error: $error"));
          }
        },
        child: const Icon(Icons.arrow_back),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "Service Request",
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(child: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Service Details",
                      style: TextStyle(color: Colors.deepOrange, fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        "ServiceType : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(widget.serviceRequestDTO?.serviceType ?? "")
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
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(widget.serviceRequestDTO?.make ?? "")
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Vehicle Number : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(widget.serviceRequestDTO?.vehicleNumber ?? "")
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Location: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("lingampalley")
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Customer Details",
                      style: TextStyle(color: Colors.deepOrange, fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Name : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(_customer?.name ?? "")
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
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(_customer?.phoneNumber ?? "")
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (!widget.isFromMechanic)
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Mechanic Details",
                      style: TextStyle(color: Colors.deepOrange, fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Name: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(_vendorMechanic?.name ?? "")
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        "Mobile Number: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(_vendorMechanic?.phoneNumber ?? "")
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            if (widget.isFromMechanic)
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
                        stream: FirebaseFirestore.instance
                            .collection('location')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          _mechanicLatLng = LatLng(
                              snapshot.data!.docs.singleWhere(
                                      (element) =>
                                  element.id ==
                                      _vendorMechanic?.id
                                          .toString())['latitude'],
                              snapshot.data!.docs.singleWhere(
                                      (element) =>
                                  element.id ==
                                      _vendorMechanic?.id
                                          .toString())['longitude']);
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Distance: ", style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(double.parse((Geolocator.distanceBetween(
                                  widget.serviceRequestDTO?.latitude ??
                                      0.0,
                                  widget.serviceRequestDTO?.longitude ??
                                      0.0,
                                  snapshot.data!.docs.singleWhere((element) =>
                                  element.id ==
                                      _vendorMechanic?.id.toString())[
                                  'latitude'],
                                  snapshot.data!.docs.singleWhere(
                                          (element) =>
                                      element.id ==
                                          _vendorMechanic?.id
                                              .toString())['longitude']) / 1000).toStringAsFixed(2))
                                  .toString()),
                              SizedBox(width: 20,),
                              ElevatedButton(
                                child: const Text("Track Customer"),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LocationTrackingMap(
                                        id: _vendorMechanic?.id
                                            .toString() ??
                                            "",
                                        requestId: widget
                                            .serviceRequestDTO?.id
                                            .toString() ??
                                            "",
                                        customerLatLng: LatLng(
                                            widget.serviceRequestDTO
                                                ?.latitude ??
                                                0.0,
                                            widget.serviceRequestDTO
                                                ?.longitude ??
                                                0.0),
                                        mechanicLatLng:
                                        _mechanicLatLng as LatLng,
                                      ))
                                  );
                                },
                              )
                            ],
                          );
                        }),
                    SizedBox(height: 10,),

                  ],
                ),
              ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropdownButton<String>(
                          value: _dropDownMechanicValue,
                          items: _statusUpdateList
                              .map<DropdownMenuItem<String>>((item) {
                            return DropdownMenuItem<String>(
                                value: item, child: Text(item ?? ""));
                          }).toList(),
                          onChanged: (val) {
                            setState(() => _dropDownMechanicValue = val!);
                          }),
                      const SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            widget.serviceRequestDTO?.status = _dropDownMechanicValue;
                            Map<String, String> headers = {
                              'Content-type': 'application/json',
                              'Accept': 'application/json',
                            };
                            http.Response response = await http.put(
                            Uri.parse("${res.APP_URL}/api/servicerequest/update"),
                            body: jsonEncode(widget.serviceRequestDTO),
                            headers: headers
                            );
                            if (response.statusCode == 200) {
                              showDialog<void>(
                                context: context,
                                barrierDismissible:
                                false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Updated'),
                                    content: Text(
                                        "Status updated to ${_dropDownMechanicValue}"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Done'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              showDialog<void>(
                                context: context,
                                barrierDismissible:
                                false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Not Updated'),
                                    content: Text(
                                        "Could not approved error status: ${response.statusCode}"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Done'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: const Text("Update")),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
