import 'dart:convert';
import 'dart:developer';

import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import 'package:untitled/manager/login_manager.dart';

import '../components/positioned_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class FireBaseLoginScreen extends StatefulWidget {
  const FireBaseLoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<FireBaseLoginScreen> {
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
    return FirebasePhoneAuthHandler(
      phoneNumber: "+917013298534",
      // If true, the user is signed out before the onLoginSuccess callback is fired when the OTP is verified successfully.
      signOutOnSuccessfulVerification: false,

      linkWithExistingUser: false,
      builder: (context, controller) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child:OtpTextField(
          keyboardType: TextInputType.number,
          numberOfFields: 6,
          showFieldAsBox: false,
          fieldWidth: 35,
          borderColor: Colors.black,
          onCodeChanged: (String code) {
            //handle validation or checks here
          },
          onSubmit: (String verificationCode) async {
            final verified = await controller.verifyOtp(verificationCode);
            if (verified) {
              log("sucess");
            }else {
              log("failed");
            }
            })
        );
      },
        onCodeSent: () {
          log('test', name: 'OTP sent!');
        },
      onLoginSuccess: (userCredential, autoVerified) {
        debugPrint("autoVerified: $autoVerified");
        debugPrint("Login success UID: ${userCredential.user?.uid}");
      },
      onLoginFailed: (authException, stackTrace) {
        debugPrint("An error occurred: ${authException.message}");
        debugPrint("An error occurred: $FirebaseAuthException");
      },
      onError: (error, stackTrace) {},
    );
  }
}
