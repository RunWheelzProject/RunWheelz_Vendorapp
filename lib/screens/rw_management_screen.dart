import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:untitled/manager/staff_manager.dart';
import 'package:untitled/manager/vendor_manager.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/screens/rw_vendor_registration_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import '../components/menu.dart';
import '../components/side_menu.dart';
import '../manager/login_manager.dart';
import '../manager/profile_manager.dart';
import '../manager/roles_manager.dart';
import '../model/servie_request.dart';
import '../model/staff.dart';
import '../screens/rw_staff_management_screen.dart';
import '../screens/rw_vendor_management_screen.dart';
import '../components/logo.dart';
import '../utils/add_space.dart';
import '../resources/resources.dart' as res;

import 'package:http/http.dart' as http;

import '../model/vendor.dart';
import '../resources/resources.dart' as res;

class RunWheelManagementPage extends StatefulWidget {

  const RunWheelManagementPage({Key? key}) : super(key: key);

  @override
  State<RunWheelManagementPage> createState() => _RunWheelManagementPageState();
}

class _RunWheelManagementPageState extends State<RunWheelManagementPage> {
  List<VendorDTO> staffList = [];


  Future<List<VendorDTO>> getNewRequests() async {
    http.Response response = await http.get(Uri.parse("${res.APP_URL}/api/vendor/getallvendorregistrationrequests"));
    var jsonResponse = jsonDecode(response.body);
    List<VendorDTO> list = [];
    for (var item in jsonResponse) {
      list.add(VendorDTO.fromJson(item));
    }
    return list;
    //return jsonList.map((request) => { ServiceRequestDTO.fromJson(request)}).cast<ServiceRequestDTO>().toList();
  }


  Future<StaffDTO> getStaffById(int? id) async {
    http.Response response = await http.get(Uri.parse("${res.APP_URL}/api/staff//get_staff/$id"));
    var jsonList = jsonDecode(response.body) as List;
    var jsonResponse = jsonDecode(response.body);
    return StaffDTO.fromJson(jsonResponse);
    //return jsonList.map((request) => { ServiceRequestDTO.fromJson(request)}).cast<ServiceRequestDTO>().toList();
  }

  @override
  void initState() {
    super.initState();
    getNewRequests().then((requests) {
      ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
      requests = requests.where((element) =>
        element.executive == profileManager.staffDTO.id.toString() &&
        element.status != "Completed").toList();
      // requests.sort((b, a) => a.id?.compareTo(b?.id as num) as int);
      setState(() => staffList = requests);
    }).catchError((error) => log("error: $error"));
    //log("${jsonEncode(requestCounts)}");
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
                    const Text("Management",
                        style: TextStyle(color: Colors.white, fontSize: 23)),
                    addHorizontalSpace(70),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (BuildContext context) {
                                return VendorDashboardProfile(isStaff: true,);
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
            padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
            child: SideMenu(
              menuList: [
                RWMap(
                    title: "Home",
                    icon: const Icon(Icons.home, color: Colors.deepPurple,),
                    navigateTo: const RunWheelManagementPage()
                ),
                RWMap(
                    title: "Vendor",
                    icon: const Icon(Icons.electric_bike_outlined, color: Colors.deepPurple,),
                    navigateTo: VendorManagementPage()
                ),
                RWMap(
                    title: "Staff",
                    icon: const Icon(Icons.person, color: Colors.deepPurple,),
                    navigateTo: const StaffManagementPage()
                ),
              ],
            )
        ),
      body: SafeArea(
          child: SizedBox(
              width: double.infinity,
              child: Column(children: [
                const SizedBox(
                  height: 80,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Refresh", style: TextStyle(color: Colors.black),),
                    IconButton(
                      onPressed: () {
                        getNewRequests().then((requests) {
                          ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
                          requests = requests.where((element) =>
                            element.executive == profileManager.staffDTO.id.toString() &&
                            element.status != "Completed" ).toList();
                          // requests.sort((b, a) => a.id?.compareTo(b?.id as num) as int);
                          setState(() => staffList = requests);
                        }).catchError((error) => log("error: $error"));
                      },
                      icon: Icon(Icons.refresh, color: Colors.red),
                  )
                  ]
                ),

                const Text(
                  "Assigned Initial Requests",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: SearchableList<VendorDTO>(
                        initialList: staffList,
                        builder: (VendorDTO newRequest) => Item(
                          vendor: newRequest,
                        ),
                        filter: (value) => staffList
                            .where((element) =>
                            element.id.toString().contains(value))
                            .toList(),
                        onItemSelected: (VendorDTO item) {
                            VendorManager vendorManager = Provider.of<VendorManager>(context, listen: false);
                            vendorManager.vendorDTO = item;
                            vendorManager.vendorDTO.status = "Completed";
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return const RWVendorRegistration();
                                })
                            );
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
              ])
          )
      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget menu() {
    return Drawer(
        width: 220,
        child: ListView(
            children: [
              DrawerHeader(
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.blue, width: 2))
                  ),
                  child: const Text("Admin, Venkat Chary Padala"),
                )
              ),
              ListTile(
                title: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.deepPurple, width: 2))
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.garage_outlined, color: Colors.deepPurple,),
                        SizedBox(width: 20,),
                        Text("Vendor")
                      ],
                    )
                ),
                onTap: () {
                  LogInManager logInManager = Provider.of<LogInManager>(context, listen: false);
                  logInManager.setCurrentURLs("vendorRegistration");
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return MultiProvider(
                                providers: [
                                  ChangeNotifierProvider<RoleManager>(create: (context) => RoleManager()),
                                ],
                                child: VendorManagementPage()
                        );
                      })
                  );
                },
              ),
              ListTile(
                title: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.deepPurple, width: 3))
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.person, color: Colors.deepPurple,),
                        SizedBox(width: 20,),
                        Text("Staff")
                      ],
                    )
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                        return const StaffManagementPage();
                      })
                  );
                },
              )
            ])
    );
  }
}

class Item extends StatelessWidget {
  VendorDTO? vendor;
  Item({Key? key, this.vendor}) : super(key: key);

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
                const Text("name: "),
                const SizedBox(
                  width: 10,
                ),
                Text(vendor?.ownerName ?? "")
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text("PhoneNumber: "),
                const SizedBox(
                  width: 10,
                ),
                Text(vendor?.phoneNumber ?? "00000-00000")
              ],
            )
          ],
        ));
  }
}