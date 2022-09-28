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
import 'package:untitled/components/card_header.dart';
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
import '../utils/get_location.dart';
import 'data_viewer_screen.dart';

class VendorInprogressScreen extends StatefulWidget {
  bool isCustomer;
  bool isVendor;
  final String pageTitle;
  ServiceRequestDTO? serviceRequestDTO;
  bool isMechanic;

  VendorInprogressScreen(
      {Key? key,
        this.serviceRequestDTO,
        this.isCustomer = false,
        this.isVendor = false,
        this.isMechanic = false,
        required this.pageTitle})
      : super(key: key);

  @override
  VendorInprogressScreenState createState() => VendorInprogressScreenState();
}

class VendorInprogressScreenState extends State<VendorInprogressScreen> {
  VendorMechanic? _vendorMechanic;
  CustomerDTO? _customer;
  String _dropDownMechanicValue = 'Select';
  LatLng? _mechanicLatLng;
  List<String> _statusUpdateList = [];
  List<Row> serviceRows = [];
  String? _serviceLocation;

  Future<List<ServiceRequestDTO>> getNewRequests() async {
    ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
    int? id = widget.isCustomer ? profileManager.customerDTO.id : profileManager.vendorDTO.id;
    http.Response response = await http.get(Uri.parse("${res.APP_URL}/api/servicerequest/by_vendor/$id"));
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

  Future<CustomerDTO> getCustomerById(int? id) async {
    http.Response response =
        await http.get(Uri.parse("${res.APP_URL}/api/customer/$id"));
    var jsonResponse = jsonDecode(response.body);
    return CustomerDTO.fromJson(jsonResponse);
  }

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
                overflow: TextOverflow.ellipsis,
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

    getServiceLocation(
        widget.serviceRequestDTO?.latitude ?? 0.0,
        widget.serviceRequestDTO?.longitude ?? 0.0
    ).then((String location) => setState(() => _serviceLocation = location));



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

    getCustomerById(widget.serviceRequestDTO?.requestedCustomer).then((customer) {
      log("customer: ${jsonEncode(customer)}");
      setState(() => _customer = customer);
    }).catchError((error) => log("$error"));

    log(jsonEncode(widget.serviceRequestDTO));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          if (widget.isMechanic) {
            Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) {
              return VendorMechanicDashBoard(requestId: '');
            }));
          }else {
            getNewRequests().then((requests) {
              requests = requests.where((element) {
                    if (widget.pageTitle == "In Progress") {
                      if (element.status == "VENDOR_INPROGRESS") return true;
                    }
                    if (widget.pageTitle == "New Requests") {
                      if (element.status == "VENDOR_ACCEPTED") return true;
                    }
                    if (widget.pageTitle == "Pending Requests") {
                      if (element.status == "VENDOR_PENDING") return true;
                    }
                    return false;
              }).toList();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return VendorDataManagementPage(
                        pageTitle: widget.pageTitle,
                        serviceRequestList: requests,
                        isCustomer: widget.isCustomer,
                        isVendor: widget.isVendor,
                        isMechanic: widget.isMechanic,
                    );
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
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
          children: [
            CardWithHeader(
              title: "Request Details",
                children: createRows([
                  ["Service Type", widget.serviceRequestDTO?.serviceType],
                  ["Make", widget.serviceRequestDTO?.make],
                  ["Vehicle Number", widget.serviceRequestDTO?.vehicleNumber],
                  ["Location", _serviceLocation]
                ])
            ),
            const SizedBox(height: 20,),
            CardWithHeader(
                title: "Customer Details",
                children: createRows([
                  ["Name", _customer?.name],
                  ["Phone", _customer?.phoneNumber],
                ])
            ),
            const SizedBox(height: 20,),
            if (widget.isMechanic == false)
            CardWithHeader(
                title: "Mechanic Details",
                children: createRows([
                  ["Name", _vendorMechanic?.name],
                  ["Phone", _vendorMechanic?.phoneNumber],
                ])
            ),
            if (widget.isVendor)
              Container(
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
                              const SizedBox(width: 20,),
                              ElevatedButton(
                                child: const Text("Track Mechanic"),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LocationTrackingMap(
                                        id: _vendorMechanic?.id.toString() ?? "",
                                        requestId: widget.serviceRequestDTO?.id.toString() ?? "",
                                        customerLatLng: LatLng(
                                            widget.serviceRequestDTO?.latitude ?? 0.0,
                                            widget.serviceRequestDTO?.longitude ?? 0.0
                                        ),
                                        mechanicLatLng: _mechanicLatLng as LatLng,
                                      ))
                                  );
                                },
                              )
                            ],
                          );
                        }),
                    const SizedBox(height: 10,),

                  ],
                ),
              ),
            if (widget.isMechanic)
              Container(
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
                              const SizedBox(width: 20,),
                              ElevatedButton(
                                child: const Text("Track Customer"),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LocationTrackingMap(
                                        id: _vendorMechanic?.id.toString() ?? "",
                                        requestId: widget.serviceRequestDTO?.id.toString() ?? "",
                                        customerLatLng: LatLng(
                                            widget.serviceRequestDTO?.latitude ?? 0.0,
                                            widget.serviceRequestDTO?.longitude ?? 0.0
                                        ),
                                        mechanicLatLng: _mechanicLatLng as LatLng,
                                      ))
                                  );
                                },
                              )
                            ],
                          );
                        }),
                    const SizedBox(height: 10,),

                  ],
                ),
              ),
            const SizedBox(height: 20,),
            if (widget.isVendor)
            Container(
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          child: const Text("Update")
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    )));
  }
}
