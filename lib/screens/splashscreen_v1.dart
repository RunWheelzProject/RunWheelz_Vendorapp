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
import 'package:google_fonts/google_fonts.dart';
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
import '../model/offer_dto.dart';
import '../model/staff.dart';
import '../model/vendor.dart';
import 'login_page_screen.dart';
import 'dart:async';

import '../resources/resources.dart' as res;
import 'package:http/http.dart' as http;

import 'offer_screen.dart';

class SplashScreenV1 extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreenV1> {
  Timer? timer;
  List<OfferDTO> _offerDTOList = [];


  Future<List<OfferDTO>> getActiveOffers() async {
    Uri uri = Uri.parse("${res.APP_URL}/api/offers/getAllOffers");
    http.Response response = await http.get(uri);
    var jsonList = jsonDecode(response.body) as List;
    List<OfferDTO> offersList = [];
    if (response.statusCode == 200) {
      for (var json in jsonList) {
        offersList.add(OfferDTO.fromJson(json));
      }

      return offersList;
    }

    throw Exception("servier error");
  }

  Future<bool> todayOffers() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if ((prefs.getBool("SHARED_LOGGED") != null)) {
      bool isLoggedIn = prefs.getBool("SHARED_LOGGED") as bool;
      log("isLogged: $isLoggedIn");
      return true;
    }

    throw false;

  }

  Future<bool> checkLogInWithBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if ((prefs.getBool("SHARED_LOGGED") != null)) {
      bool isLoggedIn = prefs.getBool("SHARED_LOGGED") as bool;
      log("isLogged: $isLoggedIn");
      if (isLoggedIn) {
        return true;
      }
    }
    return false;
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
      getActiveOffers().then((offers) {
        setState(() {
          _offerDTOList = offers;
        });
      }).catchError((error) => log("$error"));
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
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                        child: Text(
                          "RUN WHEELZ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'josefin slab',
                              fontSize: 48,
                              color: Colors.redAccent,
                              shadows: [
                                Shadow(
                                    color: Colors.black12,
                                    offset: Offset(1.0, 2.0),
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
                        decoration: const BoxDecoration(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape:
                                        MaterialStateProperty.all<OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.purple, width: 0),
                                              borderRadius: BorderRadius.circular(2.0),
                                            ))),
                                    onPressed: () {
                                      LogInManager loginManager =
                                      Provider.of<LogInManager>(context,
                                          listen: false);
                                      loginManager.setCurrentURLs("customerRegistration");
                                      Navigator.pushNamed(
                                          context, '/phone_verification');
                                    },
                                    child: const Text("Customer LogIn",
                                        style: TextStyle(color: Colors.white)))),
                            const SizedBox(
                              height: 10,
                            ),
                            //customerRegistration
                            SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape:
                                        MaterialStateProperty.all<OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.purple, width: 0),
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
                              height: 10,
                            ),
                            SizedBox(
                                width: 250,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape:
                                        MaterialStateProperty.all<OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.white, width: 0),
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
                      )),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("About RunWheelz: ",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.sourceSansPro(fontSize: 21,
                                  fontWeight: FontWeight.w500,),
                            ),
                            const SizedBox(height: 15,),
                            const Text("At Runwheelz we share passion for smooth and excellent riding by maintain values.\n\nBy joining RunWheelz as customer service come to you you don't have to go anywhere."),
                            const SizedBox(height: 25,),
                            Text("Customer: ",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.sourceSansPro(fontSize: 21,
                                    fontWeight: FontWeight.w500,),
                            ),
                            const SizedBox(height: 15,),
                            const Text("At Runwheelz we share passion for smooth and excellent riding by maintain values.\n\nBy joining RunWheelz as customer service come to you you don't have to go anywhere."),
                            const SizedBox(height: 25,),
                            Text("Vendor: ",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.sourceSansPro(fontSize: 21,
                                  fontWeight: FontWeight.w500,)
                            ),
                            const SizedBox(height: 15,),
                            const Text("At Runwheel we share passion for smooth and excellent riding by maintain values.\n\nBy joining RunWheelz As Vendor you don't have to find customer, customers will come to you for service through app"),
                            const SizedBox(height: 25,),
                            Text("ToDay's Offers: ",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.sourceSansPro(fontSize: 21,
                                  fontWeight: FontWeight.w500,),),
                            const SizedBox(height: 25,),
                            ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, pos) {
                                  return GestureDetector(
                                    child: Item(offerDTO: _offerDTOList[pos],),
                                    onTap: () {
                                      checkLogInWithBool().then((res) {
                                        if (res) {
                                          //log("test: ${jsonEncode(item)}");
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(builder: (BuildContext context) {
                                                return RunWheelzOffer(
                                                  offerDTO: _offerDTOList[pos],
                                                );
                                              }));
                                        } else {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                                  title: const Text("LogIn"),
                                                  content: const Text(
                                                      "Please login to view offer details",
                                                      style: TextStyle(
                                                          fontSize: 18, color: Colors.black87)),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pushNamed(context, '/ask_login'),
                                                      child: const Text('OK'),
                                                    ),
                                                  ]));
                                        }
                                      });
                                    },
                                  );
                                },
                                separatorBuilder: (BuildContext context, pos) => const SizedBox(height: 10),
                                itemCount: _offerDTOList.length
                            )

                          ],
                        )
                    )
                  ]
            )
        )
    );
  }
}



class Item extends StatelessWidget {
  OfferDTO offerDTO;
  Item({Key? key, required this.offerDTO}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Column(children: [
              Container(

                  height: 80,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: const SizedBox(
                      height: 70,
                      width: 70,
                      child: Image(
                        image: AssetImage("images/bike-oil.jpg"),
                      )))
            ]),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offerDTO.offerName ?? "No Name",
                        style: GoogleFonts.roboto(textStyle: const TextStyle(fontWeight: FontWeight.bold)),
                        textAlign: TextAlign.left,
                      )
                    ]),
                const SizedBox(height: 3,),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Item Description",
                        style: GoogleFonts.roboto(textStyle: const TextStyle(fontSize: 12, color: Colors.black38)),
                        textAlign: TextAlign.left,
                      )
                    ]),
                const SizedBox(height: 25,),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "100.00 INR",
                        style: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.deepPurple, fontSize: 16, fontWeight: FontWeight.bold)),
                        textAlign: TextAlign.left,
                      )
                    ])
              ],
            ),
            const SizedBox(width: 85,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.black38,
                      ),
                      width: 25,
                      height: 25,
                      child: const Center(
                        child: Icon(Icons.add,size: 14.0, color: Colors.white,),
                      ),
                    )
                ),
                const SizedBox(height: 5,),
                Text(
                  "1" ,
                  style: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.deepPurple, fontSize: 16, fontWeight: FontWeight.bold)),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 5,),
                GestureDetector(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.black38,
                      ),
                      width: 25,
                      height: 25,
                      child: const Center(
                        child: Icon(Icons.remove,size: 14.0, color: Colors.white,),
                      ),
                    )
                ),
              ],
            )
          ],
        ));
  }
}
