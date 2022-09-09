import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/dashboard_box.dart';
import 'package:untitled/manager/vendor_mechanic_manager.dart';
import 'package:untitled/model/servie_request.dart';
import 'package:untitled/screens/data_viewer_screen.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/screens/profile_vendor.dart';
import 'package:untitled/screens/vendor_dashboard_profile.dart';
import 'package:untitled/utils/add_space.dart';
import '../components/menu.dart';
import '../manager/profile_manager.dart';
import '../manager/vendor_manager.dart';
import '../resources/resources.dart' as res;

import 'package:http/http.dart' as http;

import '../model/vendor.dart';
import '../resources/resources.dart' as res;

typedef CallBack = void Function();

class VendorDashBoard extends StatefulWidget {
  const VendorDashBoard({Key? key}) : super(key: key);

  @override
  VendorDashBoardState createState() => VendorDashBoardState();
}

class VendorDashBoardState extends State<VendorDashBoard> {
  TextEditingController phoneNumberController = TextEditingController();
  Map<String, int> requestCounts = {};

  final bool _validate = false;
  final String _error = "";

  @override
  void initState() {
    super.initState();
    countRequests();
    //log("${jsonEncode(requestCounts)}");
  }

  Future<List<ServiceRequestDTO>> getNewRequests() async {
    VendorManager vendorManager = Provider.of<VendorManager>(context, listen: false);
    log("id: ${vendorManager.vendorRegistrationRequest.id}");
    http.Response response = await
      http.get(Uri.parse("${res.APP_URL}/api/servicerequest/by_vendor/${vendorManager.vendorRegistrationRequest.id}"));
    var jsonList = jsonDecode(response.body) as List;
    var jsonResponse = jsonDecode(response.body);
    List<ServiceRequestDTO> list = [];
    for (var item in jsonResponse) {
      list.add(ServiceRequestDTO.fromJson(item));
    }
    return list;
    //return jsonList.map((request) => { ServiceRequestDTO.fromJson(request)}).cast<ServiceRequestDTO>().toList();
  }

  void countRequests() {
    getNewRequests().then((requests) {
      for (var element in requests) {
        if (element.status != null) {
          String status = element.status as String;
          if (!requestCounts.containsKey(status) && status.contains("VENDOR")) {
            log("Status: $status");
            requestCounts[status] = 1;
          } else {
            log("Status: $status");
            requestCounts[status] = (requestCounts[status] ?? 0 + 1);
          }
        }
      }
      setState(() => {});
    }).catchError((error) => log("error: $error"));
  }

  void buttonHandler(String title, String status) {
    getNewRequests().then((requests) {
      requests = requests.where((element) => element.status == status).toList();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return VendorDataManagementPage(pageTitle: title, serviceRequestList: requests);
          })
      );
    }).catchError((error) => log("error: $error"));

  }

  void goToRequests() {
    getNewRequests().then((requests) {
      requests = requests.where((element) => element.status == 'VENDOR_ACCEPTED').toList();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return VendorDataManagementPage(pageTitle: "New Requests", serviceRequestList: requests);
          })
      );
    }).catchError((error) => log("error: $error"));

  }

  void goToInProgress() {

    getNewRequests().then((requests) {
      requests = requests.where((element) => element.status == 'VENDOR_INPROGRESS').toList();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return VendorDataManagementPage(pageTitle: "In Progress", serviceRequestList: requests);
          })
      );
    }).catchError((error) => log("error: $error"));
  }
  void goToPendingRequests() {

    getNewRequests().then((requests) {
      requests = requests.where((element) => element.status == 'VENDOR_PENDING').toList();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return VendorDataManagementPage(pageTitle: "Pending Requests", serviceRequestList: requests);
          })
      );
    }).catchError((error) => log("error: $error"));
  }

  void goToRaisedRequests() {

    getNewRequests().then((requests) {
      requests = requests.where((element) => element.status == 'VENDOR_ACCEPTED').toList();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return VendorDataManagementPage(pageTitle: "New Requests", serviceRequestList: requests);
          })
      );
    }).catchError((error) => log("error: $error"));
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
        primary: true,
        appBar: AppBar(
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
                            return VendorDashboardProfile();
                          })
                      );
                    },
                    icon: const Icon(
                      Icons.account_circle_rounded,
                      color: Colors.white,
                    )),
                addHorizontalSpace(20),
                const Icon(
                  Icons.notification_add_rounded,
                  color: Colors.white,
                ),
                addHorizontalSpace(20),
              ],
            )),
          ),
        ),
        drawer: Padding(
            padding: const EdgeInsets.fromLTRB(0, 122, 0, 0),
            child: Menu.menuData("menu", res.menuItems)),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                  height: 500,
                  margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
                  padding: const EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 10,
                            blurRadius: 30),
                      ]),
                  child: Column(children: <Widget>[
                    Text(
                      "Vendor Dashboard",
                      style: textTheme.headline4,
                    ),
                    addVerticalSpace(50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DashBoardBox(
                            callBack: goToRequests,
                            icon: const Icon(
                              Icons.notifications_active_outlined,
                              color: Colors.purple,
                              size: 34,
                            ),
                            title: "New Requests",
                            count: (requestCounts["VENDOR_ACCEPTED"].toString())! ?? "0"
                        ),
                        DashBoardBox(
                            callBack: goToInProgress,
                            icon: const Icon(
                              Icons.file_download,
                              color: Colors.purple,
                              size: 34,
                            ),
                            title: "In Progress",
                            count: (requestCounts["VENDOR_INPROGRESS"].toString())! ?? "0"),
                      ],
                    ),
                    addVerticalSpace(40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DashBoardBox(
                            callBack: goToPendingRequests,
                            icon: const Icon(
                              Icons.pending_actions_rounded,
                              color: Colors.purple,
                              size: 34
                            ),
                            title: "Pending Requests",
                            count: (requestCounts["VENDOR_PENDING"].toString())! ?? "0"),
                        DashBoardBox(
                            callBack: goToRaisedRequests,
                            icon: const Icon(
                              Icons.new_label_outlined,
                              color: Colors.purple,
                              size: 34,
                            ),
                            title: "Raise Request",
                            count: "34"
                        ),
                      ],
                    )
                  ])
              )
            )
        )
    );
  }
}
