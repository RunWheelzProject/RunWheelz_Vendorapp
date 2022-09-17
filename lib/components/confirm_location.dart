import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/future_manager.dart';
import 'package:untitled/manager/location_manager.dart';
import 'package:untitled/manager/vendor_manager.dart';
import 'package:untitled/model/servie_request.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/request_status_screen.dart';
import 'package:untitled/screens/vendor_info_display_screen.dart';
import 'package:untitled/services/vendor_registration.dart';
import 'package:untitled/utils/add_space.dart';

import '../manager/profile_manager.dart';
import '../manager/service_request_manager.dart';
import '../services/service_request_service.dart';

class ConfirmLocation extends StatefulWidget {
  bool isVendor;
  bool isCustomer;
  ConfirmLocation({Key? key, this.isVendor = false, this.isCustomer = false})
      : super(key: key);

  @override
  ConfirmLocationState createState() => ConfirmLocationState();
}

class ConfirmLocationState extends State<ConfirmLocation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final VendorManager vendorManager = Provider.of<VendorManager>(context);
    final ServiceRequestManager serviceRequestManager =
        Provider.of<ServiceRequestManager>(context);
    final LocationManager locationManager =
        Provider.of<LocationManager>(context);

    return Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(width: 2.0, color: Colors.grey)),
            color: Colors.white
        ),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on, color: Colors.purple),
                          addVerticalSpace(15),
                          Text(
                            locationManager.currentLocation,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontFamily: 'Roboto-Bold',
                                fontWeight: FontWeight.w300),
                          ),
                        ])
                  ],
                ),
              ],
            ),
            addVerticalSpace(20),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      //log("vendorRequest: ${jsonEncode(vendorManager.vendorDTO)}");
                      if (widget.isVendor) {
                        VendorRegistrationService()
                            .vendorRegistrationRequest(vendorManager.vendorDTO)
                            .then((response) {
                          var body = jsonDecode(response.body);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (BuildContext context) {
                            return VendorRegistrationInfoDisplay(id: body["id"]);
                            //return const RequestStatusDetails();
                          }));
                        }).catchError((error) {
                          log("ServerError: $error");
                        });
                      }
                      if (widget.isCustomer) {
                        serviceRequestManager.serviceRequestDTO.requestedCustomer =
                          Provider.of<ProfileManager>(context, listen: false).customerDTO.id;
                        log("it's customer");
                        BreakdownService()
                            .customerRequest(
                                serviceRequestManager.serviceRequestDTO)
                            .then((response) {
                          var json = jsonDecode(response.body);
                          serviceRequestManager.serviceRequestDTO =
                              ServiceRequestDTO.fromJson(json);
                          // need to implement preferred mechanic
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (BuildContext context) {
                            return const RequestStatusDetailsV1();
                          }));
                        }).catchError((error) {
                          log("ServerError: $error");
                        });
                      }
                    },
                    child: const Text(
                      "Confirm Location",
                      style: TextStyle(color: Colors.white, shadows: <Shadow>[
                        Shadow(
                            color: Colors.black12,
                            offset: Offset(5, 5),
                            blurRadius: 3)
                      ]),
                      textAlign: TextAlign.center,
                    )))
          ])
    );
  }
}
