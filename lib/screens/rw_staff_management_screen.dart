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
import '../manager/login_manager.dart';
import 'package:searchable_listview/searchable_listview.dart';
import '../resources/resources.dart' as res;
import 'package:http/http.dart' as http;


class StaffManagementPage extends StatefulWidget {
  const StaffManagementPage({Key? key}) : super(key: key);


  @override
  StaffManagementPageState createState() => StaffManagementPageState();
}

class StaffManagementPageState extends State<StaffManagementPage> {
  List<StaffDTO> _staffDTO = [];
  List<StaffDTO> _registeredStaff = [];
  List<StaffDTO> _notRegisteredStaff = [];
  bool _isRegistered = true;

  Future<List<StaffDTO>> getAllStaff() async {
    final Uri _getAllStaff = Uri.parse("${res.APP_URL}/api/staff/getAllStaff");
    http.Response response = await http.get(_getAllStaff);

    var jsonResponse = jsonDecode(response.body);
    List<StaffDTO> list = [];
    for (var item in jsonResponse) {
      list.add(StaffDTO.fromJson(item));
    }
    return list;

  }

  @override
  void initState() {
    super.initState();
    getAllStaff().then((mechanics) {
      _staffDTO = mechanics;
      for (var staff in _staffDTO) {
        if (staff.registrationStatus == true) {
          _registeredStaff.add(staff);
        }
      }
      for (var staff in _staffDTO) {
        if (staff.registrationStatus == false) {
          _notRegisteredStaff.add(staff);
        }
      }
      setState(() => {});
    }).catchError((error) => log("error: $error"));
  }

  @override
  Widget build(BuildContext context) {
    ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
    LogInManager logInManager = Provider.of<LogInManager>(context, listen: false);
    StaffManager staffManager = Provider.of<StaffManager>(context);


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
                            logInManager.setCurrentURLs("staffRegistration");
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                              return const LoginScreen();
                            })
                            );
                          },
                          child: const Text("Add Staff + ")
                      )
                  ),
                  const SizedBox(height: 20,),
                  Row(
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
                            setState(() => _isRegistered = true);
                          }
                        }
                      }),
                              const Text("Registered", textAlign: TextAlign.start,),

                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: !_isRegistered,
                                  onChanged: (val) {
                                    if (val != null) {
                                      if (val) {
                                        setState(() => _isRegistered = false);
                                      }
                                    }
                                  }),
                              const Text("Not Registered", textAlign: TextAlign.start,),

                            ],
                          ),
                        ]
                      )

                    ],
                  ),
                  const SizedBox(height: 20,),
                  const Text('Staff List', style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),),
                  Expanded(
                      child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: SearchableList<StaffDTO>(
                        initialList: _isRegistered ? _registeredStaff : _notRegisteredStaff,
                        builder: (StaffDTO staff) => Item(
                          staffDTO: staff,
                        ),
                        filter: (value) => _staffDTO
                            .where((element) =>
                                element.phoneNumber?.contains(value) as bool)
                            .toList(),
                        onItemSelected: (StaffDTO staff) {
                          profileManager.staffDTO = staff;
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (BuildContext context) {
                                return VendorDashboardProfile(isStaff: true);
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

  final StaffDTO staffDTO;

  const Item({Key? key, required this.staffDTO}) : super(key: key);
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
          borderRadius: BorderRadius.circular(2),
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
                        widget.staffDTO.name ?? "No Name",
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
                        Text(widget.staffDTO.city ?? "not found",
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
                        Text(widget.staffDTO.phoneNumber ?? "00000 00000",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: Colors.black45)),
                        const SizedBox(height: 10,),

                      ],
                    )
                  ],
                ),

              ],
            ),
          ],
        ));
  }
}