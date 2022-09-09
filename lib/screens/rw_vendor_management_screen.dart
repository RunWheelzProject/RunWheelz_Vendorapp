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
import 'package:http/http.dart' as http;

import '../model/vendor.dart';
import '../resources/resources.dart' as res;



class VendorManagementPage extends StatefulWidget {

  @override
  VendorManagementPageState createState() => VendorManagementPageState();
}
class VendorManagementPageState extends State<VendorManagementPage> {
  List<VendorRegistrationRequest> _vendorRegistrationRequest = [];
  List<VendorRegistrationRequest> _registered = [];
  List<VendorRegistrationRequest> _notRegistered = [];
  List<VendorRegistrationRequest> _initRequests = [];
  List<VendorRegistrationRequest> _filteredList = [];
  bool _isRegistered = true;
  bool _isNotRegisterd = false;
  bool _isInitRequests = false;


  Future<List<VendorRegistrationRequest>> getVendorInitialRegisterList() async {
    http.Response response = await http.get(Uri.parse("${res.APP_URL}/api/vendor/registrationrequest"));
      var jsonResponse = jsonDecode(response.body) as List;
      return jsonResponse.map((json) => VendorRegistrationRequest.fromJson(json)).toList();
  }

  Future<List<VendorRegistrationRequest>> getAllStaff() async {
    final Uri _getAllStaff = Uri.parse("${res.APP_URL}/api/vendor/getallvendors");
    http.Response response = await http.get(_getAllStaff);

    var jsonResponse = jsonDecode(response.body);
    List<VendorRegistrationRequest> list = [];
    for (var item in jsonResponse) {
      list.add(VendorRegistrationRequest.fromJson(item));
    }
    return list;

  }

  @override
  void initState() {
    super.initState();
    getAllStaff().then((mechanics) {
      _vendorRegistrationRequest = mechanics;
      for (var staff in _vendorRegistrationRequest) {
        if (staff.registrationStatus == true) {
          _registered.add(staff);
        }
      }
      for (var staff in _vendorRegistrationRequest) {
        if (staff.registrationStatus == false) {
          _notRegistered.add(staff);
        }
      }
      setState(() => {});
    }).catchError((error) => log("error: $error"));

    getVendorInitialRegisterList().then((mechanics) {
      _initRequests = mechanics;
    }).catchError((error) => log("error: $error"));

  }

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
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.all(10),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                        value: _isRegistered,
                                        onChanged: (val) {
                                          if (val != null) {
                                            if (val) {
                                              setState(() {
                                                _isNotRegisterd = false;
                                                _isRegistered = true;
                                                _isInitRequests = false;
                                              });
                                              setState(() => {
                                                _filteredList = _registered
                                              });
                                            }
                                          }
                                        }),
                                    const Text("Registered", textAlign: TextAlign.center,),

                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: _isNotRegisterd,
                                        onChanged: (val) {
                                          if (val != null) {
                                            if (val) {
                                              setState(() {
                                                _isNotRegisterd = true;
                                                _isRegistered = false;
                                                _isInitRequests = false;
                                              });
                                              setState(() => {
                                                _filteredList = _notRegistered
                                              });
                                            }
                                          }
                                        }),
                                    const Text("Not Registered"),

                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                        value: _isInitRequests,
                                        onChanged: (val) {
                                          if (val != null) {
                                            if (val) {
                                              setState(() {
                                                _isNotRegisterd = false;
                                                _isRegistered = false;
                                                _isInitRequests = true;
                                              });
                                              setState(() => {
                                                _filteredList = _initRequests
                                              });
                                            }
                                          }
                                        }),
                                    const Text("Initial Requests"),

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
                        padding: const EdgeInsets.all(5),
                        child: SearchableList<VendorRegistrationRequest>(
                          initialList: _filteredList,
                          builder: (VendorRegistrationRequest vendor) => Item(
                            vendorRegistrationRequest: vendor,
                          ),
                          filter: (value) => _filteredList
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
class Item extends StatefulWidget {

  final VendorRegistrationRequest vendorRegistrationRequest;
  bool assignable;

  Item({Key? key, required this.vendorRegistrationRequest, this.assignable = false}) : super(key: key);
  @override
  ItemState createState() => ItemState();
}

class ItemState extends State<Item> {
  String _dropDownExecutiveValue = "Select";
  final AssetImage image = const AssetImage("images/logo.jpg");

  List<String> executives = [
    "Select",
    "Ravi",
    "Hari",
    "Raghav"
  ];
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
                        widget.vendorRegistrationRequest.ownerName ?? "No Name",
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
                        Text(widget.vendorRegistrationRequest.city ?? "not found",
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
                        Text(widget.vendorRegistrationRequest.phoneNumber ?? "00000 00000",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.black45))
                      ],
                    )
                  ],
                )
              ],
            ),

            SizedBox(height: 30,),
            if (widget.assignable)
            Row(
                children: [
                  DropdownButton<String>(
                      value: _dropDownExecutiveValue,
                      items: executives.map<DropdownMenuItem<String>>((item) {
                        return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item ?? "")
                        );
                      }).toList(),
                      onChanged: (val) {
                        _dropDownExecutiveValue = val!;
                      }
                  ),
                  SizedBox(width: 40,),
                  ElevatedButton(onPressed: () {},
                      child: const Text("Assign")
                  )
                ]
            )
          ],
        ));
  }
}