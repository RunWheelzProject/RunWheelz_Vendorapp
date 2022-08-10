import 'package:flutter/material.dart';
import 'package:untitled/utils/add_space.dart';
import '../components/logo.dart';
import 'login_page_screen.dart';
import 'dart:async';
import '../resources/resources.dart' as res;

class SplashScreen extends StatelessWidget{
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   TextTheme textTheme = Theme.of(context).textTheme;
    Uri userLoginURL = Uri.parse("${res.APP_URL}/api/auth/login/sendotp?phoneNumber=91");

    Timer(
        const Duration(seconds: 3), () async => {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen(uri: userLoginURL))
              )
        }
    );

    return   Scaffold(
        body:  Container(
          //color: Colors.purpleAccent,
          padding: const EdgeInsets.only(top: 100),
          child: Column(
              children: [
                Logo(),
                addVerticalSpace(100),
                const Center(
                  child: Image(image: AssetImage("images/logo_1.png")),
                  //color: Colors.purpleAccent,
                ),
              ]))
    );
  }
}

