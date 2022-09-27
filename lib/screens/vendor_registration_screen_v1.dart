import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/logo.dart';
import 'package:untitled/manager/customer_managere.dart';
import 'package:untitled/manager/vendor_manager.dart';
import '../services/vendor_registration.dart';
import './google_map_location_screen.dart';
import '../utils/add_space.dart';

class VendorRegistrationV1 extends StatefulWidget {
  const VendorRegistrationV1({Key? key}) : super(key: key);

  @override
  VendorRegistration createState() => VendorRegistration();
}

class VendorRegistration extends State<VendorRegistrationV1> {
  final _formKey = GlobalKey<FormState>();
  String dropDownValue = 'Current Location';
  bool _isTermsChecked = false;
  Data data = Data();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
    final VendorManager vendorManager = Provider.of<VendorManager>(context);
    final CustomerManager customerManager =
        Provider.of<CustomerManager>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Run Wheelz")),
      body: SingleChildScrollView(
          child: Column(children: [
        SizedBox(
          height: 20,
        ),
        Logo(),
        Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
          ),
          child: Column(children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: Colors.purple, border: Border(bottom: BorderSide())),
              child: const Text(
                "Vendor Registration",
                style: TextStyle(fontSize: 21, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    addVerticalSpace(20),
                    RWTextFormField(
                        label: 'Name',
                        icon:
                            const Icon(Icons.person, color: Colors.deepPurple),
                        onSaved: (value) =>
                            vendorManager.vendorDTO.ownerName = value),
                    addVerticalSpace(30),
                    RWTextFormField(
                        label: 'Phone Number',
                        icon: const Icon(Icons.phone_android,
                            color: Colors.deepPurple),
                        textInputType: TextInputType.number,
                        textInputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        ],
                        maxLength: 10,
                        onSaved: (value) =>
                            vendorManager.vendorDTO.phoneNumber = value),
                    addVerticalSpace(30),
                    RWTextFormField(
                        label: 'Garage Name',
                        icon: const Icon(Icons.home, color: Colors.deepPurple),
                        onSaved: (value) =>
                            vendorManager.vendorDTO.garageName = value),
                    addVerticalSpace(30),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Checkbox(
                              value: _isTermsChecked,
                              onChanged: (value) {
                                data.termsAndConditions = value as bool;
                                setState(() {
                                  _isTermsChecked = value;
                                });
                              },
                            ),
                            TextButton(
                                onPressed: () => {},
                                child: const Text("Terms and Conditions"))
                          ],
                        )),
                    addVerticalSpace(20),
                    Container(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                            onPressed: _isTermsChecked
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      _determinePosition()
                                          .then((Position position) async {
                                        LatLng currentLocation = LatLng(
                                            position.latitude,
                                            position.longitude);
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return GoogleMapLocationPickerV1(
                                            isVendor: true,
                                            currentLocation: currentLocation,
                                          );
                                        }));
                                      }).catchError((onError) => log("GoogleMapError: $onError"));
                                    }
                                  }
                                : null,
                            child: const Text(
                              'Next',
                              style: TextStyle(fontSize: 24),
                            )))
                  ],
                )),
          ]),
        )
      ])),
    );
  }
}

class Data {
  String? name;
  String? email;
  String? phoneNumber;
  String? garageName;
  double? latitude;
  double? longitude;
  bool? registrationStatus;
  bool? termsAndConditions;
}

typedef FunctionSaved = void Function(String?)?;

class RWTextFormField extends StatelessWidget {
  final String label;
  final Icon icon;
  final FunctionSaved onSaved;
  final String? helperText;
  final int? maxLength;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? textInputFormatters;

  const RWTextFormField(
      {required this.label,
      required this.icon,
      required this.onSaved,
      this.helperText,
      this.maxLength,
      this.textInputType,
      this.textInputFormatters});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      keyboardType: textInputType,
      inputFormatters: textInputFormatters,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: icon,
        labelStyle: const TextStyle(color: Colors.black45),
        helperStyle: const TextStyle(color: Colors.red, fontSize: 14),
        /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.purple,
              width: 0,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.purple,
              width: 0,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.purple,
              width: 0,
            )),*/
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'this field required';
        }
        return null;
      },
    );
  }
}
