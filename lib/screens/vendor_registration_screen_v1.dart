import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/logo.dart';
import 'package:untitled/manager/vendor_manager.dart';
import './google_map_location_screen.dart';
import '../utils/add_space.dart';

class VendorRegistrationV1 extends StatefulWidget {
  const VendorRegistrationV1({Key? key}) : super(key: key);

  @override
  VendorRegistration createState() => VendorRegistration();
}

class VendorRegistration extends State<VendorRegistrationV1> {
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

    final VendorManager vendorManager = Provider.of<VendorManager>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Run Wheelz")),
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 34, bottom: 34),
          child: Column( children: [
              Logo(),
            addVerticalSpace(30),
            Card(
            margin: const EdgeInsets.symmetric(horizontal: 35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 25, top: 20, right: 25, bottom: 30),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                          child: Text(
                            "Vendor Registration",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          )
                      ),
                      addVerticalSpace(35),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person, color: Colors.purple),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.purple,
                                width: 1,
                              )
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.purple,
                                width: 2,
                              )
                          ),
                        ),
                        onChanged: (value) => {
                          vendorManager.vendorRegistrationRequest.ownerName = value
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'this field required';
                          }
                          return null;
                        },
                      ),
                      /*addVerticalSpace(30),
                      TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone_android, color: Colors.purple),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.purple,
                                    width: 1,
                                  )
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.purple,
                                    width: 2,
                                  )
                              ),
                            ),
                            onChanged: (value) => {
                              vendorManager.vendorRegistrationRequest.phoneNumber = value
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
                      const SizedBox(
                        height: 30,
                      ),*/
                  TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Garage Name',
                            prefixIcon: Icon(Icons.home, color: Colors.purple),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                  width: 1,
                                )
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.purple,
                                  width: 2,
                                )
                            ),
                          ),
                          onChanged: (value) => {
                            vendorManager.vendorRegistrationRequest.garageName = value
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'this field required';
                            }
                            return null;
                          },
                        ),
                      addVerticalSpace(20),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Checkbox(
                                value: _isTermsChecked,
                                onChanged: (value) {
                                  vendorManager.vendorRegistrationRequest.termsAndConditions = value as bool;
                                  setState(() {
                                    _isTermsChecked = value;
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
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                                        //log("vendor: ${jsonEncode(vendorManager.vendorRegistrationRequest)}");
                                    return const GoogleMapLocationPickerV1();
                                  }));
                                }
                              } : null,
                              child: const Text('Next', style: TextStyle(fontSize: 24),)))
                    ],
                  )),
            ),
          )])),
    );
  }
}
