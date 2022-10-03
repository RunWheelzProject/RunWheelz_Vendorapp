import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/dashboard_box.dart';
import 'package:untitled/components/vendor_appbar.dart';
import 'package:untitled/model/servie_request.dart';
import 'package:untitled/screens/customer_board.dart';
import 'package:untitled/screens/data_viewer_screen.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/utils/add_space.dart';
import '../components/menu.dart';
import '../manager/profile_manager.dart';
import '../manager/vendor_manager.dart';
import '../resources/resources.dart' as res;

import 'package:http/http.dart' as http;


typedef CallBack = void Function();

class VendorDashBoard extends StatefulWidget {
  const VendorDashBoard({Key? key}) : super(key: key);

  @override
  VendorDashBoardState createState() => VendorDashBoardState();
}

class VendorDashBoardState extends State<VendorDashBoard> {
  TextEditingController phoneNumberController = TextEditingController();
  Map<String, int> requestCounts = {
    "VENDOR_ACCEPTED": 0,
    "VENDOR_INPROGRESS": 0,
    "VENDOR_PENDING": 0
  };

  final bool _validate = false;
  final String _error = "";

  @override
  void initState() {
    super.initState();
    setState(() => countRequests());
  }

  Future<List<ServiceRequestDTO>> getNewRequests() async {
    ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
    http.Response response = await
    http.get(Uri.parse("${res.APP_URL}/api/servicerequest/by_vendor/${profileManager.vendorDTO.id}"));
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
          if (status.contains("VENDOR")) {
            requestCounts[status] = (requestCounts[status]! + 1);
          }
        }
      }
      setState(() => {});
    }).catchError((error) => log("error: $error"));
  }


  void goToRequests() {
    getNewRequests().then((requests) {
      requests = requests.where((element) => element.status == 'VENDOR_ACCEPTED').toList();
      requests.sort((b, a) => a.id?.compareTo(b?.id as num) as int);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return VendorDataManagementPage(
                pageTitle: "New Requests",
                serviceRequestList: requests,
                isVendor: true
            );
          })
      );
    }).catchError((error) => log("error: $error"));

  }

  void goToInProgress() {

    getNewRequests().then((requests) {
      requests = requests.where((element) => element.status == 'VENDOR_INPROGRESS').toList();
      requests.sort((b, a) => a.id?.compareTo(b?.id as num) as int);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return VendorDataManagementPage(
                pageTitle: "In Progress",
                serviceRequestList: requests,
                isVendor: true
            );
          })
      );
    }).catchError((error) => log("error: $error"));
  }
  void goToPendingRequests() {

    getNewRequests().then((requests) {
      requests = requests.where((element) => element.status == 'VENDOR_PENDING').toList();
      requests.sort((b, a) => a.id?.compareTo(b?.id as num) as int);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return VendorDataManagementPage(
                pageTitle: "Pending Requests",
                serviceRequestList: requests,
                isVendor: true
            );
          })
      );
    }).catchError((error) => log("error: $error"));
  }

  void goToRaisedRequests() {
    ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
    getNewRequests().then((requests) {
      requests = requests.where((element) => element.status == 'VENDOR_ACCEPTED').toList();
      requests.sort((b, a) => a.id?.compareTo(b?.id as num) as int);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return CustomerDashBoard(isCustomer: true);
          })
      );
    }).catchError((error) => log("error: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return VendorAppBar(
        child: _mainContainer()
    );
  }

  Widget _mainContainer() {
    TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
        child: SingleChildScrollView(
            child: Container(
                height: 500,
                margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
                padding: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white,
                ),
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
                          count: (requestCounts["VENDOR_ACCEPTED"].toString()) ?? "0"
                      ),
                      DashBoardBox(
                          callBack: goToInProgress,
                          icon: const Icon(
                            Icons.file_download,
                            color: Colors.purple,
                            size: 34,
                          ),
                          title: "In Progress",
                          count: (requestCounts["VENDOR_INPROGRESS"].toString()) ?? "0"),
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
                          count: (requestCounts["VENDOR_PENDING"].toString()) ?? "0"),
                      DashBoardBox(
                          callBack: goToRaisedRequests,
                          icon: const Icon(
                            Icons.new_label_outlined,
                            color: Colors.purple,
                            size: 34,
                          ),
                          title: "Raise Request",
                          count: ""
                      ),
                    ],
                  )
                ])
            )
        )
    );
  }
}
