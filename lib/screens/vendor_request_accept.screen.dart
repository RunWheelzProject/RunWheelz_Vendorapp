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
import 'package:untitled/screens/vendor_select_mechanic.dart';
import 'package:untitled/services/vendor_registration.dart';

import '../manager/profile_manager.dart';
import '../model/staff.dart';
import '../services/staff_service.dart';


class VendorRequestAcceptScreen extends StatelessWidget {



  VendorRequestAcceptScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () => {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
                return const VendorDashBoard();
              })
          )
        },
        child: const Icon(Icons.arrow_back),
      ),
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Accept Request",
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: 350,
          margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 10,
                    blurRadius: 30),
              ]
          ),
          child: Column(
            children: [
              Row(
                children: const [
                  Text("Service: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  SizedBox(width: 10,),
                  Text("Puncture")
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: const [
                  Text("Vehicle Type: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  SizedBox(width: 10,),
                  Text("Hero")
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: const [
                  Text("Vehicle Type: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  SizedBox(width: 10,),
                  Text("Hero")
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: const [
                  Text("Vehicle Number: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  SizedBox(width: 10,),
                  Text("AP 10, 20123")
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: const [
                  Text("Location: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  SizedBox(width: 10,),
                  Text("lingampalley")
                ],
              ),
              SizedBox(height: 70,),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (BuildContext context) {
                          return VendorSelectMechanicScreen();
                        })
                    )
                  },
                  child: const Text("Accept")
              )
              )
            ],
          ),
        ),
      )
    );
  }

}

