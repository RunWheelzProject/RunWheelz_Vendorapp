import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/manager/roles_manager.dart';
import 'package:untitled/manager/staff_manager.dart';
import 'package:untitled/model/staff.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/login_page_screen.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/rw_staff_registration_screen.dart';
import 'package:untitled/screens/rw_vendor_registration_screen.dart';
import 'package:untitled/services/phone_verification.dart';
import 'package:http/http.dart' as http;
import '../components/logo.dart';
import '../manager/login_manager.dart';
import '../resources/resources.dart' as res;

import 'dart:async';
import 'package:searchable_listview/searchable_listview.dart';

class StaffManagementPage extends StatelessWidget {

  const StaffManagementPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    LogInManager logInManager = Provider.of<LogInManager>(context, listen: false);
    StaffManager staffManager = Provider.of<StaffManager>(context);
    logInManager.setCurrentURLs("staffRegistration");

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () => {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const RunWheelManagementPage();
                })
            )
          },
          child: const Icon(Icons.arrow_back),
        ),
        appBar: AppBar(
          title: const Text("Management"),
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
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                              return const LoginScreen();
                            })
                            );
                          },
                          child: const Text("Add Staff + ")
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
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text("Registered", textAlign: TextAlign.center,),
                                Checkbox(
                                    value: staffManager.isRegistered,
                                    onChanged: (val) {
                                      if (val != null) {
                                        if (val) {
                                          staffManager.isRegistered = true;
                                          staffManager.getRegisteredList();
                                        }
                                      }
                                    }),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Not Registered"),
                                Checkbox(
                                    value: !staffManager.isRegistered,
                                    onChanged: (val) {
                                      if (val != null) {
                                        if (val) {
                                          staffManager.isRegistered = false;
                                          staffManager.getNotRegisteredList();

                                        }
                                      }
                                    }),
                              ],
                            ),
                          ]
                        )

                      ],
                    )
                  ),
                  const SizedBox(height: 20,),
                  const Text('Staff List', style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: SearchableList<StaffDTO>(
                      initialList: staffManager.filteredList,
                      builder: (StaffDTO staff) => Item(
                        staffDTO: staff,
                      ),
                      filter: (value) => staffManager.filteredList
                          .where((element) =>
                              element.phoneNumber?.contains(value) as bool)
                          .toList(),
                      onItemSelected: (StaffDTO staff) =>
                          log("staff: ${jsonEncode(staff)}"),
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
  final StaffDTO staffDTO;
  final AssetImage image = const AssetImage("images/logo.jpg");
  const Item({Key? key, required this.staffDTO}) : super(key: key);

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
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Profile();
                    }));
                  },
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.purple,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MultiProvider(
                        providers: [
                          ChangeNotifierProvider<RoleManager>(
                              create: (context) => RoleManager()),
                          ChangeNotifierProvider<StaffManager>(
                              create: (context) => StaffManager()),
                        ],
                        child: const RWStaffRegistration(),
                      );
                    }));
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.purple,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog<String>(
                        builder: (BuildContext context) => AlertDialog(
                                title: const Text("Delete"),
                                content: Text(
                                    "Are you sure deleting Vendor: -  '${staffDTO.name}' -  ?",
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black87)),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'YES'),
                                    child: const Text(
                                      'YES',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'NO'),
                                    child: const Text('NO'),
                                  )
                                ]),
                        context: context);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.purple,
                  ),
                ),
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
                        staffDTO.name ?? "No Name",
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
                        Text(staffDTO.city ?? "not found",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.black45)),
                        const SizedBox(
                          width: 15,
                        ),
                        const Icon(Icons.phone_android,
                            color: Colors.blue, size: 15),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(staffDTO.phoneNumber ?? "00000 00000",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.black45))
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