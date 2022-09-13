import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Column(children: [
      Text("Run Wheelz",
          textAlign: TextAlign.center, style: textTheme.headline2),
      const Text(
        "Vendor App",
        style: TextStyle(color: Colors.purple, fontSize: 24),
      )
    ]);
  }
}
