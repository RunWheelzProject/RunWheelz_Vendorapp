import 'dart:convert';
import 'dart:developer';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/utils/add_space.dart';

import '../colors/app_colors.dart';
import '../components/menu.dart';
import '../components/pending_order_card.dart';
import '../components/header_text.dart';
import '../resources/resources.dart' as res;

class PendingOrder extends StatefulWidget {
  final String pageTitle;
  final Map<String, String> data;
  const PendingOrder({Key? key, required this.pageTitle, required this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PendingOrderData();
}

class PendingOrderData extends State<PendingOrder> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Run Wheelz",
                      style: TextStyle(color: Colors.white, fontSize: 23)),
                  addHorizontalSpace(100),
                  const Icon(
                    Icons.account_circle_rounded,
                    color: Colors.white,
                  ),
                  addHorizontalSpace(20),
                  const Icon(
                    Icons.notification_add_rounded,
                    color: Colors.white,
                  ),
                  addHorizontalSpace(20),
                ],
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_back),
        backgroundColor: Colors.purple,
        onPressed: () => {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) {
              return const VendorDashBoard();
            })
          )
        },
      ),
      drawer: Padding(
          padding: const EdgeInsets.fromLTRB(0, 122, 0, 0),
          child: Menu.menuData("menu", res.menuItems)),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(widget.pageTitle, style: const TextStyle(fontSize: 34, color: Colors.white),),
                  addVerticalSpace(20),
                  const SizedBox(
                      width: 300,
                      child: TextField(
                          decoration: InputDecoration(
                              fillColor: Color(0xfffbfcfb),
                              hintStyle: TextStyle(color: Colors.black54),
                              hintText: 'Search a location',
                            prefixIcon: Icon(Icons.person, color: Colors.purple),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                  width: 1,
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                  width: 2,
                                )
                            ),
                              suffixIcon: Icon(
                                Icons.search_outlined,
                                color: Colors.purple,
                              )
                          )
                      )
                  )
                ]
              )
          ),
          addVerticalSpace(10),
          Expanded(
            child: ListView.separated(
            shrinkWrap: true,
            itemCount: 30,
            padding: const EdgeInsets.all(10),
            separatorBuilder: (BuildContext context, int index) {
              return addVerticalSpace(20);
            },
            itemBuilder: (BuildContext context, int index) {
              return const PendingOrderCard();
            },
          ))
        ]
      )
    );
  }
}


/*
TextField(
controller: _locationController,
enabled: !_isChecked,
decoration: const InputDecoration(
hintText: 'Search a location',
enabledBorder: OutlineInputBorder(
borderSide: BorderSide(width: 1.0)),
suffixIcon: Icon(
Icons.search_outlined,
color: Colors.black,
)),
onChanged: (value) {
log("value: $value");
_locationManager.searchLocations(value);
*/
/*RPlaceAutoComplete()
                            .getAutoComplete(value)
                            .then((placeSearchData) {
                              _locationManager.setSearchedLocations = placeSearchData;
                          //_locationManager.searchedLocations(value);
                        });*//*

},
)*/
