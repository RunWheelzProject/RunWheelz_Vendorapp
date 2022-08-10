import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/components/logo.dart';
import 'package:untitled/manager/vendor_manager.dart';
import './google_map_location_screen.dart';
import '../utils/add_space.dart';

class RWVendorRegistration extends StatefulWidget {
  const RWVendorRegistration({Key? key}) : super(key: key);

  @override
  RWVendorRegistrationState createState() => RWVendorRegistrationState();
}

class RWVendorRegistrationState extends State<RWVendorRegistration> {
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
              margin: const EdgeInsets.symmetric(horizontal: 15),
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
                        addVerticalSpace(40),
                        // textFormField("Id", const Icon(Icons.verified_user, color: Colors.deepPurple)),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("ID: 23456",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 21
                            ),
                          )
                        ),
                        addVerticalSpace(15),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Phone Number: 98567 43345",
                              textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 21
                                )
                            )
                        ),
                        addVerticalSpace(25),
                        textFormField("Owner Name", const Icon(Icons.person, color: Colors.deepPurple)),
                        addVerticalSpace(20),
                        textFormField("Garage Name", const Icon(Icons.home, color: Colors.deepPurple)),
                        addVerticalSpace(25),
                        Row(
                          children: [
                            Checkbox(
                                onChanged: (val) => {}, value: true,),
                            const Text("M"),
                            addHorizontalSpace(20),
                            Checkbox(
                              onChanged: (val) => {}, value: false,),
                            const Text("F"),
                          ],
                        ),
                        addVerticalSpace(40),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Address:\n\n2-41, Chelgal\nJagtial, Karimnagar\nTelangana, India - 505455",
                          style: TextStyle(fontSize: 20, color: Colors.green),),
                        ),
                        addVerticalSpace(40),
                        textFormField("City", const Icon(Icons.location_city, color: Colors.deepPurple)),
                        addVerticalSpace(20),
                        textFormField("State", const Icon(Icons.location_city, color: Colors.deepPurple)),
                        addVerticalSpace(20),
                        textFormField("Zipcode", const Icon(Icons.folder_zip, color: Colors.deepPurple)),
                        addVerticalSpace(20),
                        textFormField("Country", const Icon(Icons.real_estate_agent, color: Colors.deepPurple)),
                        addVerticalSpace(20),
                        textFormField("Role", const Icon(Icons.account_circle_rounded, color: Colors.deepPurple)),
                        addVerticalSpace(30),
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

  Widget textFormField(String label, Icon icon) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon,
        labelStyle: const TextStyle(color: Colors.green),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.purple,
              width: 0,
            )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.purple,
              width: 0,
            )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.purple,
              width: 0,
            )
        ),
      ),
      onChanged: (value) => {
        //vendorManager.vendorRegistrationRequest.ownerName = value
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'this field required';
        }
        return null;
      },
    );
  }
}
