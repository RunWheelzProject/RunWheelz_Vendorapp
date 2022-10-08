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
import 'package:searchable_listview/searchable_listview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/components/card_header.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/model/vendor_mechanic.dart';
import 'package:untitled/screens/customer_board.dart';
import 'package:untitled/screens/live_track_map.dart';
import 'package:untitled/screens/offer_screen.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/rw_staff_management_screen.dart';
import 'package:untitled/screens/rw_vendor_management_screen.dart';
import 'package:untitled/screens/splashscreen_v1.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/screens/vendor_mechanic_dashboard.dart';
import 'package:untitled/services/vendor_registration.dart';
import '../components/customer_appbar.dart';
import '../model/customer.dart';
import '../model/offer_dto.dart';
import '../resources/resources.dart' as res;
import 'package:http/http.dart' as http;
import '../manager/profile_manager.dart';
import '../manager/vendor_manager.dart';
import '../model/servie_request.dart';
import '../model/staff.dart';
import '../services/staff_service.dart';
import '../utils/get_location.dart';
import 'data_viewer_screen.dart';

class CurrentOffersScreen extends StatefulWidget {
   CurrentOffersScreen({Key? key}) : super(key: key);

  @override
  CurrentOffersScreenState createState() => CurrentOffersScreenState();
}

class CurrentOffersScreenState extends State<CurrentOffersScreen> {
  List<OfferDTO> _offerDTOList = [];



  Future<bool> checkLogIn() async {
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
  @override
  void initState() {
    super.initState();

    getActiveOffers().then((offers) {
      setState(() {
        _offerDTOList = offers;
      });
    }).catchError((error) => log("$error"));
  }

  @override
  Widget build(BuildContext context) {
    return CustomerAppBar(
        child: _mainContainer()
    );
  }


  Widget _mainContainer() {
    return Container(
          margin: const EdgeInsets.only(top: 80),
          padding: const EdgeInsets.all(20),
          child: SearchableList<OfferDTO>(
            initialList: _offerDTOList,
            builder: (OfferDTO offerDTO) => Item(offerDTO: offerDTO,),
            filter: (value) => _offerDTOList.where((element) => element.id?.toString().contains(value) as bool).toList(),
            onItemSelected: (OfferDTO item) {

              checkLogIn().then((res) {
                if (res) {
                  log("test: ${jsonEncode(item)}");
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return RunWheelzOffer(offerDTO: item,);
                      })
                  );
                } else {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          AlertDialog(
                              title:
                              const Text("LogIn"),
                              content: const Text("Please login to view offer details",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87)),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pushNamed(context, '/ask_login'),
                                  child: const Text('OK'),
                                ),
                              ]
                          )
                  );
                }
              });

            },
            inputDecoration: InputDecoration(
              labelText: "Search offer",
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        );
  }
}


class Item extends StatelessWidget {
  OfferDTO offerDTO;
  Item({Key? key, required this.offerDTO}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(
                  Icons.remove_red_eye,
                  color: Colors.purple,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(children: const [
                  CircleAvatar(radius: 45.0, backgroundImage: AssetImage("images/bike-oil.jpg"))
                ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        offerDTO.offerName ?? "No Name",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87),
                        textAlign: TextAlign.left,
                      )
                    ]),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        const Icon(
                          Icons.attach_money,
                          color: Colors.purple,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text("${offerDTO.offerDiscountAmount}" ?? "not found",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black)),
                        const SizedBox(
                          width: 15,
                        ),
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ));
  }
}