import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:untitled/manager/vendor_mechanic_manager.dart';
import 'package:untitled/screens/customer_board.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/screens/vendor_inprogrees_screen.dart';
import 'package:untitled/utils/add_space.dart';

import '../model/servie_request.dart';
import '../resources/resources.dart' as res;
import 'package:http/http.dart' as http;

typedef CallBack = void Function();

class CustomerFavoriteMechanic extends StatefulWidget {
  CustomerFavoriteMechanic({Key? key})
      : super(key: key);

  @override
  VendorMechanicDashBoardState createState() => VendorMechanicDashBoardState();
}

class VendorMechanicDashBoardState extends State<CustomerFavoriteMechanic> {
  TextEditingController phoneNumberController = TextEditingController();
  final bool _validate = false;
  final String _error = "";
  List<ServiceRequestDTO> serviceRequests = [];

  Future<List<ServiceRequestDTO>> getNewRequests() async {
    VendorMechanicManager vendorMechanicManager =
    Provider.of<VendorMechanicManager>(context, listen: false);
    log("id: ${vendorMechanicManager.vendorMechanic.id}");
    http.Response response = await http.get(Uri.parse(
        "${res.APP_URL}/api/servicerequest/by_mechanic/${vendorMechanicManager.vendorMechanic.id}"));
    var jsonList = jsonDecode(response.body) as List;
    var jsonResponse = jsonDecode(response.body);
    List<ServiceRequestDTO> list = [];
    for (var item in jsonResponse) {
      list.add(ServiceRequestDTO.fromJson(item));
    }
    return list;
    //return jsonList.map((request) => { ServiceRequestDTO.fromJson(request)}).cast<ServiceRequestDTO>().toList();
  }

  @override
  void initState() {
    super.initState();
    getNewRequests().then((requests) {
      requests = requests.where((element) => element.status == 'VENDOR_ACCEPTED').toList();
      requests.sort((b, a) => a.id?.compareTo(b?.id as num) as int);
      setState(() => serviceRequests = requests);
    }).catchError((error) => log("error: $error"));
    //log("${jsonEncode(requestCounts)}");
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        primary: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () => {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
                return const CustomerDashBoard();
              })
          )
        },
        child: const Icon(Icons.arrow_back),
      ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Run Wheelz",
                        style: TextStyle(color: Colors.white, fontSize: 23)),
                    addHorizontalSpace(70),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (BuildContext context) {
                                return VendorDashboardProfile(isMechanic: true,);
                              }));
                        },
                        icon: const Icon(
                          Icons.account_circle_rounded,
                          color: Colors.white,
                        )),
                    addHorizontalSpace(20),
                  ],
                )),
          ),
        ),
        body: SafeArea(
            child: SizedBox(
                width: double.infinity,
                child: Column(children: [
                  const SizedBox(
                    height: 80,
                  ),
                  const Text(
                    "Mechanic Assigned Tasks",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: SearchableList<ServiceRequestDTO>(
                          initialList: serviceRequests,
                          builder: (ServiceRequestDTO newRequest) => Item(
                            serviceRequestDTO: newRequest,
                          ),
                          filter: (value) => serviceRequests
                              .where((element) =>
                              element.id.toString().contains(value))
                              .toList(),
                          onItemSelected: (ServiceRequestDTO item) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return VendorInprogressScreen(
                                    serviceRequestDTO: item,
                                    isFromMechanic: true, pageTitle: '',
                                  );
                                }));
                          },
                          inputDecoration: InputDecoration(
                            labelText: "Search ",
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ))
                ]))));
  }
}

class Item extends StatelessWidget {
  ServiceRequestDTO? serviceRequestDTO;
  Item({Key? key, this.serviceRequestDTO}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          /*boxShadow: const <BoxShadow>[
             BoxShadow(color: Colors.black45,
                 blurRadius: 10,
                 offset: Offset(5, 5)),
             BoxShadow(color: Colors.black45,
                 blurRadius: 10,
                 offset: Offset(10, 10))
           ]*/
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(
                  Icons.remove_red_eye,
                  color: Colors.purple,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("Service: "),
                SizedBox(
                  width: 10,
                ),
                Text(serviceRequestDTO?.serviceType ?? "")
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text("Request ID: "),
                SizedBox(
                  width: 10,
                ),
                Text(serviceRequestDTO?.id.toString() ?? "0000")
              ],
            )
          ],
        ));
  }
}
