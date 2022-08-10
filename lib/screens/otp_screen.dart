import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/manager/manager.dart';
import 'dart:core';
import 'dart:developer';

import 'package:untitled/screens/login_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:untitled/screens/vendor_registration_screen.dart';
import 'package:untitled/screens/vendor_registration_screen_v1.dart';

import '../components/future_manager.dart';
import '../components/logo.dart';
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
  String  _resendPhoneVerificationRef = '';

  void moveToLogInScreen() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return const LoginScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return PositionedView(positionChildWidget: otpScreenView(),
        childWidget: Logo(),
        top: 200
    );
  }

  Widget otpScreenView() {

    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
        height: 400,
        padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, spreadRadius: 10, blurRadius: 30),
            ]),
        child: Column(
            children: <Widget>[
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
            overflow: TextOverflow.visible,
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
                                      String phoneNumber = widget.vendorOtpResponse.phoneNumber.substring(2);
                                      PhoneVerificationService().sendOtp(int.parse(phoneNumber))
                                      .then((vendorOtpResponse) {
                                        setState(() => {isResendOTP = true });
                                        setState(() {
                                         _resendPhoneVerificationRef = vendorOtpResponse.verificationRef;
                                          log("_resendPhoneVerificationRef: $_resendPhoneVerificationRef");
                                        });
                                      });
                                    },
                                    child: const Text('NO'),
                                  ),
                                ]));
                      setState(() {
                        _msgValue = "we have sent an OTP to ${widget.vendorOtpResponse.phoneNumber}";
                        _msgStyle = const TextStyle(color: Colors.blue);
                      });
                  },
                  child: const Text(
                    "Resend OTP",
                  )),
              ElevatedButton(
                  onPressed: () {
                    if (!_isVerifyDisabled) {
                      return;
                    } else {
                      log("verificationCode: $_currentVerificationCode");
                      String phoneVerification = jsonEncode(PhoneVerification(
                          phoneNumber: widget.vendorOtpResponse.phoneNumber,
                          verificationRef: isResendOTP? _resendPhoneVerificationRef : widget.vendorOtpResponse.verificationRef,
                          otp: _currentVerificationCode));
                      log("isResendOTP: $isResendOTP");
                      log("phoneVerification: $phoneVerification");

                      Uri uri = Uri.parse("${res.APP_URL}api/auth/login/verifyotp");
                      PhoneVerificationService().verifyOtp(phoneVerification, uri)
                      .then((http.Response response) {
                          var responseJson = json.decode(response.body);
                          log("responseJson: $responseJson");
                          if (response.statusCode == 404) {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                              return const VendorRegistrationV1();
                            }));
                          }
                          var messageMap = responseJson as Map;
                          if (messageMap.containsKey("message")) {
                            log("ServerError: ${messageMap["message"]}");
                          }
                        }).catchError((error) {
                            log("ServerError: $error");
                            setState(() {
                            _msgValue = error.toString();
                            _msgStyle = const TextStyle(color: Colors.red);
                            });
                          });

                        /*if (response.statusCode == 404) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                            return const VendorRegistration();
                          }));
                        }
                        var responseJson = jsonDecode(response.body) as Map;
                        log("responseJson: $responseJson");
                        if (responseJson.containsKey("message")) {
                          setState(() {
                            String str = responseJson["message"];
                            _msgValue = str;
                            _msgStyle = const TextStyle(color: Colors.red);
                            log("str: $_msgValue");
                          });
                        }
                      })*/
                    }
                  },
                  child: const Text(
                    "Verify OTP",
                  ))
            ],
          )
        ]));
  }
}
