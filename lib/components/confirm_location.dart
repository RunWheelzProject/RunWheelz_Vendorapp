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
import 'package:untitled/services/preferred_mechanic_service.dart';
import 'package:untitled/services/vendor_registration.dart';
import 'package:untitled/utils/add_space.dart';

import '../manager/profile_manager.dart';
import '../manager/service_request_manager.dart';
import '../services/service_request_service.dart';

class ConfirmLocation extends StatefulWidget {
  bool isVendor;
  bool isCustomer;
  bool isGeneral;
  bool isVendorInitialRequest;
  ConfirmLocation({
      Key? key,
      this.isVendor = false,
      this.isCustomer = false,
      this.isGeneral = false,
      this.isVendorInitialRequest = false,
  }) : super(key: key);

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
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: Colors.white),
        child: Column(children: [
          Row(children: [
            const Icon(Icons.location_on, color: Colors.purple),
            addVerticalSpace(25),
            Text(
              locationManager.currentLocation,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontFamily: 'Roboto-Bold',
              ),
            ),
          ]),
          const SizedBox(
            height: 20,
          ),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    if (widget.isVendorInitialRequest) {
                      log(jsonEncode(vendorManager.vendorDTO));
                      VendorRegistrationService().vendorRegistrationRequest(vendorManager.vendorDTO)
                          .then((response) {
                        var body = jsonDecode(response.body);
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return VendorRegistrationInfoDisplay(id: body["id"] ?? 0);
                          //return const RequestStatusDetails();
                        }));
                      }).catchError((error) {
                        log("ServerError: $error");
                      });
                    }
                    else if (widget.isCustomer & widget.isGeneral != true) {
                      serviceRequestManager.serviceRequestDTO.requestedCustomer = Provider.of<ProfileManager>(context, listen: false)
                              .customerDTO
                              .id;
                      serviceRequestManager.serviceRequestDTO.id = null;
                      log("it's customer");
                      BreakdownService()
                          .customerRequest(
                              serviceRequestManager.serviceRequestDTO)
                          .then((response) {
                        var json = jsonDecode(response.body);
                        serviceRequestManager.serviceRequestDTO =
                            ServiceRequestDTO.fromJson(json);
                        log(jsonEncode(serviceRequestManager.serviceRequestDTO));
                        // need to implement preferred mechanic
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const RequestStatusDetailsV1();
                        }));
                      }).catchError((error) {
                        log("ServerError: $error");
                      });
                    }
                    else if (widget.isGeneral) {
                      serviceRequestManager.serviceRequestDTO.id = null;
                      PreferredMechanicService().sendNotification(serviceRequestManager.serviceRequestDTO).then((request) {
                        serviceRequestManager.serviceRequestDTO = request;
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (BuildContext context) {
                                return const RequestStatusDetailsV1();
                              }));
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
        ]));
  }
}
