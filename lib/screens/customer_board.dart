import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/dashboard_box.dart';
import 'package:untitled/manager/preferred_mechanic_manager.dart';
import 'package:untitled/model/servie_request.dart';
import 'package:untitled/screens/breakdown_services.dart';
import 'package:untitled/screens/customer_favorite_mechnic.dart';
import 'package:untitled/screens/customer_reqeust_history.dart';
import 'package:untitled/screens/data_viewer_screen.dart';
import 'package:untitled/screens/general_services_screen.dart';
import 'package:untitled/screens/preferred_mechanic_add.dart';
import 'package:untitled/screens/preferred_mechanics.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/utils/add_space.dart';
import '../components/menu.dart';
import '../manager/profile_manager.dart';
import '../manager/vendor_manager.dart';
import '../resources/resources.dart' as res;

import 'package:http/http.dart' as http;

import '../services/preferred_mechanic_service.dart';


typedef CallBack = void Function();

class CustomerDashBoard extends StatefulWidget {
  bool isVendor;
  bool isCustomer;
  CustomerDashBoard({Key? key, this.isVendor = false, this.isCustomer = false}) : super(key: key);

  @override
  CustomerDashBoardState createState() => CustomerDashBoardState();
}

class CustomerDashBoardState extends State<CustomerDashBoard> {
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
    int id = Provider.of<ProfileManager>(context, listen: false).customerDTO.id ?? 0;
    PreferredMechanicManager preferredMechanicManager = Provider.of<PreferredMechanicManager>(context, listen: false);
    PreferredMechanicService().getAllPreferredMechanics(id).then((vendors) {
      setState(() => preferredMechanicManager.preferredMechanicList = vendors);
    });
  }

  Future<List<ServiceRequestDTO>> getNewRequests() async {
    ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
    http.Response response = await
    http.get(Uri.parse("${res.APP_URL}/api/servicerequest/by_customer/${profileManager.customerDTO.id}"));
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
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) {
          return const GeneralServices();
        })
    );
  }

  void goToInProgress() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return const BreakDownServices();
          })
      );
  }
  void goToPendingRequests() {

    getNewRequests().then((requests) {
      requests = requests.where((element) => element.status == 'VENDOR_PENDING').toList();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return VendorDataManagementPage(
                pageTitle: "Pending Requests",
                serviceRequestList: requests,
                isCustomer: true,
            );
          })
      );
    }).catchError((error) => log("error: $error"));
  }

  void goToRaisedRequests() {

    getNewRequests().then((requests) {
      requests = requests.where((element) => element.status == 'VENDOR_ACCEPTED').toList();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return VendorDataManagementPage(
                pageTitle: "New Requests",
                serviceRequestList: requests,
                isCustomer: true
            );
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
                                return VendorDashboardProfile(isCustomer: widget.isCustomer, isVendor: widget.isVendor);
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
            child: Drawer(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('Home', style: TextStyle(color: Colors.red, fontSize: 16),),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return CustomerDashBoard(isCustomer: widget.isCustomer, isVendor: widget.isVendor);
                            })
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Request History', style: TextStyle(color: Colors.red, fontSize: 16),),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return const CustomerRequestHistory();
                            })
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('My Mechanics', style: TextStyle(color: Colors.red, fontSize: 16),),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return const PreferredMechanic();
                            })
                        );
                      },
                    ),
                  ],
                )
            )),
        body: SafeArea(
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
                      const Text(
                        "Customer Dashboards",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 21
                        )
                      ),
                      addVerticalSpace(50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomerDashBoardBox(
                              callBack: goToRequests,
                              icon: const Icon(
                                Icons.notifications_active_outlined,
                                color: Colors.purple,
                                size: 34,
                              ),
                              title: "General Services",
                          ),
                          CustomerDashBoardBox(
                              callBack: goToInProgress,
                              icon: const Icon(
                                Icons.file_download,
                                color: Colors.purple,
                                size: 34,
                              ),
                              title: "BreakDown",
                          ),
                        ],
                      ),
                      addVerticalSpace(40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CustomerDashBoardBox(
                              callBack: goToPendingRequests,
                              icon: const Icon(
                                  Icons.pending_actions_rounded,
                                  color: Colors.purple,
                                  size: 34
                              ),
                              title: "Towing",
                          ),
                          CustomerDashBoardBox(
                              callBack: goToRaisedRequests,
                              icon: const Icon(
                                Icons.new_label_outlined,
                                color: Colors.purple,
                                size: 34,
                              ),
                              title: "After Marketing",
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


typedef OnClick = void Function();

class CustomerDashBoardBox extends StatefulWidget {
  final OnClick callBack;
  final Icon icon;
  final String title;
  const CustomerDashBoardBox({Key? key, required this.callBack, required this.icon, required this.title}) : super(key: key);

  @override
  CustomerDashBoardBoxState createState() => CustomerDashBoardBoxState();
}

class CustomerDashBoardBoxState extends State<CustomerDashBoardBox> {


  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
        onTap: widget.callBack,
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[100] as Color),
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ]),
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.icon,
                addVerticalSpace(20),
                Text(
                  widget.title,
                  style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                ),
              ]),
        )
    );
  }
}
