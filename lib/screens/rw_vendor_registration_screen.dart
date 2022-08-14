import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/logo.dart';
import 'package:untitled/manager/vendor_manager.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/services/vendor_registration.dart';
import '../manager/roles_manager.dart';
import '../model/role.dart';
import './google_map_location_screen.dart';
import '../utils/add_space.dart';
import '../resources/resources.dart' as res;
import '../resources/IndianStates.dart';
import 'package:http/http.dart' as http;

class RWVendorRegistration extends StatefulWidget {
  const RWVendorRegistration({Key? key}) : super(key: key);

  @override
  RWVendorRegistrationState createState() => RWVendorRegistrationState();
}

class RWVendorRegistrationState extends State<RWVendorRegistration> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _inidianStates = indianStates.values.toList();
  bool _isTermsChecked = false;
  String _dropDownValue = 'Select Role';
  String _dropDownStateVAlue = 'Select State';
  dynamic _onChangeValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final VendorManager vendorManager = Provider.of<VendorManager>(context);
    final RoleManager roleManager = Provider.of<RoleManager>(context);
    List<String> roles = roleManager.roleNames.map((role) => role.roleName as String).toList();
    return Scaffold(
      appBar: AppBar(title: const Text("Run Wheelz")),
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 34, bottom: 34),
          child: Column(children: [
            Logo(),
            addVerticalSpace(30),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, top: 30, right: 25, bottom: 30),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Center(
                            child: Text(
                          "Vendor Registration",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        )),
                        addVerticalSpace(40),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                vertical: 25, horizontal: 20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "ID: ${vendorManager.vendorRegistrationRequest.id}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                        fontFamily: 'Roboto Bold'),
                                  ),
                                  addVerticalSpace(15),
                                  Text(
                                      "Phone Number: ${vendorManager.vendorRegistrationRequest.phoneNumber}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
                                          fontFamily: 'Roboto Bold'))
                                ])),
                        addVerticalSpace(25),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Owner Name",
                            prefixIcon: const Icon(Icons.person,
                                color: Colors.deepPurple),
                            border: OutlineInputBorder(
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
                                )),
                          ),
                          onChanged: (value) => {
                            vendorManager.vendorRegistrationRequest.ownerName =
                                value
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'this field required';
                            }
                            return null;
                          },
                        ),
                        addVerticalSpace(20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Garage Name",
                            prefixIcon: const Icon(Icons.home,
                                color: Colors.deepPurple),
                            border: OutlineInputBorder(
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
                                )),
                          ),
                          onChanged: (value) => {
                            vendorManager.vendorRegistrationRequest.garageName =
                                value
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'this field required';
                            }
                            return null;
                          },
                        ),
                        addVerticalSpace(25),
                        Row(
                          children: [
                            Checkbox(
                              onChanged: (val) => {},
                              value: true,
                            ),
                            const Text("M"),
                            addHorizontalSpace(20),
                            Checkbox(
                              onChanged: (val) => {},
                              value: false,
                            ),
                            const Text("F"),
                          ],
                        ),
                        addVerticalSpace(20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Aadhaar Card",
                            helperText: "9090-9090-9090",
                            helperStyle: const TextStyle(color: Colors.red, fontSize: 16),
                            prefixIcon: const Icon(Icons.credit_card_outlined,
                                color: Colors.deepPurple),
                            border: OutlineInputBorder(
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
                                )),
                          ),
                          onChanged: (value) => {
                            vendorManager.vendorRegistrationRequest.aadharNumber = value
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'this field required';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          maxLength: 14,
                          inputFormatters: [
                            MaskedTextInputFormatter(mask: '0000-0000-0000', separator: '-')
                          ],
                        ),
                        addVerticalSpace(40),
                        TextFormField(
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: "address",
                            prefixIcon: const Icon(Icons.location_on,
                                color: Colors.deepPurple),
                            border: OutlineInputBorder(
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
                                )),
                          ),
                          onChanged: (value) => {
                            vendorManager
                                .vendorRegistrationRequest.addressLine = value
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'this field required';
                            }
                            return null;
                          },
                        ),
                        /*Container(
                          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(vendorManager.vendorRegistrationRequest.addressLine ?? "",
                          style: const TextStyle(fontSize: 20, color: Colors.green, fontFamily: 'Roboto Bold'),),
                        )*/
                        addVerticalSpace(40),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "City",
                            prefixIcon: const Icon(Icons.location_on,
                                color: Colors.deepPurple),
                            border: OutlineInputBorder(
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
                                )),
                          ),
                          onChanged: (value) => {
                            vendorManager.vendorRegistrationRequest.city = value
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'this field required';
                            }
                            return null;
                          },
                        ),
                        addVerticalSpace(20),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(10)),
                              value: _dropDownStateVAlue,
                              icon: const Icon(
                                Icons.expand_circle_down,
                                color: Colors.deepPurple,
                              ),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _dropDownStateVAlue = newValue!;
                                  vendorManager.vendorRegistrationRequest.state = newValue;
                                });
                              },
                              items: _inidianStates
                                  .map<DropdownMenuItem<String>>((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                );
                              }).toList(),
                            )
                        )

                        /*TextFormField(
                          decoration: InputDecoration(
                            labelText: "State",
                            prefixIcon: const Icon(Icons.location_city,
                                color: Colors.deepPurple),
                            labelStyle: const TextStyle(color: Colors.green),
                            border: OutlineInputBorder(
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
                                )),
                          ),
                          onChanged: (value) => {
                            vendorManager.vendorRegistrationRequest.state =
                                value
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'this field required';
                            }
                            return null;
                          },
                        )*/,
                        addVerticalSpace(20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Zipcode",
                            prefixIcon: const Icon(Icons.perm_identity,
                                color: Colors.deepPurple),
                            border: OutlineInputBorder(
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
                                )),
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                          ],
                          onChanged: (value) => {
                            vendorManager.vendorRegistrationRequest.zipcode =
                                value
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'this field required';
                            }
                            return null;
                          },
                        ),
                        addVerticalSpace(20),
                        TextFormField(
                          initialValue: 'India',
                          decoration: InputDecoration(
                            labelText: "Country",
                            prefixIcon: const Icon(Icons.location_city,
                                color: Colors.deepPurple),
                            labelStyle: const TextStyle(color: Colors.green),
                            border: OutlineInputBorder(
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
                                )),
                          ),
                          onChanged: (value) => {
                            vendorManager.vendorRegistrationRequest.country =
                                value
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'this field required';
                            }
                            return null;
                          },
                        ),
                        addVerticalSpace(20),
                        /*textFormField(
                            "Role",
                            const Icon(Icons.account_circle_rounded, color: Colors.deepPurple),
                            vendorManager.vendorRegistrationRequest.role
                        ),*/
                        addVerticalSpace(30),
                        addVerticalSpace(20),
                        Container(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                                onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          vendorManager.vendorRegistrationRequest.registrationStatus = true;
                                          log("vendor: ${jsonEncode(vendorManager.vendorRegistrationRequest)}");
                                          VendorRegistrationService().updateVendorInfo(vendorManager.vendorRegistrationRequest)
                                          .then((response) {
                                            log("status: ${response.statusCode}");
                                            if (response.statusCode == 200) {
                                              log("status: ${response.statusCode}");
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                                                  return const RunWheelManagementPage();
                                                })
                                              );
                                            }
                                          });
                                        }
                                      },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(fontSize: 24),
                                )))
                      ],
                    )),
              ),
            )
          ])),
    );
  }

  Widget textFormField(String label, Icon icon, dynamic val) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon,
        labelStyle: const TextStyle(color: Colors.green),
        border: OutlineInputBorder(
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
            )),
      ),
      onChanged: (value) => {val = value},
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'this field required';
        }
        return null;
      },
    );
  }
}




class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  });


  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.isNotEmpty) {
      if(newValue.text.length > oldValue.text.length) {
        if(newValue.text.length > mask.length) return oldValue;
        if(newValue.text.length < mask.length && mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text: '${oldValue.text}$separator${newValue.text.substring(newValue.text.length-1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}