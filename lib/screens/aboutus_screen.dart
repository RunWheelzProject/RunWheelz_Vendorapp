import 'package:flutter/gestures.dart';
import 'dart:core';
import 'package:flutter/material.dart';
import '../model/otp_response.dart';
import '../components/positioned_view.dart';


class AboutUs extends StatefulWidget {
  const AboutUs({Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AboutUs();
}

class _AboutUs extends State<AboutUs> {

  @override
  Widget build(BuildContext context) {
    return PositionedView(positionChildWidget: otpScreenView(), childWidget: const Text("RunWheelz",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 46,
            fontWeight: FontWeight.bold,
            fontFamily: 'Abhaya Libre Medium',
            color: Color(0xffeec616)
        )));
  }

  Widget otpScreenView() {
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
        child: Center(
            child: RichText(
              text: const TextSpan(
                  text: 'About us\n\n',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(text: 'Our Mission:\n',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                    ),
                    TextSpan(
                        text: 'History:\n',
                        style: TextStyle(color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline)
                    ),
                    TextSpan(
                        text: 'Services:\n',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                    ),
                  ]
              ),
            )
        ));
  }
}
