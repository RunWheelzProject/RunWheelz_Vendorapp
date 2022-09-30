import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/side_menu.dart';
import 'package:untitled/screens/customer_favorite_mechnic.dart';
import 'package:untitled/screens/customer_reqeust_history.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/utils/add_space.dart';

import '../manager/profile_manager.dart';
import '../model/servie_request.dart';
import '../screens/customer_board.dart';

import '../resources/resources.dart' as res;

import 'package:http/http.dart' as http;

import '../screens/data_viewer_screen.dart';


class CustomerAppBar extends StatefulWidget {
  Widget child;

  CustomerAppBar({super.key, required this.child});

  @override
  CustomerAppBarState createState() => CustomerAppBarState();

}

class CustomerAppBarState extends State<CustomerAppBar> {

  int _notificationCount = 0;

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


  void goToRequests({bool notification = false}) {
    getNewRequests().then((requests) {
      requests = requests.where((element) => element.status == 'VENDOR_ACCEPTED').toList();
      requests.sort((b, a) => a.id?.compareTo(b?.id as num) as int);
      // log("accepted: ${jsonEncode(requests)}");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return VendorDataManagementPage(
              pageTitle: "Notifications",
              serviceRequestList: requests,
              isCustomer: true,
              isCustomerNotification: true,
            );
          })
      );
    }).catchError((error) => log("error: $error"));

  }

  @override
  void initState() {
    super.initState();
    getNewRequests().then((requests) {
      setState(() {
        _notificationCount= requests.where((element) => element.status == 'VENDOR_ACCEPTED').toList().length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        style: TextStyle(color: Colors.white, fontSize: 23)
                    ),
                    addHorizontalSpace(70),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return VendorDashboardProfile(
                                        isCustomer: true
                                    );
                                  })
                          );
                        },
                        icon: const Icon(
                          Icons.account_circle_rounded,
                          color: Colors.white,
                        )),
                    addHorizontalSpace(20),
                    IconBadge(
                      icon: const Icon(Icons.notifications_none, color: Colors.white),
                      itemCount: _notificationCount,
                      badgeColor: Colors.red,
                      itemColor: Colors.white,
                      maxCount: 99,
                      hideZero: true,
                      onTap: () {
                        goToRequests();
                      },
                    ),
                    addHorizontalSpace(20),
                  ],
                )),
          ),
        ),
        drawer: Padding(
            padding: const EdgeInsets.fromLTRB(0, 122, 0, 0),
            child: SideMenu(
              menuList: [
                RWMap(
                    title: "Home",
                    icon: const Icon(Icons.home, color: Colors.deepPurple,),
                    navigateTo: CustomerDashBoard(isCustomer: true)
                ),
                RWMap(
                    title: "Request History",
                    icon: const Icon(Icons.history, color: Colors.deepPurple,),
                    navigateTo: const CustomerRequestHistory()
                ),
                RWMap(
                    title: "My Mechanic",
                    icon: const Icon(Icons.person, color: Colors.deepPurple,),
                    navigateTo: CustomerFavoriteMechanic()
                )
              ],
            )

        ),
        body: widget.child
    );
  }
}
