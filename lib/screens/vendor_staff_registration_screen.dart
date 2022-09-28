import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/logo.dart';
import 'package:untitled/manager/staff_manager.dart';
import 'package:untitled/manager/vendor_mechanic_manager.dart';
import 'package:untitled/model/vendor_mechanic.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/screens/vendor_dashboard.dart';
import 'package:untitled/services/staff_service.dart';
import '../manager/profile_manager.dart';
import '../manager/roles_manager.dart';
import '../model/role.dart';
import '../utils/add_space.dart';
import '../resources/IndianStates.dart';

import 'package:http/http.dart' as http;

import '../model/vendor.dart';
import '../resources/resources.dart' as res;
import '../utils/validations.dart';


class VendorStaffRegistration extends StatefulWidget {
  const VendorStaffRegistration({Key? key}) : super(key: key);

  @override
  VendorStaffRegistrationState createState() => VendorStaffRegistrationState();
}

class VendorStaffRegistrationState extends State<VendorStaffRegistration> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _inidianStates = indianStates.values.toList();

  bool _isTermsChecked = false;

  String _dropDownValue = 'Select Role';
  String _dropDownStateVAlue = 'Select State';

  String? _name = '';
  String? _address = '';
  String? _country = '';
  String? _city = '';
  String? _aadhaarCard = '';
  String? _zipCode = '';
  bool _isMale = false;
  bool _isFemale = false;

  Future<VendorMechanic> updateMechanic(VendorMechanic vendorMechanic) async {
    var body = jsonEncode(vendorMechanic);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    http.Response response = await http.post(
        Uri.parse("${res.APP_URL}/api/vendorstaff/create_mechanic"),
        body: body,
        headers: headers
    );

    var json = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return VendorMechanic.fromJson(json);
    }
    throw Exception(json["message"]);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final VendorMechanicManager vendorMechanicManager = Provider.of<VendorMechanicManager>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Run Wheelz"), automaticallyImplyLeading: false,),
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 34, bottom: 34),
          child: Column(children: [
            Logo(),
            addVerticalSpace(30),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, top: 30, right: 25, bottom: 30),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Center(
                            child: Text(
                              "Mechanic Registration",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            )),
                        addVerticalSpace(40),
                        RWTextFormField(
                            label: 'Name',
                            icon: const Icon(Icons.person, color: Colors.deepPurple),
                            onSaved: (value) => _name = value,
                          textInputFormatters: [
                            CapitalizeTextFormatter()
                          ],
                        ),
                        addVerticalSpace(20),
                        RWTextFormField(
                            label: 'Aadhaar Card',
                            icon: const Icon(Icons.location_on, color: Colors.deepPurple),
                            helperText: '9090-9090-9090',
                            maxLength: 14,
                            textInputType: TextInputType.number,
                            textInputFormatters: [
                              MaskedTextInputFormatter(mask: '0000-0000-0000', separator: '-')
                            ],
                            onSaved: (value) => _aadhaarCard = value
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone_android, color: Colors.purple),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                  width: 1,
                                )
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                  width: 2,
                                )
                            ),
                          ),
                          onChanged: (value) => {
                            vendorMechanicManager.vendorMechanic.phoneNumber = value
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'this field required';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          maxLength: 10,
                        ),
                        addVerticalSpace(40),
                        Container(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState?.save();
                                    vendorMechanicManager.vendorMechanic.registrationStatus = true;
                                    vendorMechanicManager.vendorMechanic.name = _name;
                                    vendorMechanicManager.vendorMechanic.aadharNumber = _aadhaarCard;
                                    vendorMechanicManager.vendorMechanic.vendor = Provider.of<ProfileManager>(context, listen: false).vendorDTO;
                                    updateMechanic(vendorMechanicManager.vendorMechanic).then((response) {
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                                          return const VendorDashBoard();
                                        })
                                        );
                                    });
                                  }
                                },
                                child: const Text(
                                  'Register',
                                  style: TextStyle(fontSize: 24),
                                )))
                      ],
                    )),
              ),
            )
          ])),
    );
  }

}


typedef DropDownOnChanged = void Function(String?)?;
typedef FunctionSaved = void Function(String?)?;
typedef FunctionChanged = void Function(bool?)?;
typedef FunctionPressed = void Function()?;



class RWDropDown extends StatelessWidget {
  final String value;
  final DropDownOnChanged onChanged;
  final List<String>? items;

  RWDropDown({
    required this.value,
    required this.onChanged,
    required this.items
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10)),
      value: value,
      icon: const Icon(
        Icons.expand_circle_down,
        color: Colors.deepPurple,
      ),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: onChanged,
      items: items?.map<DropdownMenuItem<String>>((String item) { return DropdownMenuItem<String>(value: item, child: Text(item));}).toList(),
    );
  }
}

class RWCheckBox extends StatelessWidget {
  final String name;
  final bool isText;
  final bool value;
  final FunctionChanged onChanged;
  final FunctionPressed? onPressed;

  RWCheckBox({
    required this.name,
    required this.isText,
    required this.value,
    required this.onChanged,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        (isText ? Text(name) : TextButton(onPressed: onPressed, child: Text(name)))
      ],
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

  const RWTextFormField({
    required this.label,
    required this.icon,
    required this.onSaved,
    this.helperText,
    this.maxLength,
    this.textInputType,
    this.textInputFormatters
  });


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
        labelStyle: const TextStyle(color: Colors.green),
        helperStyle: const TextStyle(color: Colors.red, fontSize: 14),
        border: OutlineInputBorder(
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
            )),
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

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  });


  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.text.isNotEmpty) {
      if(newValue.text.length > oldValue.text.length) {
        if(newValue.text.length > mask.length) return oldValue;
        if(newValue.text.length < mask.length && mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text: '${oldValue.text}$separator${newValue.text.substring(newValue.text.length-1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}