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
import 'package:untitled/screens/vendor_request_accept.screen.dart';
import '../manager/login_manager.dart';
import 'package:searchable_listview/searchable_listview.dart';

// dummy

class NewRequests {
  String requestID;
  String serviceType;
  NewRequests({required this.requestID, required this.serviceType});
}

class VendorInProgressManagementPage extends StatelessWidget {
  final String pageTitle;
  const VendorInProgressManagementPage({Key? key, required this.pageTitle}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
    LogInManager logInManager = Provider.of<LogInManager>(context, listen: false);
    StaffManager staffManager = Provider.of<StaffManager>(context);
    logInManager.setCurrentURLs("staffRegistration");

    List<NewRequests> requests = [NewRequests(requestID: "1234", serviceType: "Puncture")];
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
          title: const Text("Vendor Dashboard"),
        ),
        body: SafeArea(
            child: SizedBox(
                width: double.infinity,
                child: Column(children: [
                  const SizedBox(height: 40,),
                  /*Align(
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
                  ),*/
                  const SizedBox(height: 20,),
                  /*Container(
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
                  ),*/
                  const SizedBox(height: 20,),
                  Text(pageTitle, style: const TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: SearchableList<NewRequests>(
                          initialList: requests,
                          builder: (NewRequests staff) => Item(
                          ),
                          filter: (value) => requests
                              .where((element) => element.requestID.contains(value))
                              .toList(),
                          onItemSelected: (NewRequests item) {
                            //profileManager.staffDTO = staff;
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return VendorRequestAcceptScreen();
                                })
                            );
                          },
                          inputDecoration: InputDecoration(
                            labelText: "Search $pageTitle",
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
  const Item({Key? key}) : super(key: key);

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
              children: const [
                Text("Service: "),
                SizedBox(width: 10,),
                Text("Puncture")
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: const [
                Text("Request ID: "),
                SizedBox(width: 10,),
                Text("1231")
              ],
            )
          ],
        ));
  }
}