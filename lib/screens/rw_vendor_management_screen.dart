import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/login_page_screen.dart';
import 'package:untitled/screens/rw_vendor_registration_screen.dart';
import 'package:untitled/services/phone_verification.dart';
import 'package:http/http.dart' as http;
import '../components/logo.dart';
import '../manager/login_manager.dart';
import '../resources/resources.dart' as res;

class VendorManagementPage extends StatefulWidget {

  const VendorManagementPage({Key? key}) : super(key: key);

  @override
  State<VendorManagementPage> createState() => _VendorManagementPageState();
}

class _VendorManagementPageState extends State<VendorManagementPage> {

  late List<VendorRegistrationRequest?> _vendorRegistrations = [];

  @override
  void initState() {

    // get currently registered vendors
    Future<http.Response> future = http.get(Uri.parse("${res.APP_URL}/api/vendor/getallvendors"));
    future.then((response) {
      log("jsonResponse: ${jsonEncode(response.body)}");
      var jsonResponse = jsonDecode(response.body) as List;
      var tmp = jsonResponse.where((json) => json["registrationStatus"] == true).toList();

      for (var item in tmp) {
        _vendorRegistrations.add(VendorRegistrationRequest.fromJson(item));
      }

      log("_length: ${_vendorRegistrations.length}");

    })
    .catchError((onError) => log("Error: $onError"));
    super.initState();
  }

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
                  SizedBox(height: 30,),
                  Expanded(
                      child: ListView.separated(
                        itemCount: _vendorRegistrations.length,
                        itemBuilder: (BuildContext context, int index) {
                            return userCard(
                                name: _vendorRegistrations[index]?.ownerName ?? "",
                                location: _vendorRegistrations[index]?.city ?? "",
                                phoneNumber: _vendorRegistrations[index]?.phoneNumber ?? "");
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
    phoneNumber = "91 70876 57843"
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
                        context: context,

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
                            ])
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
