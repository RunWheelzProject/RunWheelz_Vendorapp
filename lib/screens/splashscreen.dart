import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/manager/login_manager.dart';
import 'package:untitled/services/phone_verification.dart';
import 'package:untitled/utils/add_space.dart';
import '../components/logo.dart';
import 'login_page_screen.dart';
import 'dart:async';
import '../resources/resources.dart' as res;

class SplashScreen extends StatelessWidget{
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LogInManager logInManager = Provider.of<LogInManager>(context);
    logInManager.setCurrentURLs("userLogIn");

   TextTheme textTheme = Theme.of(context).textTheme;

    Timer(
        const Duration(seconds: 3), () async => {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const LoginScreen())
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

