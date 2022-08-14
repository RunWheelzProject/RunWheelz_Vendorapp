import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/manager/roles_manager.dart';
import 'package:untitled/manager/staff_manager.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/login_page_screen.dart';
import 'package:untitled/screens/rw_vendor_registration_screen.dart';
import 'package:untitled/services/phone_verification.dart';
import 'package:http/http.dart' as http;
import '../components/logo.dart';
import '../manager/login_manager.dart';
import '../manager/vendor_manager.dart';
import '../resources/resources.dart' as res;

class VendorManagementPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    LogInManager logInManager = Provider.of<LogInManager>(context, listen: false);
    logInManager.setCurrentURLs("vendorRegistration");
    return Scaffold(
        appBar: AppBar(
          title: const Text("Management"),
        ),
        drawer: const Drawer(),
        body: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Logo()
                  ),
                  const SizedBox(height: 50,),
                  Align(
                    alignment: Alignment.topLeft,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                            return const LoginScreen();
                          })
                          );
                        },
                        child: const Text("Add Vendor + ")
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Expanded(
                      child: ListView.separated(
                        itemCount: Provider.of<VendorManager>(context).vendorList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Consumer<VendorManager>(
                              builder: (context, staff, child) => userCard(context: context,
                                  name: staff.vendorList[index].ownerName ?? "",
                                  location: staff.vendorList[index]?.city ?? "",
                                  phoneNumber: staff.vendorList[index]?.phoneNumber ?? ""));

                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 20,);
                        },
                      )
                  )
                ]
            ) // This trailing comma makes auto-formatting nicer for build methods.
        )
    );
  }
  Widget userCard({
    AssetImage image = const AssetImage("images/logo.jpg"),
    name = "Amanda Graham",
    location = "Bergon",
    phoneNumber = "91 70876 57843",
    required BuildContext context
  }) {
    return Container(
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const <BoxShadow>[
              BoxShadow(color: Colors.black45,
                  blurRadius: 10,
                  offset: Offset(5, 5)),
              BoxShadow(color: Colors.black45,
                  blurRadius: 10,
                  offset: Offset(10, 10))
            ]
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    /*Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return Profile();
                        })
                    );*/
                  },
                  icon: const Icon(Icons.remove_red_eye, color: Colors.purple,),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return const RWVendorRegistration();
                        })
                    );
                  },
                  icon: const Icon(Icons.edit, color: Colors.purple,),
                ),
                IconButton(
                  onPressed: () {
                    showDialog<String>(
                        builder: (BuildContext context) => AlertDialog(
                            title: const Text("Delete"),
                            content: const Text("Are you sure deleting Vendor?",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black87)),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'YES'),
                                child: const Text('YES', style: TextStyle(color: Colors.red),),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'NO'),
                                child: const Text('NO'),
                              )
                            ]), context: context
                    );
                  },
                  icon: const Icon(Icons.delete, color: Colors.purple,),
                )
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                    children: [
                      CircleAvatar(
                          radius: 25.0,
                          backgroundImage: image
                      )
                    ]
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                        children: [
                          const SizedBox(width: 10,),
                          Text(name, style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87
                          ),
                            textAlign: TextAlign.left,

                          )
                        ]
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        const SizedBox(width: 15,),
                        const Icon(
                          Icons.location_on, color: Colors.blue,
                          size: 15,),
                        const SizedBox(width: 5,),
                        Text(location, style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Colors.black45
                        )),
                        const SizedBox(width: 15,),
                        const Icon(Icons.phone_android, color: Colors.blue, size: 15),
                        const SizedBox(width: 5,),
                        Text(phoneNumber, style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Colors.black45
                        ))
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        )
    );
  }
}
