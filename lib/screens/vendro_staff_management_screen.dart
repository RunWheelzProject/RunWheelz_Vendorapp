import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/manager/profile_manager.dart';
import 'package:untitled/manager/staff_manager.dart';
import 'package:untitled/model/staff.dart';
import 'package:untitled/screens/login_page_screen.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import '../manager/login_manager.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../model/vendor_mechanic.dart';
import '../resources/resources.dart' as res;
import 'package:http/http.dart' as http;

class VendorStaffManagementPage extends StatefulWidget {
  const VendorStaffManagementPage({Key? key}) : super(key: key);

 
  @override
  VendorStaffManagementPageState createState() => VendorStaffManagementPageState();
}

class VendorStaffManagementPageState extends State<VendorStaffManagementPage> {
  List<VendorMechanic> _vendorMechanic = [];

  Future<List<VendorMechanic>> getAllMechanics() async {
    http.Response response = await http.get(Uri.parse("${res.APP_URL}/api/vendorstaff/getallmechanics"));
    var jsonResponse = jsonDecode(response.body);
    log("${jsonEncode(jsonResponse)}");
    List<VendorMechanic> list = [];
    for (var item in jsonResponse) {
      list.add(VendorMechanic.fromJson(item));
    }
    return list;

  }

  @override
  void initState() {
    super.initState();
    getAllMechanics().then((mechanics) {
     setState(() => _vendorMechanic = mechanics);
    }).catchError((error) => log("error: $error"));
  }
  
  
  @override
  Widget build(BuildContext context) {
    LogInManager logInManager = Provider.of<LogInManager>(context, listen: false);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () => {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const VendorDashBoard();
                })
            )
          },
          child: const Icon(Icons.arrow_back),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Staff Management"),
        ),
        body: SafeArea(
            child: SizedBox(
                width: double.infinity,
                child: Column(children: [
                  const SizedBox(height: 40,),
                  Align(
                      alignment: Alignment.centerLeft,
                      child:ElevatedButton(
                          onPressed: () {
                            logInManager.setCurrentURLs("staffRegistration");
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                              return const LoginScreen();
                            })
                            );
                          },
                          child: const Text("Add Mechanic + ")
                      )
                  ),
                  const SizedBox(height: 20,),
                  Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                              ]
                          )

                        ],
                      )
                  ),
                  const SizedBox(height: 20,),
                  const Text('Mechanic List', style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: SearchableList<VendorMechanic>(
                          initialList: _vendorMechanic,
                          builder: (VendorMechanic mechanic) => Item(
                            vendorMechanic: mechanic,
                          ),
                          filter: (value) => _vendorMechanic.where((element) =>
                          element.phoneNumber?.contains(value) as bool)
                              .toList(),
                          onItemSelected: (VendorMechanic vendorMechanic) {
                            //profileManager.staffDTO = staff;
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return Profile(isStaff: true);
                                })
                            );
                          },
                          inputDecoration: InputDecoration(
                            labelText: "Search Staff",
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
                ]
                )
            )
        )
    );
  }
}

class Item extends StatelessWidget {
  final VendorMechanic vendorMechanic;
  final AssetImage image = const AssetImage("images/logo.jpg");
  const Item({Key? key, required this.vendorMechanic}) : super(key: key);

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(children: [
                  CircleAvatar(radius: 25.0, backgroundImage: image)
                ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        vendorMechanic.name ?? "No Name",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87),
                        textAlign: TextAlign.left,
                      )
                    ]),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(vendorMechanic.phoneNumber ?? "00000 00000",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.black45)
                        )
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ));
  }
}