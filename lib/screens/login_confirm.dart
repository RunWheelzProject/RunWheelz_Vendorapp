import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/future_manager.dart';
import 'package:untitled/manager/location_manager.dart';
import 'package:untitled/manager/login_manager.dart';
import 'package:untitled/manager/vendor_manager.dart';
import 'package:untitled/model/servie_request.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/request_status_screen.dart';
import 'package:untitled/screens/vendor_info_display_screen.dart';
import 'package:untitled/services/vendor_registration.dart';
import 'package:untitled/utils/add_space.dart';

import '../components/logo.dart';
import '../manager/service_request_manager.dart';
import '../services/service_request_service.dart';

class LogInConfirmation extends StatelessWidget {
  const LogInConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple,
        body: Container(
            /*decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/download.jpg"),
                  fit: BoxFit.cover,
                ),
              ),*/
            child:Center(
              child: Container(
                margin: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              height: 400,
              decoration: const BoxDecoration(
                  color: Colors.white
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Logo(),
                  const SizedBox(height: 50,),
                  ElevatedButton(
                      onPressed: () {
                        LogInManager loginManager = Provider.of<LogInManager>(context, listen: false);
                        loginManager.setCurrentURLs("customerRegistration");
                        Navigator.pushNamed(context, '/phone_verification');
                      },
                      child: const Text("Customer")
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        LogInManager loginManager = Provider.of<LogInManager>(context, listen: false);
                        loginManager.setCurrentURLs("userLogIn");
                        Navigator.pushNamed(context, '/phone_verification');
                      },
                      child: const Text("Vendor/Staff")
                  ),
                ],
              ),)
          )
    ));
  }
}
