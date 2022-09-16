import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:profile/profile.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/manager/manager.dart';
import 'package:untitled/manager/profile_manager.dart';
import 'package:untitled/manager/staff_manager.dart';
import 'package:untitled/manager/vendor_mechanic_manager.dart';
import 'package:untitled/model/staff.dart';
import 'package:untitled/model/vendor.dart';
import 'package:untitled/model/vendor_mechanic.dart';
import 'package:untitled/screens/customer_board.dart';
import 'dart:core';
import 'dart:developer';

import 'package:untitled/screens/login_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/rw_mgmt_marketing_agent_screen.dart';
import 'package:untitled/screens/rw_staff_registration_screen.dart';
import 'package:untitled/screens/rw_vendor_registration_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/screens/vendor_mechanic_dashboard.dart';
import 'package:untitled/screens/vendor_registration_screen.dart';
import 'package:untitled/screens/vendor_registration_screen_v1.dart';

import '../components/future_manager.dart';
import '../components/logo.dart';
import '../manager/login_manager.dart';
import '../manager/roles_manager.dart';
import '../manager/vendor_manager.dart';
import '../model/customer.dart';
import '../model/otp_response.dart';
import '../model/phone_verification.dart';
import '../services/phone_verification.dart';
import '../components/positioned_view.dart';
import '../utils/add_space.dart';
import '../resources/resources.dart' as res;

class OtpScreen extends StatefulWidget {
  final VendorOtpResponse vendorOtpResponse;
  const OtpScreen({Key? key, required this.vendorOtpResponse})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _OTPState();
}

class _OTPState extends State<OtpScreen> {
  String _currentVerificationCode = '';
  Color _disabledVerifyTextColor = Colors.white;
  bool _isVerifyDisabled = false;
  String _msgValue = "";
  TextStyle _msgStyle = const TextStyle(color: Colors.black);
  bool isResendOTP = false;
  String _resendPhoneVerificationRef = '';

  void moveToLogInScreen(String urlType) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return const LoginScreen();
    }));
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
  void initState() {
    VendorManager vendorManager =
        Provider.of<VendorManager>(context, listen: false);
    _determinePosition().then((position) {
      log("position: ${position.longitude}, ${position.latitude}");
      vendorManager.vendorDTO.latitude = position.latitude;
      vendorManager.vendorDTO.longitude = position.longitude;
    }).catchError((error) => log("Error: $error"));
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return PositionedView(
        positionChildWidget: otpScreenView(), childWidget: Logo(), top: 200);
  }

  Widget otpScreenView() {
    TextTheme textTheme = Theme.of(context).textTheme;
    LogInManager logInManager = Provider.of<LogInManager>(context);
    VendorManager vendorManager = Provider.of<VendorManager>(context);
    StaffManager staffManager = Provider.of<StaffManager>(context);
    VendorMechanicManager vendorMechanicManager =
        Provider.of<VendorMechanicManager>(context);

    return Container(
        height: 400,
        padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, spreadRadius: 10, blurRadius: 30),
            ]),
        child: Column(children: <Widget>[
          Center(
              child: Text(
            "OTP Verification",
            style: textTheme.headline4,
          )),
          addVerticalSpace(30),
          Center(
              child: Text(
            "we have sent an OTP to",
            style: textTheme.subtitle1,
          )),
          addVerticalSpace(10),
          Center(
              child: Text(
            "+ ${widget.vendorOtpResponse.phoneNumber}",
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )),
          addVerticalSpace(40),
          OtpTextField(
            keyboardType: TextInputType.number,
            numberOfFields: 6,
            showFieldAsBox: false,
            fieldWidth: 35,
            borderColor: Colors.black,
            onCodeChanged: (String code) {
              //handle validation or checks here
            },
            onSubmit: (String verificationCode) {
              _currentVerificationCode = verificationCode;
              setState(() {
                _isVerifyDisabled = true;
                _disabledVerifyTextColor = Colors.white;
              });
            }, // end onSubmit
          ),
          addVerticalSpace(30),
          Text(
            _msgValue,
            style: _msgStyle,
            overflow: TextOverflow.ellipsis,
          ),
          addVerticalSpace(30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                                title: const Text("PhoneNumber"),
                                content: const Text(
                                    'Do you want to use different phone number to receive OTP?',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black87)),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      //Navigator.of(context).pop();
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return const LoginScreen();
                                      }));
                                    },
                                    child: const Text('YES'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'NO');
                                      String phoneNumber = widget
                                          .vendorOtpResponse.phoneNumber
                                          .substring(2);
                                      log("logInManager.selectURL: ${logInManager.currentURLs![0]}");
                                      PhoneVerificationService()
                                          .sendOtp(int.parse(phoneNumber), "",
                                              logInManager.currentURLs![0])
                                          .then((vendorOtpResponse) {
                                        setState(() => {isResendOTP = true});
                                        setState(() {
                                          _resendPhoneVerificationRef =
                                              vendorOtpResponse.verificationRef;
                                          log("_resendPhoneVerificationRef: $_resendPhoneVerificationRef");
                                        });
                                      });
                                    },
                                    child: const Text('NO'),
                                  ),
                                ]));
                    setState(() {
                      _msgValue =
                          "we have sent an OTP to ${widget.vendorOtpResponse.phoneNumber}";
                      _msgStyle = const TextStyle(color: Colors.blue);
                    });
                  },
                  child: const Text(
                    "Resend OTP",
                  )),
              ElevatedButton(
                  onPressed: () => verifyOtp(),
                  child: const Text(
                    "Verify OTP",
                  ))
            ],
          )
        ]));
  }

  void verifyOtp() {
    LogInManager logInManager =
        Provider.of<LogInManager>(context, listen: false);
    VendorManager vendorManager =
        Provider.of<VendorManager>(context, listen: false);
    StaffManager staffManager =
        Provider.of<StaffManager>(context, listen: false);
    ProfileManager profileManager =
        Provider.of<ProfileManager>(context, listen: false);
    VendorMechanicManager vendorMechanicManager =
        Provider.of<VendorMechanicManager>(context, listen: false);

    if (!_isVerifyDisabled) {
      return;
    } else {
      log("verificationCode: $_currentVerificationCode");
      String phoneVerification = jsonEncode(PhoneVerification(
          phoneNumber: widget.vendorOtpResponse.phoneNumber,
          verificationRef: isResendOTP
              ? _resendPhoneVerificationRef
              : widget.vendorOtpResponse.verificationRef,
          otp: _currentVerificationCode));
      log("isResendOTP: $isResendOTP");
      log("phoneVerification: $phoneVerification");
      PhoneVerificationService().verifyOtp(phoneVerification, logInManager.currentURLs![1]).then((http.Response response) {
        var responseJson = jsonDecode(response.body);
        if (responseJson["role"] != null) {
          var role = responseJson["role"];

          if (role["roleName"] == "CUSTOMER") {

            profileManager.customerDTO = CustomerDTO.fromJson(responseJson);
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                  log("role1: ${jsonEncode(role)}");
                  return CustomerDashBoard(isCustomer: true);
                }));
          }
        } else {
          if (response.statusCode == 201 && responseJson["id"] != null) {
            vendorManager.vendorDTO.phoneNumber =
            responseJson["phoneNumber"];
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const VendorRegistrationV1();
                }));
          }
          if (response.statusCode == 201 && responseJson["vendorDTO"] != null) {
            profileManager.vendorDTO =
                VendorDTO.fromJson(responseJson["vendorDTO"]);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return const VendorDashBoard();
                }));
          }
          if (response.statusCode == 201 &&
              responseJson["vendorStaffDTO"] != null) {
            profileManager.vendorMechanic =
                VendorMechanic.fromJson(responseJson["vendorStaffDTO"]);

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return VendorMechanicDashBoard(
                    requestId: "",
                  );
                }));
          }
          if (response.statusCode == 201 &&
              responseJson["runwheelzStaffDTO"] != null) {
            profileManager.staffDTO =
                StaffDTO.fromJson(responseJson["runwheelzStaffDTO"]);
            if (profileManager.staffDTO.role?.roleName == "MARKETING_AGENT") {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    log("marketing_agent");
                    return const MarketingAgentPage();
                  }));
            } else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return const RunWheelManagementPage();
                  })
              );
            }
          }
          if (response.statusCode == 201 &&
              logInManager.currentURLs![1].contains("vendor")) {
            var jsonResponse = jsonDecode(response.body);
            vendorManager.vendorDTO =
                VendorDTO.fromJson(jsonResponse);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return MultiProvider(providers: [
                    ChangeNotifierProvider<RoleManager>(
                        create: (context) => RoleManager()),
                  ], child: const RWVendorRegistration());
                }));
          }
          /*if (response.statusCode == 201 &&
            logInManager.currentURLs![1].contains("mechanic")) {

          var jsonResponse = jsonDecode(response.body);
          log("JsonResponse: $jsonResponse");
          vendorMechanicManager.vendorMechanic = VendorMechanic.fromJson(jsonResponse);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
                return MultiProvider(providers: [
                  ChangeNotifierProvider<RoleManager>(
                      create: (context) => RoleManager()),
                ], child: const RWStaffRegistration());
              }));

          // RWStaffRegistration
        }*/
          if (response.statusCode == 201 &&
              logInManager.currentURLs![1].contains("staff")) {
            var jsonResponse = jsonDecode(response.body);
            log("JsonResponse: $jsonResponse");
            staffManager.staffDTO = StaffDTO.fromJson(jsonResponse);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return MultiProvider(providers: [
                    ChangeNotifierProvider<RoleManager>(
                        create: (context) => RoleManager()),
                  ], child: const RWStaffRegistration());
                }));

            // RWStaffRegistration
          }
          var messageMap = responseJson as Map;
          if (messageMap.containsKey("message")) {
            log("ServerError: ${messageMap["message"]}");
            setState(() {
              _msgValue = messageMap["message"];
              _msgStyle = const TextStyle(color: Colors.red);
            });
          }
        }
      }).catchError((error) {
        log("ServerError: $error");
        setState(() {
          _msgValue = error.toString();
          _msgStyle = const TextStyle(color: Colors.red);
        });

      });
    }
  }
}
