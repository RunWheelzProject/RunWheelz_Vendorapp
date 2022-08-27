import 'dart:developer';
import 'package:flutter/material.dart';


/*
* OTPEntryBox
*
* KeyBoardType always "numeric"
*
* */


enum FieldStyle {
  underLineStyle,
  boxStyle
}


class OTPEntryBox extends StatelessWidget {
  int numOfFields;
  double height;
  double fieldWidth;
  double borderRadius;
  MainAxisAlignment mainAxisAlignment;
  TextStyle? textStyle;
  EdgeInsets textPadding;
  InputDecoration? otpFieldStyle;
  FieldStyle fieldStyle;
  ValueChanged<String>? onFieldTextChanged;
  ValueChanged<String>? onCompleted;
  bool obscureText;


  final FocusNode _focus = FocusNode();
  late String _completedOTP = "";

  OTPEntryBox({Key? key,
    this.numOfFields = 4,
    this.fieldWidth = 40,
    this.height = 40,
    this.borderRadius = 10,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.obscureText = false,
    this.textStyle,
    this.textPadding = const EdgeInsets.all(4),
    this.otpFieldStyle,
    this.fieldStyle = FieldStyle.underLineStyle,
    this.onFieldTextChanged,
    this.onCompleted
  }) : super(key: key)
  {
    textStyle = const TextStyle(color: Colors.black12, fontSize: 24);
    final InputDecoration inputDecorationBox = InputDecoration(
        counterText: "",
        contentPadding: textPadding,
        border: OutlineInputBorder(
            borderSide: const BorderSide(width: 3.0, color: Colors.black12),
            borderRadius: BorderRadius.circular(borderRadius)
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 3.0, color: Colors.black12),
            borderRadius: BorderRadius.circular(borderRadius)
        )
    );

    final InputDecoration inputDecorationUnderLine = InputDecoration(
        counterText: "",
        contentPadding: textPadding,
        fillColor: Colors.white,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black12, width: 3.0)
        ),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12, width: 3.0)
        )
    );

    InputDecoration boxStyle = fieldStyle ==  FieldStyle.boxStyle ? inputDecorationBox : inputDecorationUnderLine;
    otpFieldStyle = otpFieldStyle ?? boxStyle;

  }

  List<Widget> textField() {
    final int numOfFields = this.numOfFields;
    List<Row> textFields = [];
    List<FocusNode> focusNodes = List.generate(this.numOfFields, (index) => FocusNode());

    for (int i = 0; i < numOfFields; i++) {
      textFields.add(
          Row(
            children: [
              SizedBox(
                height: height,
                width: fieldWidth,
                child: TextField(
                  obscureText: obscureText,
                  style: textStyle,
                  decoration: otpFieldStyle,
                  maxLength: 1,
                  focusNode: focusNodes[i],
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    onFieldTextChanged!(val);
                    if (i <= numOfFields -2) {
                      focusNodes[i+1].requestFocus();
                    }
                    _completedOTP += val;
                    if (_completedOTP.length == numOfFields) {
                      focusNodes[numOfFields - 1].unfocus();
                      onCompleted!(_completedOTP);
                    }
                  },
                ),
              ),
            ],
          )
      );
    }
    return textFields;
  }


  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: mainAxisAlignment,
        children: textField()
    );
  }

}
