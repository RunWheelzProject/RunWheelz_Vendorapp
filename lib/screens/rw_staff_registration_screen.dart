import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/logo.dart';
import 'package:untitled/manager/staff_manager.dart';
import 'package:untitled/screens/rw_management_screen.dart';
import 'package:untitled/services/staff_service.dart';
import '../manager/roles_manager.dart';
import '../model/role.dart';
import '../utils/add_space.dart';
import '../resources/IndianStates.dart';

class RWStaffRegistration extends StatefulWidget {
  const RWStaffRegistration({Key? key}) : super(key: key);

  @override
  RWStaffRegistrationState createState() => RWStaffRegistrationState();
}

class RWStaffRegistrationState extends State<RWStaffRegistration> {
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final StaffManager staffManager = Provider.of<StaffManager>(context, listen: false);
    final RoleManager roleManager = Provider.of<RoleManager>(context);
    log("rolesNames: ${jsonEncode(roleManager.roleNames)}");
    List<String> roles = roleManager.roleNames.map((role) => role.roleName as String).toList();
    log("rolesNames: ${jsonEncode(roles)}");
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
                              "Staff Registration",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            )),
                        addVerticalSpace(40),
                        RWTextFormField(
                            label: 'Name',
                            icon: const Icon(Icons.person, color: Colors.deepPurple),
                            onSaved: (value) => _name = value
                        ),
                        addVerticalSpace(25),
                        Row(
                          children: [
                            RWCheckBox(
                              name: "M",
                              isText: true,
                              value: _isMale,
                              onChanged: (value) => _isMale = value!,
                            ),
                            addHorizontalSpace(20),
                            RWCheckBox(
                              name: "F",
                              isText: true,
                              value: _isFemale,
                              onChanged: (value) => _isFemale = value!,
                            ),
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
                        addVerticalSpace(40),
                        RWTextFormField(
                            label: 'Address',
                            icon: const Icon(Icons.location_on, color: Colors.deepPurple),
                            onSaved: (value) => _address = value
                        ),
                        addVerticalSpace(40),
                        RWTextFormField(
                            label: 'City',
                            icon: const Icon(Icons.location_on, color: Colors.deepPurple),
                            onSaved: (value) => _city = value
                        ),
                        addVerticalSpace(20),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: RWDropDown(
                              value: _dropDownStateVAlue,
                              items: _inidianStates,
                              onChanged: (String? newValue) {
                                  _dropDownStateVAlue = newValue!;
                                  staffManager.staffDTO.state = newValue;
                              },
                            )
                        ),
                        addVerticalSpace(20),
                        RWTextFormField(
                            label: 'Zipcode',
                            icon: const Icon(Icons.location_on, color: Colors.deepPurple),
                            maxLength: 6,
                            textInputType: TextInputType.number,
                            textInputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                            ],
                            onSaved: (value) => _zipCode = value
                        ),
                        addVerticalSpace(20),
                        RWTextFormField(
                            label: 'Country',
                            icon: const Icon(Icons.location_on, color: Colors.deepPurple),
                            onSaved: (value) => _country = value
                        ),
                        addVerticalSpace(20),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: RWDropDown(
                              value: _dropDownValue,
                              items: const ["Select Role", "ADMIN", "EXECUTIVE", "MARKETING_AGENT"],
                              onChanged: (String? newValue) {
                                  _dropDownValue = newValue!;
                                  RoleDTO roleDTO = RoleDTO();
                                  if (_dropDownValue == "ADMIN") roleDTO.id = 1;
                                  if (_dropDownValue == "MARKETING_AGENT") roleDTO.id = 2;
                                  if (_dropDownValue == "EXECUTIVE") roleDTO.id = 3;
                                  roleDTO.roleName = newValue;
                                  staffManager.staffDTO.role = roleDTO;
                              },
                            )
                        ),
                        addVerticalSpace(20),
                        Container(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState?.save();
                                    staffManager.staffDTO.registrationStatus = true;
                                    staffManager.staffDTO.name = _name;
                                    staffManager.staffDTO.addressLine = _address;
                                    staffManager.staffDTO.country = _country;
                                    staffManager.staffDTO.city = _city;
                                    staffManager.staffDTO.aadharNumber = _aadhaarCard;
                                    staffManager.staffDTO.zipcode = _zipCode;

                                    log("vendor: ${jsonEncode(staffManager.staffDTO)}");

                                    StaffService().updateStaffInfo(staffManager.staffDTO)
                                    .then((response) {
                                      if (response.statusCode == 200) {
                                        log("status: ${response.statusCode}");
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                                              return const RunWheelManagementPage();
                                            })
                                          );
                                      }
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
  final TextCapitalization? textCapitalization;

  const RWTextFormField({
    required this.label,
    required this.icon,
    required this.onSaved,
    this.helperText,
    this.maxLength,
    this.textInputType,
    this.textInputFormatters,
    this.textCapitalization
  });


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      keyboardType: textInputType,
      inputFormatters: textInputFormatters,
      maxLength: maxLength,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
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