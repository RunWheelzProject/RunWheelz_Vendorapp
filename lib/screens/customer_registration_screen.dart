import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:profile/profile.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/logo.dart';
import 'package:untitled/manager/customer_managere.dart';
import 'package:untitled/manager/profile_manager.dart';
import 'package:untitled/manager/vendor_manager.dart';
import 'package:untitled/screens/customer_board.dart';
import '../model/customer.dart';
import '../utils/validations.dart';
import './google_map_location_screen.dart';
import '../utils/add_space.dart';

import 'package:http/http.dart' as http;
import 'dart:developer';
import '../model/vendor.dart';
import '../resources/resources.dart' as res;

class CustomerRegistration extends StatefulWidget {
  const CustomerRegistration({Key? key}) : super(key: key);

  @override
  CustomerRegistrationState createState() => CustomerRegistrationState();
}

class CustomerRegistrationState extends State<CustomerRegistration> {
  final _formKey = GlobalKey<FormState>();
  String dropDownValue = 'Current Location';
  bool _isTermsChecked = false;

  Future<http.Response> customerUpdate(CustomerDTO customerDTO) async {
    Uri uri = Uri.parse("${res.APP_URL}/api/customer/updatecustomer");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var json = jsonEncode(customerDTO);
    http.Response response = await http.put(
      uri,
      headers: headers,
      body: json
    );

    var responseJson = jsonDecode(response.body);

    return response;

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileManager profileManager = Provider.of<ProfileManager>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Run Wheelz")),
      body: SingleChildScrollView(
          child: Column(children: [
        SizedBox(
          height: 20,
        ),
        Logo(),
        Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
          ),
          child: Column(children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: Colors.purple, border: Border(bottom: BorderSide())),
              child: const Text(
                "Customer Registration",
                style: TextStyle(fontSize: 21, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      addVerticalSpace(20),
                      addVerticalSpace(35),
                      RWTextFormField(
                          label: 'Name',
                          icon: const Icon(Icons.person,
                              color: Colors.deepPurple),
                          textInputFormatters: [
                            CapitalizeTextFormatter()
                          ],
                          onSaved: (value) =>  profileManager.customerDTO.name = value //cu.ownerName = value
                          ),
                      addVerticalSpace(30),
                      RWTextFormField(
                          label: 'Email',
                          icon: const Icon(Icons.email, color: Colors.deepPurple),
                          onSaved: (value){
                            profileManager.customerDTO.email = value;
                          }),
                      addVerticalSpace(30),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Checkbox(
                                value: _isTermsChecked,
                                onChanged: (value) {
                                  profileManager.customerDTO.termsAndConditions = true;
                                  setState(() {
                                    _isTermsChecked =
                                        _isTermsChecked ? false : true;
                                  });
                                },
                              ),
                              TextButton(
                                  onPressed: () => {},
                                  child: const Text("Terms and Conditions"))
                            ],
                          )),
                      addVerticalSpace(20),
                      Container(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                              onPressed: _isTermsChecked
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        String email = profileManager.customerDTO.email ?? "";
                                        !email.isValidEmail() ? showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                    title:
                                                    const Text("Email"),
                                                    content: const Text(
                                                        "Not valid email, please check your email",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black87)),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(context, 'OK'),
                                                        child: const Text('OK'),
                                                      ),
                                                    ])
                                        ) :
                                        customerUpdate(profileManager.customerDTO).then((response) {
                                          var responseJson = jsonDecode(response.body);

                                          if (response.statusCode == 201) {
                                            profileManager.customerDTO = CustomerDTO.fromJson(responseJson);
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                                  //log("vendor: ${jsonEncode(vendorManager.vendorRegistrationRequest)}");
                                                  return CustomerDashBoard(
                                                      isCustomer: true);
                                                }));
                                          }
                                          if (response.statusCode == 226) {
                                            showDialog<String>(
                                                context: context,
                                                builder: (BuildContext context) =>
                                                    AlertDialog(
                                                        title:
                                                        const Text("Email"),
                                                        content: const Text(
                                                            "Email already exists, use different one",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors.black87)),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context, 'OK'),
                                                            child: const Text('OK'),
                                                          ),
                                                        ])
                                            );
                                          }
                                        });
                                      }
                                    }
                                  : null,
                              child: const Text(
                                'Register',
                                style: TextStyle(fontSize: 24),
                              )))
                    ],
                  )),
            )
          ]),
        )
      ])),
    );
  }
}

typedef FunctionSaved = void Function(String?)?;

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
      onChanged: onSaved,
      keyboardType: textInputType,
      inputFormatters: textInputFormatters,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: icon,
        labelStyle: const TextStyle(color: Colors.black45),
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
