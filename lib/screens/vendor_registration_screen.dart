/*
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/future_manager.dart';
import 'package:untitled/components/google_map_location_picker.dart';
import 'package:untitled/manager/manager.dart';
import 'package:untitled/utils/add_space.dart';
import '../screens/vendor_info_display_screen.dart';
import '../services/phone_verification.dart';
import '../services/vendor_registration.dart';
import '../model/vendor.dart';

enum SingingCharacter { currentLocation }

class VendorRegistration extends StatefulWidget {
  const VendorRegistration({Key? key}) : super(key: key);

  @override
  _VendorRegistration createState() => _VendorRegistration();
}

class _VendorRegistration extends State<VendorRegistration> {
  // Define a key to access the form
  //final _formKey = GlobalKey<FormState>();
  final VendorRegistrationRequest _vendorRegistrationRequest =
      VendorRegistrationRequest();
  String dropDownValue = 'Current Location';
  bool _isTermsChecked = false;
  bool _isLocationChecked = true;
  late Future<Position> _position;
  // List of items in our dropdown menu
  var items = ['Current Location', 'Browse Location'];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _position = _determinePosition();
    _position.then((Position position) {

      log("Position: $position");
    }).catchError((onError) => log("onError: $onError"));
  }

  */
/*Widget futureAction(http.Response response) {
    var responseJson = jsonDecode(response.body);
    log("responseJson: $responseJson");
    if (response.statusCode == 201) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return VendorRegistrationInfoDisplay(
          id: responseJson["id"],
        );
      }));
    }
    log("ServerError: ${responseJson["message"]}");
    return Text('${responseJson["message"]} occurred',
        style: const TextStyle(fontSize: 18));
  }*//*


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Run Wheelz")),
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 34, bottom: 34),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 45, top: 40, right: 45, bottom: 30),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                          child: Text(
                        "Vendor Registration",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      )),
                      addVerticalSpace(35),

                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.arrow_circle_down, size: 24, color: Colors.deepPurple,),
                          addHorizontalSpace(10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => browseLocation(),
                              child: Container(
                                // optional
                                  padding: const EdgeInsets.only(bottom: 1.0),
                                  decoration:const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1.0, color: Colors.deepPurple))),
                                  child: const Text('Browse Location',
                                  style: TextStyle(fontSize: 16, color: Colors.deepPurple))),
                            ))]),
                          addVerticalSpace(5),
                          Row(
                            children: [
                          addHorizontalSpace(40),
                          Consumer<ApplicationManager>(
                              builder: (context, manager, child) {
                                log("registrationLocation: ${manager.currentLocation}");
                                return Flexible(child: Text(
                                  "Location: ${manager.currentLocation}",
                                  style: const TextStyle(fontSize: 16),
                                ));
                              })]),
                          addVerticalSpace(40),
                        ]),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: const TextStyle(color: Colors.black87),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[600] as Color,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey[600] as Color)),
                        ),
                        onChanged: (value) => {
                          setState(() =>
                              {_vendorRegistrationRequest.ownerName = value})
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'this field required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'phoneNumber',
                          labelStyle: const TextStyle(color: Colors.black87),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[600] as Color,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey[600] as Color)),
                        ),
                        onChanged: (value) {
                          setState(() => {
                                _vendorRegistrationRequest.phoneNumber =
                                    int.parse(value)
                              });
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        ],
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'this field required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'GarageName',
                          labelStyle: const TextStyle(color: Colors.black87),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[600] as Color,
                            ),
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent)),
                        ),
                        onChanged: (value) => {
                          setState(() =>
                              {_vendorRegistrationRequest.garageName = value})
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'this field required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          */
/*Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Consumer<LocationManager>(
                                    builder: (context, manager, child) {
                                  log("registrationLocation: ${manager.currentLocation}");
                                  return Text(
                                    "Location: ${manager.currentLocation}",
                                    style: const TextStyle(fontSize: 16),
                                  );
                                }),
                                addVerticalSpace(20),
                                *//*
*/
/*Row(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Checkbox(
                                  value: _isLocationChecked,
                                  onChanged: (value) {
                                    log("_isLocationChecked: $value");
                                    setState(() {
                                      _isLocationChecked = value as bool;
                                    });
                                  },
                                )),
                            const Text("Use Current Location"),
                          ],
                        ),*//*
*/
/*
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: ElevatedButton(
                                        onPressed: () => browseLocation(),
                                        child: const Text("Browse Location"))),
                                const SizedBox(
                                  height: 20,
                                ),
                                *//*
*/
/*Row(
                          children: [
                            const Text("Longitude: ",
                                style: TextStyle(fontSize: 16)),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                                _vendorRegistrationRequest.longitude
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text("Latitude: ",
                                style: TextStyle(fontSize: 16)),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                                _vendorRegistrationRequest.latitude
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87))
                          ],
                        )*//*
*/
/*
                              ])*//*

                        ],
                      ),
                      addVerticalSpace(0),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Checkbox(
                                value: _isTermsChecked,
                                onChanged: (value) {
                                  log("_isChecked: $value");
                                  setState(() {
                                    _isTermsChecked = value as bool;
                                    _vendorRegistrationRequest
                                        .termsAndConditions = _isTermsChecked;
                                  });
                                },
                              ),
                              TextButton(
                                  onPressed: () => {},
                                  child: const Text("Terms and Conditions"))
                            ],
                          )),
                      addVerticalSpace(30),
                      Container(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                              onPressed: _isTermsChecked
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _vendorRegistrationRequest.latitude = Provider.of<ApplicationManager>(context, listen: false).latitude;
                                          _vendorRegistrationRequest.longitude = Provider.of<ApplicationManager>(context, listen: false).longitude;
                                        });
                                        VendorRegistrationService()
                                            .vendorRegistrationRequest(
                                                _vendorRegistrationRequest)
                                            .then((response) {
                                          var body = jsonDecode(response.body);
                                          String? error =
                                              FutureManager.goToNextScreen(
                                                  context,
                                                  response,
                                                  201,
                                                  VendorRegistrationInfoDisplay(
                                                    id: body["id"],
                                                  ));
                                          log("ServerError: $error");
                                        }).catchError((error) {
                                          log("ServerError: $error");
                                        });
                                      }
                                    }
                                  : null,
                              child: const Text('Register')))
                    ],
                  )),
            ),
          )),
    );
  }

  void browseLocation() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return const GoogleMapLocationPicker();*/
/*ChangeNotifierProvider(
          create: (_) => LocationManager(),
          child: const GoogleMapLocationPicker());*//*

    }));
  }
}
*/
