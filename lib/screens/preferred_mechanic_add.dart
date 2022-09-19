import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/manager/profile_manager.dart';
import 'package:untitled/manager/staff_manager.dart';
import 'package:untitled/manager/vendor_mechanic_manager.dart';
import 'package:untitled/model/staff.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/customer_board.dart';
import 'package:untitled/screens/login_page_screen.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/screens/profile_vendor.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/services/preferred_mechanic_service.dart';
import '../manager/login_manager.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../manager/vendor_manager.dart';
import '../model/vendor_mechanic.dart';
import '../services/vendor_registration.dart';
import 'package:http/http.dart' as http;

import '../model/vendor.dart';
import '../resources/resources.dart' as res;



class PreferredMechanicAdd extends StatefulWidget {
  const PreferredMechanicAdd({super.key});


  @override
  PreferredMechanicState createState() => PreferredMechanicState();
}
class PreferredMechanicState extends State<PreferredMechanicAdd> {
  List<VendorDTO> _preferredMechanicList = [];
  Color _selectedItemBackGroundColor = Colors.white;
  bool _itemSelected = false;



  Future<List<VendorDTO>> getAllVendors() async {
    final Uri _getAllMechanic = Uri.parse("${res.APP_URL}/api/vendor/getallvendors");
    http.Response response = await http.get(_getAllMechanic);

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

    getAllVendors().then((mechanics) {
      setState(() {
        _preferredMechanicList = mechanics;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    VendorMechanicManager vendorMechanicManager = Provider.of<VendorMechanicManager>(context);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () => {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return CustomerDashBoard(isCustomer: true);
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
                  const Text('Add Mechanic', style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SearchableList<VendorDTO>(
                          initialList: _preferredMechanicList,
                          builder: (VendorDTO mechanic) {
                            return Item(
                              mechanic: mechanic,
                              backGroundColor: _selectedItemBackGroundColor
                            );
                          },
                          filter: (value) => _preferredMechanicList.where((element) => element.phoneNumber?.contains(value) as bool).toList(),
                          onItemSelected: (VendorDTO mechanic) {
                              //vendorMechanicManager.preferredMechanicList.add(mechanic);
                             int customerID = Provider.of<ProfileManager>(context, listen: false).customerDTO.id ?? 0;
                             PreferredMechanicService().addMechanic(customerID, mechanic.id as int)
                             .then((vendor) {
                               showDialog<void>(
                                 context: context,
                                 barrierDismissible: false, // user must tap button!
                                 builder: (BuildContext context) {
                                   return AlertDialog(
                                     title: const Text('Message'),
                                     content: SingleChildScrollView(
                                       child: ListBody(
                                         children: <Widget>[
                                           Text('"${mechanic.ownerName}" added to Preferred Mechanic List'),
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
                             });


                          },
                          inputDecoration: InputDecoration(
                            labelText: "Search w/ phoneNumber",
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

  final VendorDTO mechanic;
  Color backGroundColor;
  Item({Key? key, required this.mechanic, required this.backGroundColor}) : super(key: key);
  @override
  ItemState createState() => ItemState();
}

class ItemState extends State<Item> {


  final AssetImage image = const AssetImage("images/logo.jpg");

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: widget.backGroundColor,
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
                        widget.mechanic.ownerName ?? "No Name",
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
                        Text(widget.mechanic.city ?? "not exists",
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
                        Text(widget.mechanic.phoneNumber ?? "00000 00000",
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
            const SizedBox(height: 40,),
          ],
        ));
  }
}