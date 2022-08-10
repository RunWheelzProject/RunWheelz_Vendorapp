import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../resources/resources.dart' as res;


class HeaderText extends StatelessWidget {
  late String _text;

  HeaderText(String text, {Key? key}): super(key: key) {
    _text = text;
  }


  static void func() {}

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(_text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 25,
                fontFamily: res.fontStyle,
                color: Colors.white,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 8.0,
                    color: Color.fromARGB(125, 0, 0, 255),
                  ),
                ])));
  }
}