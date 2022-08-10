import 'dart:convert';
import 'dart:developer';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../components/menu.dart';
import '../components/item_row.dart';
import '../components/header_text.dart';
import '../resources/resources.dart' as res;

class DetailsAndStatus extends StatefulWidget {
  const DetailsAndStatus({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => Details();
}

class Details extends State<DetailsAndStatus> {

  final Map<String, String> _serviceDetails = {
    "Request ID": "32456",
    "Request Date": "12-04-2022",
    "Service Category": "Breakdown",
    "Service Type": "Puncture",
    "Model": "Honda",
    "Vehicle Number": "AP 29 PQ 1234"
  };

  final Map<String, String> _vendorDetails = {
    "Garage Name": "KPHP",
    "Vendor Mobile": "9845637383",
    "Vendor Staff Name": "Ravi  ",
    "Vendor Staff Mobile": "9846467544",
    "Vendor Accepted Time": "09:30 AM",
    "Staff Accepted Time": "09:35 AM",
    "ETA": "10min"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Services"),
        backgroundColor: res.appBarColor,
        iconTheme: const IconThemeData(color: Colors.black, size: 30),
      ),
      drawer: Menu.menuData("Menu", res.menuItems),
      body: _mainContainer(context),
    );
  }

  Widget _mainContainer(BuildContext context) {
    return Container(
        color: Colors.black12,
        child: Column(
          children: <Widget>[
            Container(
                height: res.headerSize,
                width: MediaQuery.of(context).size.width,
                color: res.bgColor,
                child: HeaderText("Details & Services")),
            const SizedBox(
              height: 20,
            ),
            requestDetails(),
            const SizedBox(height: 10,),
            vendorDetails(),
          ],
        ));
  }

  Widget requestDetails() {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors().BG_color,
        ),
        child: Column(
          children: [
            const Text("Reqeust Details", style: TextStyle(fontSize: 20, color: Colors.yellow)),
            const SizedBox(height: 20,),
            for (var item in _serviceDetails.keys)
              ItemRow(item, _serviceDetails[item])
          ],
        ));
  }

  Widget vendorDetails() {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors().BG_color,
        ),
        child: Column(
          children: [
            const Text("Vendor Details", style: TextStyle(fontSize: 20, color: Colors.yellow)),
            const SizedBox(height: 20,),
            for (var item in _vendorDetails.keys)
              ItemRow(item, _vendorDetails[item])
          ],
        ));
  }
}
