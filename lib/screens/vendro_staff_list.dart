import 'package:flutter/material.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/screens/vendor_staff_add_screen.dart';
import '../colors/app_colors.dart';
import '../components/button.dart';

import 'dart:convert';
import 'dart:developer';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/utils/add_space.dart';

import '../colors/app_colors.dart';
import '../components/menu.dart';
import '../components/pending_order_card.dart';
import '../components/header_text.dart';
import '../resources/resources.dart' as res;

class VendorStaff extends StatefulWidget {
  const VendorStaff({Key? key}) : super(key: key);

  @override
  VendorStaffState createState() => VendorStaffState();
}

class VendorStaffState extends State<VendorStaff> {

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
                        style: TextStyle(color: Colors.white, fontSize: 23)),
                    addHorizontalSpace(100),
                    const Icon(
                      Icons.account_circle_rounded,
                      color: Colors.white,
                    ),
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          child: const Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const VendorDashBoard();
                })
            )
          },
        ),
        drawer: Padding(
            padding: const EdgeInsets.fromLTRB(0, 122, 0, 0),
            child: Menu.menuData("menu", res.menuItems)),
        body: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      children: [
                        const Text("Vendor Staff", style: const TextStyle(fontSize: 34, color: Colors.white),),
                        addVerticalSpace(20),
                        const SizedBox(
                            width: 300,
                            child: TextField(
                                decoration: InputDecoration(
                                    fillColor: Color(0xfffbfcfb),
                                    hintStyle: TextStyle(color: Colors.black54),
                                    hintText: 'Search a location',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1.0, color: Colors.black87),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1.0, color: Colors.black87),
                                    ),
                                    suffixIcon: Icon(
                                      Icons.search_outlined,
                                      color: Colors.black,
                                    )
                                )
                            )
                        ),
                        addVerticalSpace(20),
                        Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                                elevation: MaterialStateProperty.all<double>(12)
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (BuildContext context) {
                                      return const VendorStaffRegistration();
                                    })
                                );
                              },
                              child: const Text("Add Mechanic"),
                            )
                        ),
                      ]
                  )
              ),
              addVerticalSpace(10),
              Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: 30,
                    padding: const EdgeInsets.all(10),
                    separatorBuilder: (BuildContext context, int index) {
                      return addVerticalSpace(20);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return vendorStaffCard();
                    },
                  ))
            ]
        )
    );
  }

  Widget vendorStaffCard() {
    return Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (BuildContext context) {
                            return Profile();
                          })
                      );
                    },
                    icon: const Icon(Icons.remove_red_eye, color: Colors.purple,),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return const VendorStaffRegistration();
                            })
                        );
                      },
                      icon: const Icon(Icons.edit, color: Colors.purple,),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text("OTPException"),
                          content: const Text("Delete Mecanic",
                          style: TextStyle(
                          fontSize: 18, color: Colors.black87)),
                          actions: <Widget>[
                            TextButton(
                            onPressed: () =>
                              Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                            ),
                          ])
                      );
                    },
                    icon: const Icon(Icons.delete, color: Colors.purple,),
                  ),
                  addHorizontalSpace(20),
                ],
              ),
              Row(
                children: const <Widget>[
                  SizedBox(width: 18),
                  Text("Name: ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                  SizedBox(width: 8),
                  Text("Ravi", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300)),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: const <Widget>[
                  SizedBox(width: 18),
                  Text("PhoneNumber: ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                  SizedBox(width: 8),
                  Text("987655678", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300)),
                ],
              ),

              const SizedBox(height: 15),
              Row(
                children: const <Widget>[
                  SizedBox(width: 18),
                  Text("ID: ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                  SizedBox(width: 8),
                  Text("23", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300)),
                ],
              ),

              const SizedBox(height: 15),
              Row(
                children: const <Widget>[
                  SizedBox(width: 18),
                  Text("AdharCard: ", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                  SizedBox(width: 8),
                  Text("9876-5567-9998", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300)),
                ],
              ),
              //const SizedBox(height: 15),
            ],
          ),
        ));
  }
}
