import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled/manager/login_manager.dart';
import 'package:untitled/model/otp_response.dart';

import '../components/logo.dart';
import '../components/positioned_view.dart';
import '../services/phone_verification.dart';
import 'otp_screen.dart';
import '../resources/resources.dart' as res;
import 'package:http/http.dart' as http;

import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool readToProceed = false;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();

  Future<String?> getFireBaseToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }



  @override
  void initState() {

    super.initState();
    countryCodeController = TextEditingController(text: '+91');
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return PositionedView(
      positionChildWidget: loginView(),
      top: 370,
      isSlider: true,
    );
  }

  Widget loginView() {
    LogInManager logInManager = Provider.of<LogInManager>(context);
    return Container(
        height: 300,
        //padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
        ),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: Column(children: <Widget>[
              const Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 21, color: Colors.black87),
                  text: 'Enter Mobile Number',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                    height: 60,
                    width: 260,
                    child: TextField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Mobile Number',
                          prefixIcon:
                              Icon(Icons.phone_android, color: Colors.purple)),
                      onChanged: (value) {
                        if (value.length < 10) {
                          setState(() => readToProceed = false);
                        }
                        if (value.length == 10) {
                          setState(() => readToProceed = true);
                        }
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      maxLength: 10,
                    ))
              ]),
              const SizedBox(height: 30),
              SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: readToProceed
                          ? () async {
                              if ((phoneNumberController.text.isNotEmpty) &&
                                  (phoneNumberController.text.length == 10)) {
                                log("logInManager.selectURL: ${logInManager.currentURLs![0]}");
                                getFireBaseToken().then((String? str) {
                                  log("deviceToken: $str");
                                  PhoneVerificationService()
                                      .sendOtp(
                                          int.parse(phoneNumberController.text),
                                          str,
                                          logInManager.currentURLs![0])
                                      .then((vendorOtpResponse) {
                                    log("test");
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return OtpScreen(
                                          vendorOtpResponse: vendorOtpResponse);
                                    }));
                                  }).catchError((onError) {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                                title:
                                                    const Text("OTPException"),
                                                content: Text(
                                                    onError.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black87)),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'OK'),
                                                    child: const Text('OK'),
                                                  ),
                                                ]));
                                  });
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text('Invalid phone number'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          : null,
                      child: const Text("Proceed")))
            ])
        )
    );
  }
}
