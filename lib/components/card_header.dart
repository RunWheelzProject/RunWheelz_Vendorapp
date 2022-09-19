import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/model/vendor_mechanic.dart';
import 'package:untitled/screens/live_track_map.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/rw_staff_management_screen.dart';
import 'package:untitled/screens/rw_vendor_management_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/screens/vendor_mechanic_dashboard.dart';
import 'package:untitled/services/vendor_registration.dart';
import '../model/customer.dart';
import '../resources/resources.dart' as res;
import 'package:http/http.dart' as http;
import '../manager/profile_manager.dart';
import '../manager/vendor_manager.dart';
import '../model/servie_request.dart';
import '../model/staff.dart';
import '../services/staff_service.dart';

class CardWithHeader extends StatelessWidget {
  List<Widget> children;
  String title;
  CardWithHeader({super.key, required this.children, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white, width: 1.5),
            color: Colors.white),
            child: Column(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.purple, border: Border(bottom: BorderSide())),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      children: children
                  )
              )
            ])
    );
  }
}
