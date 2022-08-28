import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/manager/profile_manager.dart';
import 'package:untitled/manager/staff_manager.dart';
import 'package:untitled/model/staff.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/login_page_screen.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/screens/profile_vendor.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import '../manager/login_manager.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../manager/vendor_manager.dart';
import '../services/vendor_registration.dart';

class VendorManagementPage extends StatelessWidget {

  const VendorManagementPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
    VendorManager vendorManager = Provider.of<VendorManager>(context);

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
                          child: const Text("Add Vendor + ")
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
                                              VendorRegistrationService().getVendorsNotRegistered()
                                              .then((vendors) {

                                              });
                                              //vendorManager.getNotRegisteredList();

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
                          onItemSelected: (VendorRegistrationRequest vendor) {
                            profileManager.vendorRegistrationRequest = vendor;
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return VendorProfile();
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