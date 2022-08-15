import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:untitled/screens/rw_management_screen.dart';

import '../manager/roles_manager.dart';
import '../manager/staff_manager.dart';
import '../manager/vendor_manager.dart';
import '../model/vendor.dart';
import '../screens/login_page_screen.dart';
import '../screens/profile.dart';
import '../screens/rw_staff_registration_screen.dart';
import '../manager/login_manager.dart';

class VendorManagementPage extends StatelessWidget {
  const VendorManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LogInManager logInManager = Provider.of<LogInManager>(context, listen: false);
    VendorManager vendorManager = Provider.of<VendorManager>(context);
    logInManager.setCurrentURLs("vendorRegistration");
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
        drawer: const Drawer(),
        body: SafeArea(
            child: SizedBox(
                width: double.infinity,
                child: Column(children: [
                  const SizedBox(height: 40,),
                  //Logo(),
                  const SizedBox(height: 20,),
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
                                        value: vendorManager.isRegistered,
                                        onChanged: (val) {
                                          if (val != null) {
                                            if (val) {
                                              vendorManager.isRegistered = true;
                                              vendorManager.getRegisteredList();
                                            }
                                          }
                                        }),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Not Registered"),
                                    Checkbox(
                                        value: !vendorManager.isRegistered,
                                        onChanged: (val) {
                                          if (val != null) {
                                            if (val) {
                                              vendorManager.isRegistered = false;
                                              vendorManager.getNotRegisteredList();
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
                  SizedBox(height: 20,),
                  const Text('Vendor List', style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: SearchableList<VendorRegistrationRequest>(
                          initialList: vendorManager.filteredList,
                          builder: (VendorRegistrationRequest vendor) => Item(
                            vendorRegistrationRequest: vendor,
                          ),
                          filter: (value) => vendorManager.filteredList
                              .where((element) =>
                          element.phoneNumber?.contains(value) as bool)
                              .toList(),
                          onItemSelected: (VendorRegistrationRequest vendor) =>
                              log("staff: ${jsonEncode(vendor)}"),
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
                ]))));
    /*]
            ) // This trailing comma makes auto-formatting nicer for build methods.
        )
    );*/
  }
}

class Item extends StatelessWidget {
  final VendorRegistrationRequest vendorRegistrationRequest;
  final AssetImage image = const AssetImage("images/logo.jpg");
  const Item({Key? key, required this.vendorRegistrationRequest}) : super(key: key);

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
                            content: const Text(
                                "Are you sure deleting Vendor?",
                                style: TextStyle(
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
                        vendorRegistrationRequest.ownerName ?? "No Name",
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
                        Text(vendorRegistrationRequest.city ?? "not found",
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
                        Text(vendorRegistrationRequest.phoneNumber ?? "00000 00000",
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