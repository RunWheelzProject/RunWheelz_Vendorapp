import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/components/side_menu.dart';
import 'package:untitled/screens/customer_favorite_mechnic.dart';
import 'package:untitled/screens/customer_reqeust_history.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/utils/add_space.dart';

import '../manager/profile_manager.dart';
import '../model/servie_request.dart';
import '../screens/current_offers.dart';
import '../screens/customer_board.dart';

import '../resources/resources.dart' as res;

import 'package:http/http.dart' as http;

import '../screens/data_viewer_screen.dart';
import '../screens/preferred_mechanics.dart';


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

  Future<bool> userLogOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool res = await prefs.setBool("SHARED_LOGGED", false);
    await prefs.remove("vendorDTO");
    await prefs.remove("vendorStaffDTO");
    await prefs.remove("customerDTO");
    await prefs.remove("runwheelzStaffDTO");
    return res;
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.pushNamed(context, '/customer_profile');
        break;
      case 1:
        userLogOut().then((res) {
          if (res) {
            Navigator.pushNamed(context, '/ask_login');
          }
        });

    }
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
          // title: Text("Run Wheelz"),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/customer_dashboard');
              },
              child: const Center( child: Text("Run Wheelz", style: TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 25),
            PopupMenuButton<int>(
              offset: const Offset(45, 58),
              color: Colors.white70,
              icon: const Icon(Icons.person,),
              onSelected: (item) =>  onSelected(context, item),
              itemBuilder: (context) => [
                const PopupMenuItem<int>(
                  value: 0,
                  child: ListTile(
                    leading: Icon(Icons.person, color: Colors.purple,

                    ),
                    title: Text('Profile'),
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.purple),
                    title: Text('Log out'),
                  ),
                ),
              ],
            ),
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
          ],
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
                    navigateTo: const PreferredMechanic()
                ),
                RWMap(
                    title: "Today Offers",
                    icon: const Icon(Icons.person, color: Colors.deepPurple,),
                    navigateTo: CurrentOffersScreen()
                )
              ],
            )

        ),
        body: widget.child
    );
  }
}
