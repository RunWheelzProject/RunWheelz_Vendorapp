import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/manager/profile_manager.dart';
import 'package:untitled/manager/service_request_manager.dart';
import 'package:untitled/manager/staff_manager.dart';
import 'package:untitled/model/staff.dart';
import 'package:untitled/screens/customer_board.dart';
import 'package:untitled/screens/customer_reqeust_history.dart';
import 'package:untitled/screens/login_page_screen.dart';
import 'package:untitled/screens/profile.dart';
import 'package:untitled/screens/request_status_screen.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/screens/vendor_inprogrees_screen.dart';
import 'package:untitled/screens/vendor_mechanic_dashboard.dart';
import 'package:untitled/screens/vendor_pending_screen.dart';
import 'package:untitled/screens/vendor_request_accept_screen.dart';
import '../manager/login_manager.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../model/servie_request.dart';

// dummy

class NewRequests {
  String requestID;
  String serviceType;
  NewRequests({required this.requestID, required this.serviceType});
}

class VendorDataManagementPage extends StatelessWidget {
  final String pageTitle;
  bool isCustomer;
  bool isVendor;
  bool isMechanic;
  bool isCustomerNotification;
  bool isVendorNotification;
  List<ServiceRequestDTO>? serviceRequestList;
  VendorDataManagementPage({Key? key,
    required this.pageTitle,
    this.serviceRequestList,
    this.isCustomer = false,
    this.isVendor = false,
    this.isMechanic= false,
    this.isCustomerNotification = false,
    this.isVendorNotification = false
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    List<ServiceRequestDTO> serviceRequestDTOList = serviceRequestList ?? [];
    ProfileManager profileManager = Provider.of<ProfileManager>(context, listen: false);
 /*   LogInManager logInManager = Provider.of<LogInManager>(context, listen: false);
    StaffManager staffManager = Provider.of<StaffManager>(context);
    logInManager.setCurrentURLs("staffRegistration");*/

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () => {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  if (isCustomer) return CustomerDashBoard(isCustomer: true);
                  if(isVendor) return const VendorDashBoard();
                  return VendorMechanicDashBoard(requestId: '');
                })
            )
          },
          child: const Icon(Icons.arrow_back),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: isVendor ? const Text("Vendor Dashboard") : const Text("Customer DashBoard"),
        ),
        body: SafeArea(
            child: SizedBox(
                width: double.infinity,
                child: Column(children: [
                  const SizedBox(height: 40,),

                  const SizedBox(height: 20,),

                  const SizedBox(height: 20,),
                  Text(pageTitle, style: const TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: SearchableList<ServiceRequestDTO>(
                          initialList: serviceRequestDTOList,
                          builder: (ServiceRequestDTO serviceRequest) => Item(serviceRequestDTO: serviceRequest,),
                          filter: (value) => serviceRequestDTOList.where((element) =>
                              element.id?.toString().contains(value) as bool
                          )
                              .toList(),
                          onItemSelected: (ServiceRequestDTO item) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (BuildContext context) {
                                    if (isVendorNotification) {
                                      return  VendorRequestAcceptScreen(serviceRequestDTO: item,);
                                    } else if (isCustomerNotification) {
                                      ServiceRequestManager serviceRequestManager = Provider.of<ServiceRequestManager>(context, listen: false);
                                      serviceRequestManager.serviceRequestDTO = item;
                                      return const RequestStatusDetailsV1();
                                    } else {
                                      return VendorInprogressScreen(
                                          serviceRequestDTO: item,
                                          pageTitle: pageTitle,
                                          isVendor: isVendor,
                                          isCustomer: isCustomer,
                                          isMechanic: isMechanic
                                      );
                                    }
                                  })
                              );
                            },
                          inputDecoration: InputDecoration(
                            labelText: "Search $pageTitle",
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
                      ))
                ]
                )
            )
        )
    );
  }
}

class Item extends StatelessWidget {
  ServiceRequestDTO? serviceRequestDTO;
  Item({Key? key, this.serviceRequestDTO}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          /*boxShadow: const <BoxShadow>[
             BoxShadow(color: Colors.black45,
                 blurRadius: 10,
                 offset: Offset(5, 5)),
             BoxShadow(color: Colors.black45,
                 blurRadius: 10,
                 offset: Offset(10, 10))
           ]*/
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
                  children: [
                    Text("Service: "),
                    SizedBox(width: 10,),
                    Text(serviceRequestDTO?.serviceType ?? "")
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Text("Request ID: "),
                    SizedBox(width: 10,),
                    Text(serviceRequestDTO?.id.toString() ?? "0000")
                  ],
                )
          ],
        ));
  }
}