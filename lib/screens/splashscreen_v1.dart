/*
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/manager/login_manager.dart';
import 'package:untitled/model/vendor_mechanic.dart';
import 'package:untitled/services/phone_verification.dart';
import 'package:untitled/utils/add_space.dart';
import '../components/logo.dart';
import '../firebase_options.dart';
import '../manager/profile_manager.dart';
import '../model/customer.dart';
import '../model/staff.dart';
import '../model/vendor.dart';
import 'login_page_screen.dart';
import 'dart:async';
import '../resources/resources.dart' as res;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SplashScreenV1 extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreenV1> {
  Timer? timer;

  Future<String> checkLogIn() async {
    ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    Provider.of<LogInManager>(context, listen: false)
        .setCurrentURLs("userLogIn");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if ((prefs.getBool("SHARED_LOGGED") != null)) {
      bool isLoggedIn = prefs.getBool("SHARED_LOGGED") as bool;
      log("isLoggedIn: $isLoggedIn");
      if (isLoggedIn) {
        if (prefs.getString("vendorDTO") != null) {
          var json = jsonDecode(prefs.getString("vendorDTO") ?? "{}");
          log("isLoggedIn: ${jsonEncode(json)}");
          profileManager.vendorDTO = VendorDTO.fromJson(json);
          return '/vendor_dashboard';
          //Navigator.pushNamed(context, 'vendor_dashboard');
        } else if (prefs.getString("customerDTO") != null) {
          var json = jsonDecode(prefs.getString("customerDTO") ?? "{}");
          profileManager.customerDTO = CustomerDTO.fromJson(json);
          return '/customer_dashboard';
        } else if (prefs.getString("vendorStaffDTO") != null) {
          var json = jsonDecode(prefs.getString("vendorStaffDTO") ?? "{}");
          profileManager.vendorMechanic = VendorMechanic.fromJson(json);
          return '/mechanic_dashboard';
        } else if (prefs.getString("runwheelzStaffDTO") != null) {
          var json = jsonDecode(prefs.getString("runwheelzStaffDTO") ?? "{}");
          profileManager.staffDTO = StaffDTO.fromJson(json);
          return '/staff_dashboard';
        }
      }
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    //checkLogIn();
    */
/*timer = Timer(const Duration(seconds: 5), () async {
      checkLogIn().then((route) {
        if (route.isNotEmpty) {
          Navigator.pushNamed(context, route);
        } else {
          Navigator.pushNamed(context, '/ask_login');
        }
      });

    }
    );*//*

  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            //color: Colors.purpleAccent,
            padding: const EdgeInsets.only(top: 60),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Container(
                color: Colors.purple,
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                    child: Text(
                  "RUN WHEELZ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'josefin slab',
                      fontSize: 54,
                      color: Color(0xfffdcd00),
                      shadows: [
                        Shadow(
                            color: Colors.black87,
                            offset: Offset(3.0, 3.0),
                            blurRadius: 3.0)
                      ]),
                )),
              ),
              Center(
                child: Container(
                    padding: const EdgeInsets.all(20),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: const Image(image: AssetImage("images/logo_1.png"))),
                //color: Colors.purpleAccent,
              ),
              Center(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                height: 320,
                decoration: const BoxDecoration(color: Colors.purple),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 250,
                        child: TextButton(
                            style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                        RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(2.0),
                            ))),
                            onPressed: () {
                              LogInManager loginManager =
                                  Provider.of<LogInManager>(context,
                                      listen: false);
                              loginManager
                                  .setCurrentURLs("customerRegistration");
                              Navigator.pushNamed(
                                  context, '/phone_verification');
                            },
                            child: const Text(
                              "Customer Login",
                              style: TextStyle(color: Colors.white),
                            ))),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: 250,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                        RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(2.0),
                            ))),
                            onPressed: () {
                              LogInManager loginManager =
                                  Provider.of<LogInManager>(context,
                                      listen: false);
                              loginManager.setCurrentURLs("userLogIn");
                              Navigator.pushNamed(
                                  context, '/phone_verification');
                            },
                            child: const Text("Vendor/Mechanic Login",
                                style: TextStyle(color: Colors.white)))),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: 250,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                        RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(2.0),
                            ))),
                            onPressed: () {
                              LogInManager loginManager =
                                  Provider.of<LogInManager>(context,
                                      listen: false);
                              loginManager.setCurrentURLs("userLogIn");
                              Navigator.pushNamed(
                                  context, '/phone_verification');
                            },
                            child: const Text("RunWheelz Login",
                                style: TextStyle(color: Colors.white)))
                    ),
                  ],
                ),
              ))
            ])));
  }
}
*/

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/manager/login_manager.dart';
import 'package:untitled/model/vendor_mechanic.dart';
import 'package:untitled/services/phone_verification.dart';
import 'package:untitled/utils/add_space.dart';
import '../components/logo.dart';
import '../firebase_options.dart';
import '../manager/profile_manager.dart';
import '../model/customer.dart';
import '../model/staff.dart';
import '../model/vendor.dart';
import 'login_page_screen.dart';
import 'dart:async';

class SplashScreenV1 extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreenV1> {
  Timer? timer;

  Future<bool> todayOffers() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if ((prefs.getBool("SHARED_LOGGED") != null)) {
      bool isLoggedIn = prefs.getBool("SHARED_LOGGED") as bool;
      log("isLogged: $isLoggedIn");
      return true;
    }

    throw false;

  }

  Future<String> checkLogIn() async {
    ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
    //Provider.of<LogInManager>(context, listen: false).setCurrentURLs("userLogIn");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if ((prefs.getBool("SHARED_LOGGED") != null)) {
      bool isLoggedIn = prefs.getBool("SHARED_LOGGED") as bool;
      log("isLoggedIn2: $isLoggedIn");
      if (isLoggedIn) {
        if (prefs.getString("vendorDTO") != null) {
          var json = jsonDecode(prefs.getString("vendorDTO") ?? "{}");
          log("vendor: ${jsonEncode(json)}");
          profileManager.vendorDTO = VendorDTO.fromJson(json);
          return '/vendor_dashboard';
          //Navigator.pushNamed(context, 'vendor_dashboard');
        } else if (prefs.getString("customerDTO") != null) {
          var json = jsonDecode(prefs.getString("customerDTO") ?? "{}");
          log("customer: ${jsonEncode(json)}");
          profileManager.customerDTO = CustomerDTO.fromJson(json);
          return '/customer_dashboard';
        } else if (prefs.getString("vendorStaffDTO") != null) {
          var json = jsonDecode(prefs.getString("vendorStaffDTO") ?? "{}");
          log("mechanic: ${jsonEncode(json)}");
          profileManager.vendorMechanic = VendorMechanic.fromJson(json);
          return '/mechanic_dashboard';
        } else if (prefs.getString("runwheelzStaffDTO") != null) {
          var json = jsonDecode(prefs.getString("runwheelzStaffDTO") ?? "{}");
          log("staff: ${jsonEncode(json)}");
          profileManager.staffDTO = StaffDTO.fromJson(json);
          return '/staff_dashboard';
        }
      }
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
      checkLogIn().then((route) {
        if (route.isNotEmpty) {
          Navigator.pushNamed(context, route);
        }
      });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          //color: Colors.purpleAccent,
            padding: const EdgeInsets.only(top: 60),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    color: Colors.purple,
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                        child: Text(
                          "RUN WHEELZ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'josefin slab',
                              fontSize: 54,
                              color: Color(0xfffdcd00),
                              shadows: [
                                Shadow(
                                    color: Colors.black87,
                                    offset: Offset(3.0, 3.0),
                                    blurRadius: 3.0)
                              ]),
                        )),
                  ),
                  Center(
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: const Image(image: AssetImage("images/logo_1.png"))),
                    //color: Colors.purpleAccent,
                  ),
                  Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        decoration: const BoxDecoration(color: Colors.purple),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 250,
                                child: TextButton(
                                    style: ButtonStyle(
                                        shape:
                                        MaterialStateProperty.all<OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.white, width: 2),
                                              borderRadius: BorderRadius.circular(2.0),
                                            ))),
                                    onPressed: () {
                                      LogInManager loginManager =
                                      Provider.of<LogInManager>(context,
                                          listen: false);
                                      loginManager
                                          .setCurrentURLs("customerRegistration");
                                      Navigator.pushNamed(
                                          context, '/phone_verification');
                                    },
                                    child: const Text(
                                      "Customer Login",
                                      style: TextStyle(color: Colors.white),
                                    ))),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape:
                                        MaterialStateProperty.all<OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.white, width: 2),
                                              borderRadius: BorderRadius.circular(2.0),
                                            ))),
                                    onPressed: () {
                                      LogInManager loginManager =
                                      Provider.of<LogInManager>(context,
                                          listen: false);
                                      loginManager.setCurrentURLs("userLogIn");
                                      Navigator.pushNamed(
                                          context, '/phone_verification');
                                    },
                                    child: const Text("Vendor/Mechanic Login",
                                        style: TextStyle(color: Colors.white)))),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape:
                                        MaterialStateProperty.all<OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.white, width: 2),
                                              borderRadius: BorderRadius.circular(2.0),
                                            ))),
                                    onPressed: () {
                                      LogInManager loginManager =
                                      Provider.of<LogInManager>(context,
                                          listen: false);
                                      loginManager.setCurrentURLs("userLogIn");
                                      Navigator.pushNamed(
                                          context, '/phone_verifconst ication');
                                    },
                                    child: const Text("RunWheelz Login",
                                        style: TextStyle(color: Colors.white)))
                            ),
                          ],
                        ),
                      )),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 170,
                              child: TextButton(
                                  style: ButtonStyle(
                                      shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                          RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: Colors.purple, width: 2),
                                            borderRadius: BorderRadius.circular(2.0),
                                          ))),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/offers_screen');
                                  },
                                  child: Row(
                                    children: const [
                                      Text("Today's offers", style: TextStyle(color: Colors.purple, fontSize: 16)),
                                      SizedBox(width: 20,),
                                      Icon(Icons.arrow_circle_right, color: Colors.purple, size: 30,)
                                    ],
                                  )
                              ),
                            ),
                            const SizedBox(height: 20,),
                            const Text("Customer: ",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 21,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.purple),
                            ),
                            const SizedBox(height: 15,),
                            const Text("At Runwheel we share passion for smooth and excellent riding by maintain values.\n\nBy joining RunWheelz as customer service come to you you don't have to go anywhere."),
                            const SizedBox(height: 25,),
                            const Text("Vendor: ",
                              textAlign: TextAlign.left,
                              style: TextStyle( fontSize: 21,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.purple),),
                            const SizedBox(height: 15,),
                            const Text("At Runwheel we share passion for smooth and excellent riding by maintain values.\n\nBy joining RunWheelz As Vendor you don't have to find customer, customers will come to you for service through app")
                          ],
                        )
                    )
                  ]
            )
        )
    );
  }
}
