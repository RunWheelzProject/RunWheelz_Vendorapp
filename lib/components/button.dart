import 'package:flutter/material.dart';
import '../colors/app_colors.dart';


typedef callBackType = void Function();

class AppButton extends ElevatedButton{
  const AppButton({Key? key, required super.onPressed, required super.child}): super(key: key);

}
class Button extends StatelessWidget {
  Button({Key? key}): super(key: key);
  late double _height;
  late double _width;
  late double _fontSize;
  late ButtonStyle _style;
  late callBackType _callBack;

  Button.buttonData({
    double height = 50,
    double width = 200,
    double fontSize = 20,
    callBackType callback = func}) {
    _height = height;
    _width = width;
    _fontSize = fontSize;
    _callBack = callback;

    _style = ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: _fontSize),
        primary: AppColors().BG_color,
        onPrimary: AppColors().BG_color);
  }

  static void func() {}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: _height,
        width: _width,
        child: ElevatedButton(
          style: _style,
          onPressed: _callBack,
          child: const Text('New Services', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
        ));
  }
}
