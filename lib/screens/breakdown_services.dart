import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/dashboard_box.dart';
import 'package:untitled/model/servie_request.dart';
import 'package:untitled/screens/customer_registration_screen.dart';
import 'package:untitled/screens/data_viewer_screen.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/utils/add_space.dart';
import '../components/menu.dart';
import '../manager/profile_manager.dart';
import '../manager/vendor_manager.dart';
import '../resources/resources.dart' as res;

import 'package:http/http.dart' as http;

import 'google_map_location_screen.dart';


typedef CallBack = void Function();

class BreakDownServices extends StatefulWidget {
  const BreakDownServices({Key? key}) : super(key: key);

  @override
  BreakDownServicesState createState() => BreakDownServicesState();
}

class BreakDownServicesState extends State<BreakDownServices> {

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
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
                    addHorizontalSpace(70),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (BuildContext context) {
                                return VendorDashboardProfile(isVendor: true);
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
            padding: const EdgeInsets.fromLTRB(0, 122, 0, 0),
            child: Menu.menuData("menu", res.menuItems)),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white,
                    ),
                    child: Column(children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                            color: Colors.purple,
                            border: Border(bottom: BorderSide())),
                        child: const Text(
                          "BreakDown Services",
                          style: TextStyle(fontSize: 21, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            addVerticalSpace(50),
                            RWDropDown(
                                value: 'Select Services',
                                onChanged: (String) => {},
                                items: const ['Select Services', 'Puncture', 'ElectricalWorks', 'Denting']
                            ),
                            addVerticalSpace(20),
                            RWDropDown(
                                value: 'Select Vehicle Type',
                                onChanged: (String) => {},
                                items: const ['Select Vehicle Type', 'Honda', 'TVS', 'Suzuki']
                            ),
                            addVerticalSpace(20),
                            RWTextFormField(
                                label: "Vehicle Number",
                                icon: const Icon(Icons.numbers),
                                onSaved: (String) => {}
                            ),
                            addVerticalSpace(70),
                            ElevatedButton(
                                onPressed: () => {
                                Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      //log("vendor: ${jsonEncode(vendorManager.vendorRegistrationRequest)}");
                                      return const GoogleMapLocationPickerV1();
                                    })
                                )
                                },
                                child: const Text("Proceed")
                            )
                          ],
                        ),
                      )

                    ])
                )
            )
        )
    );
  }
}


typedef OnClick = void Function();
typedef DropDownOnChanged = void Function(String?)?;
typedef FunctionSaved = void Function(String?)?;
typedef FunctionChanged = void Function(bool?)?;
typedef FunctionPressed = void Function()?;

class RWDropDown extends StatelessWidget {
  final String value;
  final DropDownOnChanged onChanged;
  final List<String>? items;

  RWDropDown({
    required this.value,
    required this.onChanged,
    required this.items
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10)),
      value: value,
      icon: const Icon(
        Icons.expand_circle_down,
        color: Colors.deepPurple,
      ),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: onChanged,
      items: items?.map<DropdownMenuItem<String>>((String item) { return DropdownMenuItem<String>(value: item, child: Text(item));}).toList(),
    );
  }
}

class RWTextFormField extends StatelessWidget {
  final String label;
  final Icon icon;
  final FunctionSaved onSaved;
  final String? helperText;
  final int? maxLength;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? textInputFormatters;

  const RWTextFormField({
    required this.label,
    required this.icon,
    required this.onSaved,
    this.helperText,
    this.maxLength,
    this.textInputType,
    this.textInputFormatters
  });


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      keyboardType: textInputType,
      inputFormatters: textInputFormatters,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: icon,
        labelStyle: const TextStyle(color: Colors.black38),
        helperStyle: const TextStyle(color: Colors.red, fontSize: 14),
        /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.purple,
              width: 0,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.purple,
              width: 0,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.purple,
              width: 0,
            )),*/
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'this field required';
        }
        return null;
      },
    );
  }
}