import 'package:flutter/material.dart';
import 'package:untitled/screens/aboutus_screen.dart';

import '../utils/add_space.dart';

enum SingingCharacter { currentLocation }

class VendorRegistrationInfoDisplay extends StatelessWidget {
  final int id;

  const VendorRegistrationInfoDisplay({Key? key, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Center(
              child: Text(
            "Your request is submitted successfully\n"
            "Reqeust ID: $id\nOur Executive will contact\n you for further process\n\n\n"
            "Please reach out RunWheelz @ 9874655744",
            style: textTheme.headline5,
            textAlign: TextAlign.center,
          )), addVerticalSpace(100),
          ElevatedButton(
              onPressed: () {
                /*Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return const AboutUs();
                }))*/
              },
              child: const Text("About us"))
        ]));
  }
}
