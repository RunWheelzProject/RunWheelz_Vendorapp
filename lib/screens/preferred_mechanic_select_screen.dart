import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/preferred_mechanics.dart';
import 'package:untitled/utils/add_space.dart';
import '../components/customer_appbar.dart';
import '../manager/preferred_mechanic_manager.dart';
import '../manager/service_request_manager.dart';
import '../model/preferred_mechanic_dto.dart';
import 'google_map_location_screen.dart';

typedef CallBack = void Function();

class PreferredMechanicSelectScreen extends StatefulWidget {
  const PreferredMechanicSelectScreen({Key? key}) : super(key: key);

  @override
  GeneralServicesState createState() => GeneralServicesState();
}

class GeneralServicesState extends State<PreferredMechanicSelectScreen> {
  List<String> dropDownList = [];
  String _dropDownSelectedItem = "Select preferred mechanic";

  @override
  void initState() {
    super.initState();
    PreferredMechanicManager preferredMechanicManager = Provider.of<PreferredMechanicManager>(context, listen: false);

    for (PreferredMechanicDTO mechanic in preferredMechanicManager.preferredMechanicList) {
      dropDownList.add(mechanic.vendor?.ownerName ?? "");
    }

    dropDownList = ["Select preferred mechanic", ...dropDownList];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomerAppBar(child: _mainContainer());
  }

  Widget _mainContainer() {
    ServiceRequestManager serviceRequestManager = Provider.of<ServiceRequestManager>(context);
    return SafeArea(
        child: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.only(top: 100, left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white,
                ),
                child: Column(children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        color: Colors.purple,
                        border: Border(bottom: BorderSide())),
                    child: const Text(
                      "Preferred Mechanic",
                      style: TextStyle(fontSize: 21, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        addVerticalSpace(50),
                        RWDropDown(
                            value: _dropDownSelectedItem,
                            onChanged: (String? val) {
                              setState(() {
                                _dropDownSelectedItem = val!;
                              });

                              PreferredMechanicManager preferredMechanicManager = Provider.of<PreferredMechanicManager>(context, listen: false);
                            for (PreferredMechanicDTO mechanic in preferredMechanicManager.preferredMechanicList) {
                              if (mechanic.vendor?.ownerName == val) {
                                preferredMechanicManager.selectedPreferredMechanicDTO = mechanic;
                              }
                            }



                            log(jsonEncode(preferredMechanicManager.selectedPreferredMechanicDTO));
                        },
                            items: dropDownList,
                        ),
                        addVerticalSpace(70),
                        ElevatedButton(
                            onPressed: () => {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                                return GoogleMapLocationPickerV1(isCustomer: true);
                              }))
                              /*Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                                return GoogleMapLocationPickerV1(isCustomer: true);
                              }))*/
                            },
                            child: const Text("Proceed"))
                      ],
                    ),
                  )
                ])
            )
        )
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

  const RWTextFormField(
      {required this.label,
        required this.icon,
        required this.onSaved,
        this.helperText,
        this.maxLength,
        this.textInputType,
        this.textInputFormatters});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      keyboardType: textInputType,
      inputFormatters: textInputFormatters,
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
