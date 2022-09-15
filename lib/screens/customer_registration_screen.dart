import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/logo.dart';
import 'package:untitled/manager/customer_managere.dart';
import 'package:untitled/manager/vendor_manager.dart';
import './google_map_location_screen.dart';
import '../utils/add_space.dart';

class CustomerRegistration extends StatefulWidget {
  const CustomerRegistration({Key? key}) : super(key: key);

  @override
  CustomerRegistrationState createState() => CustomerRegistrationState();
}

class CustomerRegistrationState extends State<CustomerRegistration> {
  final _formKey = GlobalKey<FormState>();
  String dropDownValue = 'Current Location';
  bool _isTermsChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CustomerManager customerManager =
        Provider.of<CustomerManager>(context);

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
                child: Column(
                  children: [
                    addVerticalSpace(20),
                    addVerticalSpace(35),
                    RWTextFormField(
                        label: 'Name',
                        icon:
                            const Icon(Icons.person, color: Colors.deepPurple),
                        onSaved: (value) => {} //cu.ownerName = value
                        ),
                    addVerticalSpace(30),
                    RWTextFormField(
                        label: 'Email',
                        icon: const Icon(Icons.email, color: Colors.deepPurple),
                        onSaved: (value) => {} //cu.ownerName = value
                        ),
                    addVerticalSpace(30),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Checkbox(
                              value: _isTermsChecked,
                              onChanged: (value) {
                                //data.termsAndConditions = value as bool;
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
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        //log("vendor: ${jsonEncode(vendorManager.vendorRegistrationRequest)}");
                                        return const GoogleMapLocationPickerV1();
                                      }));
                                    }
                                  }
                                : null,
                            child: const Text(
                              'Next',
                              style: TextStyle(fontSize: 24),
                            )))
                  ],
                )),
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
      onSaved: onSaved,
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
