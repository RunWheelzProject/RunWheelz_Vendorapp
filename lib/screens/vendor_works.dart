import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchable_listview/widgets/list_item.dart';
import 'package:untitled/components/marketing_agent_appbar.dart';
import 'package:untitled/components/staff_appbar.dart';
import 'package:untitled/components/vendor_appbar.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/rw_mgmt_marketing_agent_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/utils/add_space.dart';
import '../components/menu.dart';
import '../manager/vendor_manager.dart';
import '../manager/vendor_works_manager.dart';
import '../model/vendor_works_dto.dart';
import '../resources/resources.dart' as res;

import 'package:http/http.dart' as http;

class MapKeyValue {
  String? key;
  String? value;
}

class VendorWorks extends StatefulWidget {

  const VendorWorks({
    Key? key,
  }) : super(key: key);

  @override
  VendorWorksState createState() => VendorWorksState();
}

class VendorWorksState extends State<VendorWorks> {
  List<Map<String, String>> services = [
    {"painting": "Painting"},
    {"electricWork": "Electrical Wrork"},
    {"spares": "Spares"},
    {"washing": "Washing"},
    {"puncture": "Puncture"},
    {"radiumWork": "Radium Work"},
    {"forkthtowing": "Forkthtowing"},
    {"alignment": "Alignemnt"},
    {"chesiAlignment": "Chesi Alignment"},
    {"welding": "Welding"},
    {"extraFitting": "Extra Fitting"},
    {"bikeDecors": "Bike Decors"},
    {"customization": "Customization"},
    {"lateWorks": "LateWorks"},
    {"freeLancer": "Free lancer(no workshop)"},
    {"towing": "Towing"},
    {"seatCover": "Seat Cover"},
    {"evVehicleRepairs": "EV Vehicle Repairs"},
    {"tankWork": "Tank Work"},
    {"denting": "Denting"},
    {"shockAbsorberRepair": "Shock Observer"},
    {"secondHandDelay": "Second Hand Delay"}
  ];

  final List<bool> _selectedCheckBox = List.generate(23, (i) => false);
  final List<Color> _selectedColor = List.generate(23, (i) => Colors.black);
  final List<Map<String, String>> _selectedItems = [];

  Future<bool> updateVendorWorks(VendorWorksDTO vendorWorksDTO) async {
    var jsonBody = jsonEncode(vendorWorksDTO);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    http.Response response = await http.put(
        Uri.parse("${res.APP_URL}/api/vendor/updatevendorworks"),
        headers: headers,
        body: jsonBody);

    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return true;
    }

    throw Exception(jsonResponse["message"]);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    VendorWorksManager vendorWorksManager = Provider.of<VendorWorksManager>(context);
    if (vendorWorksManager.isVendor) return VendorAppBar(child: _mainContainer());
    if (vendorWorksManager.isAdmin) return StaffAppBar(child: _mainContainer());
    return MarketingAgentAppBar(child: _mainContainer());
  }
  Widget _mainContainer() {

    TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
        child: Container(
            margin: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
            ),
            child: Column(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Colors.purple,
                    border: Border(bottom: BorderSide())),
                child: const Text(
                  "Vendor Services",
                  style: TextStyle(fontSize: 21, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                  child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: 22,
                      itemBuilder: (BuildContext context, int index) {
                        Color textColor = Colors.black;
                        return ListItem(
                          item: services[index],
                          builder: (Map<String, String> item) {
                            MapKeyValue mapKeyValue = MapKeyValue();
                            item.forEach((key, value) {
                              mapKeyValue.key = key;
                              mapKeyValue.value = value;
                            });
                            return Row(
                              children: [
                                Checkbox(
                                    value: _selectedCheckBox[index],
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedCheckBox[index] =
                                        _selectedCheckBox[index] == true
                                            ? false
                                            : true;
                                        _selectedColor[index] =
                                        _selectedColor[index] ==
                                            Colors.black
                                            ? Colors.red
                                            : Colors.black;

                                        if (_selectedCheckBox[index]) {
                                          _selectedItems.add(item);
                                        } else {
                                          if (_selectedItems
                                              .contains(item)) {
                                            _selectedItems.remove(item);
                                          }
                                        }
                                      });
                                    }),
                                Text(mapKeyValue.value ?? "",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: _selectedColor[index])),
                              ],
                            );
                          },
                          onItemSelected: (Map<String, String> item) {},
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 20,
                        );
                      })),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    //color: Colors.purple,
                      border:
                      Border(top: BorderSide(color: Colors.black54))),
                  child: ElevatedButton(
                      onPressed: () {
                        Map<String, dynamic> json = jsonDecode(jsonEncode(VendorWorksDTO()));
                        for (Map<String, String> item in _selectedItems) {
                          for (var entry in item.entries) {
                            json[entry.key] = true;
                          }
                        }
                        VendorWorksDTO vendorWorksDTO = VendorWorksDTO.fromJson(json);
                        vendorWorksDTO.id = Provider.of<VendorManager>(context, listen: false).vendorDTO.id;
                        updateVendorWorks(vendorWorksDTO)
                            .then((bool response) {
                          if (true) {
                            showDialog<void>(
                              context: context,
                              barrierDismissible:
                              false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Message'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: const <Widget>[
                                        Text('services updated'),
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
                          }
                        });
                      },
                      child: const Text("Submit"))),
            ])
        )
    );
  }
}
