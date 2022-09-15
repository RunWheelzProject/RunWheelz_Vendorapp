import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/model/vendor_mechanic.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/rw_staff_management_screen.dart';
import 'package:untitled/screens/rw_vendor_management_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
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

class VendorPendingScreen extends StatefulWidget {
  ServiceRequestDTO? serviceRequestDTO;

  VendorPendingScreen({Key? key, this.serviceRequestDTO}) : super(key: key);


  @override
  VendorPendingScreenState createState() => VendorPendingScreenState();
}

class VendorPendingScreenState extends State<VendorPendingScreen> {
  VendorMechanic? _vendorMechanic;
  CustomerDTO? _customer;
  String _dropDownMechanicValue = 'Select';

  Future<List<ServiceRequestDTO>> getNewRequests() async {
    VendorManager vendorManager = Provider.of<VendorManager>(context, listen: false);
    http.Response response = await
    http.get(Uri.parse("${res.APP_URL}/api/servicerequest/by_vendor/${vendorManager.vendorDTO.id}"));
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
    http.Response response = await
    http.get(Uri.parse("${res.APP_URL}/api/vendorstaff/$id"));
    var jsonResponse = jsonDecode(response.body);
    return VendorMechanic.fromJson(jsonResponse);
    //return jsonList.map((request) => { ServiceRequestDTO.fromJson(request)}).cast<ServiceRequestDTO>().toList();
  }

  Future<CustomerDTO> getCustomerById(int? id) async {
    http.Response response = await
    http.get(Uri.parse("${res.APP_URL}/api/customer/$id"));
    var jsonResponse = jsonDecode(response.body);
    return CustomerDTO.fromJson(jsonResponse);
  }

  @override
  void initState() {
    super.initState();

    getMechanicById(widget.serviceRequestDTO?.assignedToMechanic).then((mechanic) {
      setState(() => _vendorMechanic = mechanic);
    }).catchError((error) => log("$error"));


    getCustomerById(widget.serviceRequestDTO?.requestedCustomer).then((customer) {
      setState(() => _customer = customer);
    }).catchError((error) => log("$error"));

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () => {
          getNewRequests().then((requests) {
            requests = requests.where((element) => element.status == 'VENDOR_INPROGRESS').toList();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return VendorDataManagementPage(pageTitle: "In Progress", serviceRequestList: requests);
                })
            );
          }).catchError((error) => log("error: $error"))
        },
        child: const Icon(Icons.arrow_back),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "In Progress",
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
      body: Center(
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
                    child: Text("Service Details",
                      style: TextStyle(color: Colors.deepOrange, fontSize: 20),),
                  ),
                  const SizedBox(height: 30,),
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
                    child: Text("Customer Details",
                      style: TextStyle(color: Colors.deepOrange, fontSize: 20),),
                  ),
                  const SizedBox(height: 30,),
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
              height: 10,
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
                    child: Text("Mechanic Details",
                      style: TextStyle(color: Colors.deepOrange, fontSize: 20),),
                  ),
                  const SizedBox(height: 30,),

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
                          items: ['Select', 'VENDOR_COMPLETED'].map<DropdownMenuItem<String>>((item) {
                            return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item ?? "")
                            );
                          }).toList(),
                          onChanged: (val) {
                            _dropDownMechanicValue = val!;
                          }
                      ),
                      const SizedBox(width: 15,),
                      ElevatedButton(onPressed: () => {}, child: const Text("Update"))
                    ],
                  )

                  /*Text("Request Stauts",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "In Progress",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
