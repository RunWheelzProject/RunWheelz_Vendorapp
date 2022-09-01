import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/rw_staff_management_screen.dart';
import 'package:untitled/screens/rw_vendor_management_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/services/vendor_registration.dart';

import '../manager/profile_manager.dart';
import '../model/staff.dart';
import '../services/staff_service.dart';
import 'data_viewer_screen.dart';

class VendorPendingScreen extends StatelessWidget {
  VendorPendingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () => {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
                return const VendorDataManagementPage(pageTitle: "Pending");
              }))
        },
        child: const Icon(Icons.arrow_back),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "Pending Request",
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text("Service Details",
                      style: TextStyle(color: Colors.deepOrange, fontSize: 20),),
                  ),
                  const SizedBox(height: 30,),
                  Row(
                    children: const [
                      Text(
                        "Service: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Puncture")
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Vehicle Type: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Hero")
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Vehicle Type: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Hero")
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Vehicle Number: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("AP 10, 20123")
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Location: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("lingampalley")
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text("Mechanic Details",
                      style: TextStyle(color: Colors.deepOrange, fontSize: 20),),
                  ),
                  const SizedBox(height: 30,),

                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Name: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Ravi")
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: const [
                      Text(
                        "Mobile: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("98785 25210")
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
