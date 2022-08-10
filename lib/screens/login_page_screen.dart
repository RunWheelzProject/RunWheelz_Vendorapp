import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/model/otp_response.dart';

import '../components/logo.dart';
import '../components/positioned_view.dart';
import '../services/phone_verification.dart';
import 'otp_screen.dart';
import '../resources/resources.dart' as res;


class LoginScreen extends StatefulWidget {
  final Uri uri;
  const LoginScreen({Key? key, required this.uri}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool readToProceed = false;
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
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
    return Container(
        height: 300,
        //padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, spreadRadius: 10, blurRadius: 30),
            ]),
        child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: Column(
            children: <Widget>[
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
            /*const SizedBox(
                height: 38,
                child: Text("+91",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(
              width: 10,
            )*/
            SizedBox(
                height: 60,
                width: 260,
                child: TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mobile Number',
                    prefixIcon: Icon(Icons.phone_android, color: Colors.purple)

                  ),
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
              onPressed: readToProceed ? () async {
                if ((phoneNumberController.text.isNotEmpty) && (phoneNumberController.text.length == 10)) {
                  PhoneVerificationService().sendOtp(int.parse(phoneNumberController.text), widget.uri)
                      .then((response) {
                          if (response.statusCode == 200) {
                            var responseJson = jsonDecode(response.body);
                            log("responseJsonVal: $responseJson");
                            VendorOtpResponse $vendor = VendorOtpResponse(phoneNumber: responseJson["phoneNumber"],
                                verificationRef: responseJson["verificationRef"], statusMessage: responseJson["statusMessage"]);
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (BuildContext context) {
                                  return OtpScreen(vendorOtpResponse: $vendor);
                                })
                            );
                          }
                        }).catchError((onError) {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text("OTPException"),
                                content: Text(onError.toString(),
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black87)),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ]));
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
              } : null,
              child: const Text("Proceed")))
        ])));
  }
}
