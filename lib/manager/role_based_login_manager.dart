import 'package:flutter/material.dart';
import 'package:untitled/screens/customer_registration_screen.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/rw_mgmt_marketing_agent_screen.dart';
import 'package:untitled/screens/rw_staff_registration_screen.dart';
import 'package:untitled/screens/rw_vendor_registration_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/screens/vendor_mechanic_dashboard.dart';
import '../screens/customer_board.dart';
import '../screens/vendor_registration_screen_v1.dart';


import '../resources/resources.dart' as res;
import '../screens/vendor_staff_registration_screen.dart';

class RoleBasedLogIn<T> {
  int? status;
  int? roleType;
  String? url;
  bool? registrationStatus;
  T? navigateTo;

  RoleBasedLogIn({
    this.status,
    this.roleType,
    this.url,
    this.registrationStatus,
    this.navigateTo
  });

  Map toJson() => {
    "status": status,
    "roleType": roleType,
    "url": url,
    "registrationStatus": registrationStatus,
    "navigateTo": navigateTo
  };

  @override
  bool operator ==(other) {
    return (other is RoleBasedLogIn)
        && other.status == status
        && other.roleType == roleType
        && other.url == url
        && other.registrationStatus == registrationStatus;
  }

}

class RoleBasedLogInManager extends ChangeNotifier {
  static List<RoleBasedLogIn> roleBasedLoggedIn = [


    // customer_login
    RoleBasedLogIn(
        status: 201,
        roleType: 5,
        url: "${res.APP_URL}/api/customer/verifyotp",
        registrationStatus: true,
        navigateTo: CustomerDashBoard(isCustomer: true)
    ),


    // customer_registration
    RoleBasedLogIn(
        status: 201,
        roleType: 5,
        url: "${res.APP_URL}/api/customer/verifyotp",
        registrationStatus: false,
        navigateTo: const CustomerRegistration()
    ),



    // vendor_loggedIn
    RoleBasedLogIn(
        status: 201,
        roleType: 4,
        url: "${res.APP_URL}/api/auth/login/verifyotp",
        registrationStatus: true,
        navigateTo: const VendorDashBoard()
    ),


    // initial_request
    RoleBasedLogIn(
        status: 201,
        roleType: 0,
        url: "${res.APP_URL}/api/auth/login/verifyotp",
        registrationStatus: false,
        navigateTo: const VendorRegistrationV1()
    ),


    // vendor_registration
    RoleBasedLogIn(
        status: 201,
        roleType: 4,
        url: "${res.APP_URL}/api/auth/register/vendor/verifyotp",
        registrationStatus: false,
        navigateTo: const RWVendorRegistration()
    ),



    // runwheelz_staff_registration
    RoleBasedLogIn(
        status: 201,
        roleType: 6,
        url: "${res.APP_URL}/api/auth/register/runwheelz/staff/verifyotp",
        registrationStatus: false,
        navigateTo: const RWStaffRegistration()
    ),



    // mechanic_registration
    RoleBasedLogIn(
        status: 201,
        roleType: 7,
        url: "${res.APP_URL}/api/auth/register/mechanic/verifyotp",
        registrationStatus: false,
        navigateTo: const VendorStaffRegistration()
    ),


    // vendor_mechanic_loggedIn
    RoleBasedLogIn(
        status: 201,
        roleType: 7,
        url: "${res.APP_URL}/api/auth/login/verifyotp",
        registrationStatus: true,
        navigateTo: VendorMechanicDashBoard(requestId: '')
    ),



    // admin_login
    RoleBasedLogIn(
        status: 201,
        roleType: 1,
        url: "${res.APP_URL}/api/auth/login/verifyotp",
        registrationStatus: true,
        navigateTo: const RunWheelManagementPage()
    ),



    // marketing_agent_login
    RoleBasedLogIn(
        status: 201,
        roleType: 2,
        url: "${res.APP_URL}/api/auth/login/verifyotp",
        registrationStatus: true,
        navigateTo: const MarketingAgentPage()
    ),



    // executive_login
    RoleBasedLogIn(
        status: 201,
        roleType: 3,
        url: "${res.APP_URL}/api/auth/login/verifyotp",
        registrationStatus: true,
        navigateTo: const RunWheelManagementPage()
    ),
  ];

}



