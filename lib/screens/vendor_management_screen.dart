import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:untitled/screens/login_page_screen.dart';

import '../components/logo.dart';
import '../resources/resources.dart' as res;

class VendorManagementPage extends StatefulWidget {

  const VendorManagementPage({Key? key}) : super(key: key);

  @override
  State<VendorManagementPage> createState() => _VendorManagementPageState();
}

class _VendorManagementPageState extends State<VendorManagementPage> {

  @override
  Widget build(BuildContext context) {
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
                          Uri vendorRegistrationURL = Uri.parse("${res.APP_URL}/api/auth/register/vendor/sendOtp");
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                              return LoginScreen(uri: vendorRegistrationURL);
                            })
                          );
                        },
                        child: const Text("Add Vendor + ")
                    ),
                  ),
                  const SizedBox(height: 20,),
                  userCard(),
                  const SizedBox(height: 20,),
                  userCard(),
                  const SizedBox(height: 20,),
                  userCard()
                ]
            ) // This trailing comma makes auto-formatting nicer for build methods.
        )
    );
  }

  Widget userCard() {
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
                SizedBox(
                    height: 27,
                    child: ElevatedButton(
                        onPressed: () => {},
                        child: const Text(
                            "VIEW PROFILE", style: TextStyle(
                            fontSize: 12))
                    ))
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                    children: const [
                      CircleAvatar(
                          radius: 25.0,
                          backgroundImage: AssetImage(
                              "images/logo.jpg")
                      )
                    ]
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                        children: const [
                          SizedBox(width: 10,),
                          Text("Amanda Graham", style: TextStyle(
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
                      children: const [
                        SizedBox(width: 15,),
                        Icon(
                          Icons.location_on, color: Colors.blue,
                          size: 15,),
                        SizedBox(width: 5,),
                        Text("Bergen", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Colors.black45
                        )),
                        SizedBox(width: 15,),
                        Icon(Icons.link, color: Colors.blue,),
                        SizedBox(width: 5,),
                        Text("website.com", style: TextStyle(
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
