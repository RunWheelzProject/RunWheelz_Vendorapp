import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/components/customer_appbar.dart';
import 'package:untitled/manager/service_request_manager.dart';
import 'package:untitled/model/offer_dto.dart';
import 'package:untitled/utils/add_space.dart';
import '../manager/profile_manager.dart';
import 'current_offers.dart';
import 'google_map_location_screen.dart';

import 'package:http/http.dart' as http;
import '../resources/resources.dart' as res;
import 'package:upi_india/upi_india.dart';


class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {

  final UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;


  Future<UpiResponse> initiateTransaction(UpiApp app, double amount) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: "8985654602@ybl",
      receiverName: 'Padala Vasantha',
      transactionRefId: 'RunWheelz Services',
      transactionNote: 'Thank you for purchasing the offer',
      amount: amount,
    );
  }

  @override
  void initState() {
    super.initState();
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });

  }

  @override
  Widget build(BuildContext context) {
    return CustomerAppBar(
        child: _mainContainer()
    );
  }


  Widget _mainContainer() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final topMargin = screenHeight * 0.04;


    log("media height: $screenHeight");
    return Column(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Wrap(
              children: apps!.map<Widget>((UpiApp app) {
                return GestureDetector(
                  child: Container(
                    child: Column(
                      children: [
                        Image.memory(app.icon, height: 70, width: 70),
                        Text(app.name)
                      ],
                    ),
                  ),
                );
              }).toList()
            ),
          )
        ]
    );
  }


}

typedef OnClick = void Function();
typedef DropDownOnChanged = void Function(String?)?;
typedef FunctionSaved = void Function(String?)?;
typedef FunctionChanged = void Function(bool?)?;
typedef FunctionPressed = void Function()?;

class RWDropDown extends StatelessWidget {
  final String value;
  final DropDownOnChanged onChanged;
  final List<String>? items;

  RWDropDown(
      {required this.value, required this.onChanged, required this.items});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(contentPadding: EdgeInsets.all(10)),
      value: value,
      icon: const Icon(
        Icons.expand_circle_down,
        color: Colors.deepPurple,
      ),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: onChanged,
      items: items?.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
    );
  }
}

class RWTextFormField extends StatelessWidget {
  final String label;
  final Icon icon;
  final FunctionSaved onSaved;
  final String? helperText;
  final int? maxLength;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? textInputFormatters;
  final TextEditingController? textEditingController;

  const RWTextFormField({
    required this.label,
    required this.icon,
    required this.onSaved,
    this.helperText,
    this.maxLength,
    this.textInputType,
    this.textInputFormatters,
    this.textEditingController
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onSaved,
      keyboardType: textInputType,
      inputFormatters: textInputFormatters,
      controller: textEditingController,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: icon,
        labelStyle: const TextStyle(color: Colors.black38),
        helperStyle: const TextStyle(color: Colors.red, fontSize: 14),
        /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.purple,
              width: 0,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.purple,
              width: 0,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.purple,
              width: 0,
            )),*/
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'this field required';
        }
        return null;
      },
    );
  }
}
