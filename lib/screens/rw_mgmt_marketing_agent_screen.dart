import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:untitled/components/marketing_agent_appbar.dart';
import 'package:untitled/manager/login_manager.dart';
import 'package:untitled/manager/staff_manager.dart';
import 'package:untitled/manager/vendor_manager.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/screens/profile_vendor.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import '../manager/profile_manager.dart';
import '../manager/vendor_works_manager.dart';
import '../model/staff.dart';

import 'package:http/http.dart' as http;

import '../model/vendor.dart';
import '../resources/resources.dart' as res;
import '../utils/add_space.dart';
import 'login_page_screen.dart';

class MarketingAgentPage extends StatefulWidget {

  const MarketingAgentPage({Key? key}) : super(key: key);

  @override
  MarketingAgentPageState createState() => MarketingAgentPageState();
}

class MarketingAgentPageState extends State<MarketingAgentPage> {
  List<VendorDTO> _initRequests = [];
  Future<List<VendorDTO>> getVendorInitialRegisterList() async {
    http.Response response = await http.get(Uri.parse("${res.APP_URL}/api/vendor/getallvendorregistrationrequests"));
    var jsonResponse = jsonDecode(response.body) as List;
    return jsonResponse.map((json) => VendorDTO.fromJson(json)).toList();
  }

  Future<List<VendorDTO>> getAllStaff() async {
    final Uri _getAllStaff = Uri.parse("${res.APP_URL}/api/vendor/getallvendors");
    http.Response response = await http.get(_getAllStaff);

    var jsonResponse = jsonDecode(response.body);
    List<VendorDTO> list = [];
    for (var item in jsonResponse) {
      list.add(VendorDTO.fromJson(item));
    }
    return list;

  }




  @override
  void initState() {
    super.initState();

    getVendorInitialRegisterList().then((requests) {
      requests = requests.where((element) => element.status != "Completed").toList();
      setState(() => _initRequests = requests);
    }).catchError((error) => log("error: $error"));

  }

  @override
  Widget build(BuildContext context) {

    return MarketingAgentAppBar(child: _mainContainer());

  }
  Widget _mainContainer() {
    ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
    VendorManager vendorManager = Provider.of<VendorManager>(context);
    VendorWorksManager vendorWorksManager = Provider.of<VendorWorksManager>(context, listen: false);

    return SafeArea(
        child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: Column(children: [
              const SizedBox(height: 40,),
              Align(
                  alignment: Alignment.centerLeft,
                  child:ElevatedButton(
                      onPressed: () {
                        LogInManager logInManager = Provider.of<LogInManager>(context, listen: false);
                        logInManager.setCurrentURLs("vendorRegistration");
                        vendorWorksManager.isMarketingAgent = true;
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                          return const LoginScreen();
                        })
                        );
                      },
                      child: const Text("Add Vendor + ")
                  )
              ),
              const SizedBox(height: 20,),
              const Text('Vendor List', style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: SearchableList<VendorDTO>(
                      initialList: _initRequests,
                      builder: (VendorDTO vendor) {
                        return Item(vendorRegistrationRequest: vendor, assignable: true,);
                      },
                      filter: (value) => _initRequests
                          .where((element) =>
                      element.phoneNumber?.contains(value) as bool)
                          .toList(),
                      onItemSelected: (VendorDTO vendor) {
                        profileManager.vendorDTO = vendor;
                        /*Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return VendorProfile();
                                })
                            );*/
                      },
                      inputDecoration: InputDecoration(
                        labelText: "Search Vendor",
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
    );
  }
}
class Item extends StatefulWidget {

  final VendorDTO vendorRegistrationRequest;
  bool assignable;

  Item({Key? key, required this.vendorRegistrationRequest, this.assignable = false}) : super(key: key);
  @override
  ItemState createState() => ItemState();
}

class ItemState extends State<Item> {

  final AssetImage image = const AssetImage("images/logo.jpg");
  List<StaffDTO> _staffList = [];
  StaffDTO? _selectedStaff;

  final Uri vendorRegistrationRequestURL = Uri.parse("${res.APP_URL}/api/vendor/editvrr");

  Future<http.Response> vendorRegistrationRequest(VendorDTO vendorRegistrationRequest) async {
    String body = jsonEncode(vendorRegistrationRequest);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    http.Response response = await http.put(vendorRegistrationRequestURL, body: body, headers: headers);
    return response;
  }

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

  List<String> executives = ["Select Executive"];
  String _dropDownExecutiveValue = "Select Executive";

  @override
  void initState() {
    super.initState();
    getAllStaff().then((staff) {
      List<String> list = staff.where((staff) => staff.role?.id == 3).toList()
          .map((staff) => staff.name ?? "").toList();
      setState(() {
        executives = [...executives, ...list];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
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

            const SizedBox(height: 30,),
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
                          setState(() => _dropDownExecutiveValue = val!);
                          _selectedStaff = _staffList.firstWhere((element) => element.name == val);
                        }
                    ),
                    const SizedBox(width: 40,),
                    ElevatedButton(
                        onPressed: () async {
                          StaffDTO? staff = _selectedStaff;
                          widget.vendorRegistrationRequest.executive = staff?.id.toString();
                          widget.vendorRegistrationRequest.marketingAgent = Provider.of<ProfileManager>(context, listen: false).staffDTO.id.toString();

                          vendorRegistrationRequest(widget.vendorRegistrationRequest)
                              .then((response) {
                            var body = jsonDecode(response.body);
                            log("body: ${jsonEncode(body)}");
                          }).catchError((error) {
                            log("ServerError: $error");
                          });

                          await http.get(Uri.parse("${res.APP_URL}/api/staff/sendNotification?deviceToken=${staff?.deviceToken}&requestId=${widget.vendorRegistrationRequest.id}"));
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Message'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('SentNotification to ${staff?.name}'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Done'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text("Assign")
                    )
                  ]
              )
          ],
        ));
  }
}