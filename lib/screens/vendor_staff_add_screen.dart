import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/logo.dart';
import 'package:untitled/components/menu.dart';
import '../screens/vendro_staff_list.dart';
import 'package:untitled/manager/vendor_manager.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/screens/vendor_profile_screen.dart';
import './google_map_location_screen.dart';
import '../utils/add_space.dart';
import '../model/vendor.dart';
import '../resources/resources.dart' as res;


class VendorStaffRegistration extends StatefulWidget {
  const VendorStaffRegistration({Key? key}) : super(key: key);

  @override
  VendorStaffRegistrationState createState() => VendorStaffRegistrationState();
}

class VendorStaffRegistrationState extends State<VendorStaffRegistration> {
  final _formKey = GlobalKey<FormState>();
  String dropDownValue = 'Current Location';
  bool _isTermsChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    final VendorManager vendorManager = Provider.of<VendorManager>(context);

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
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return const VendorProfile();
                            })
                        );
                      },
                      icon: const Icon(
                        Icons.account_circle_rounded,
                        color: Colors.white,
                      )
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
      drawer: Padding(
          padding: const EdgeInsets.fromLTRB(0, 122, 0, 0),
          child: Menu.menuData("menu", res.menuItems)),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () => {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const VendorStaff();
                })
            )
          },
          child: const Icon(Icons.arrow_back),
        ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 34, bottom: 34),
          child: Column( children: [
            addVerticalSpace(30),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, top: 20, right: 25, bottom: 30),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        addVerticalSpace(20),
                        const Center(
                            child: Text(
                              "Vendor Staff Registration",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )
                        ),
                        addVerticalSpace(35),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person, color: Colors.purple),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                  width: 1,
                                )
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                  width: 2,
                                )
                            ),
                          ),
                          onChanged: (value) => {
                            vendorManager.vendorRegistrationRequest.ownerName = value
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'this field required';
                            }
                            return null;
                          },
                        ),
                        addVerticalSpace(30),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone_android, color: Colors.purple),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                  width: 1,
                                )
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                  width: 2,
                                )
                            ),
                          ),

                          onChanged: (value) => {
                            vendorManager.vendorRegistrationRequest.phoneNumber = value
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'this field required';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          maxLength: 10,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Adhar Card',
                              prefixIcon: Icon(Icons.credit_card_outlined, color: Colors.purple),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                  width: 1,
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                  width: 2,
                                )
                            ),
                          ),
                          onChanged: (value) => {
                            vendorManager.vendorRegistrationRequest.garageName = value
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'this field required';
                            }
                            return null;
                          },
                        ),
                        addVerticalSpace(50),
                        Container(
                            alignment: Alignment.topLeft,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                                      //log("vendor: ${jsonEncode(vendorManager.vendorRegistrationRequest)}");
                                      return const GoogleMapLocationPickerV1();
                                    }));
                                  }
                                },
                                child: const Text('Upload Image', style: TextStyle(fontSize: 17),)
                            )
                        ),
                        addVerticalSpace(20),
                        Container(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (BuildContext context) {
                                          return const VendorStaff();
                                        })
                                    );
                                  }
                                },
                                child: const Text('Save', style: TextStyle(fontSize: 17),)))
                      ],
                    )),
              ),
            )])),
    );
  }
}
