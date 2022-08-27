import 'package:flutter/material.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:untitled/components/dashboard_box.dart';
import 'package:untitled/screens/data_viewer_screen.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/screens/profile_vendor.dart';
import 'package:untitled/screens/vendor_dashboard_profile.dart';
import 'package:untitled/screens/vendor_mechanic_accept_screen.dart';
import 'package:untitled/screens/vendor_pending_screen.dart';
import 'package:untitled/screens/vendor_request_accept.screen.dart';
import 'package:untitled/utils/add_space.dart';
import '../components/menu.dart';
import '../resources/resources.dart' as res;

typedef CallBack = void Function();

class VendorMechanicDashBoard extends StatefulWidget {
  const VendorMechanicDashBoard({Key? key}) : super(key: key);

  @override
  VendorMechanicDashBoardState createState() => VendorMechanicDashBoardState();
}

class VendorMechanicDashBoardState extends State<VendorMechanicDashBoard> {
  TextEditingController phoneNumberController = TextEditingController();
  final bool _validate = false;
  final String _error = "";



  List<NewRequests> requests = [
    NewRequests(requestID: "1234", serviceType: "Puncture"),
    NewRequests(requestID: "1235", serviceType: "General"),
    NewRequests(requestID: "1236", serviceType: "Washing")
  ];

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
                                return VendorDashboardProfile();
                              })
                          );
                        },
                        icon: const Icon(
                          Icons.account_circle_rounded,
                          color: Colors.white,
                        )),
                    addHorizontalSpace(20),
                  ],
                )),
          ),
        ),
        body: SafeArea(
            child: SizedBox(
                width: double.infinity,
                child: Column(children: [
                  const SizedBox(height: 80,),
                  const Text("Mechanic Assigned Tasks", style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: SearchableList<NewRequests>(
                          initialList: requests,
                          builder: (NewRequests newRequest) => Item(newRequests: newRequest,),
                          filter: (value) => requests
                              .where((element) => element.requestID.contains(value))
                              .toList(),
                          onItemSelected: (NewRequests item) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (BuildContext context) {
                                    return VendorMechanicRequestAcceptScreen();
                                  })
                              );
                          },
                          inputDecoration: InputDecoration(
                            labelText: "Search ",
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
  NewRequests newRequests;
  Item({Key? key, required this.newRequests}) : super(key: key);

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
              children: [
               const Text("Service: "),
                const SizedBox(width: 10,),
                Text(newRequests.serviceType)
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                const Text("Request ID: "),
                const SizedBox(width: 10,),
                Text(newRequests.requestID)
              ],
            )
          ],
        ));
  }
}