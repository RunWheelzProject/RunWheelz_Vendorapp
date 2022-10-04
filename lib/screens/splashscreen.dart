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
class SplashScreen extends StatefulWidget {

  @override
  SplashScreenState createState() => SplashScreenState();
}
class SplashScreenState extends State<SplashScreen>{
  Timer? timer;

  Future<String> checkLogIn() async {
    ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
    Provider.of<LogInManager>(context, listen: false).setCurrentURLs("userLogIn");
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
        }else if (prefs.getString("customerDTO") != null) {
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
    timer = Timer(const Duration(seconds: 5), () async {
      checkLogIn().then((route) {
        if (route.isNotEmpty) {
          Navigator.pushNamed(context, route);
        } else {
          Navigator.pushNamed(context, '/ask_login');
        }
      });

    }
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();

  }

  @override
  Widget build(BuildContext context) {
   TextTheme textTheme = Theme.of(context).textTheme;
   /* Timer(
        const Duration(seconds: 5), () async {
          Navigator.pushNamed(context, '/ask_login');
        }
    );*/
    return   Scaffold(
        body:  Container(
          //color: Colors.purpleAccent,
          padding: const EdgeInsets.only(top: 100),
          child: Column(
              children: [
                Logo(),
                addVerticalSpace(100),
                const Center(
                  child: Image(image: AssetImage("images/logo_1.png")),
                  //color: Colors.purpleAccent,
                ),
              ]))
    );
  }
}

