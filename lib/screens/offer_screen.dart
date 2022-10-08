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
import 'package:untitled/screens/payment_screen.dart';
import 'package:untitled/utils/add_space.dart';
import '../manager/profile_manager.dart';
import 'current_offers.dart';
import 'google_map_location_screen.dart';

import 'package:http/http.dart' as http;
import '../resources/resources.dart' as res;
import 'package:upi_india/upi_india.dart';


class RunWheelzOffer extends StatefulWidget {
  OfferDTO? offerDTO;
  RunWheelzOffer({Key? key, this.offerDTO}) : super(key: key);

  @override
  RunWheelzOfferState createState() => RunWheelzOfferState();
}

class RunWheelzOfferState extends State<RunWheelzOffer> {

  final UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;


  Future<OfferDTO> updateOffer(OfferDTO offerDTO) async {
    Uri uri = Uri.parse("${res.APP_URL}/api/offers/updateOffer");
    var body = jsonEncode(offerDTO);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    http.Response response = await http.put(
      uri,
      body: body,
      headers: headers
    );

    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200 ) {
      return OfferDTO.fromJson(responseJson);
    }

    throw Exception("offer not updated");

  }

  Future<String> getOfferFromSharedPreference() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? offer = prefs.getString("offersJson");
    if ( offer != null) {
      return offer;
    }
    
    throw Exception("could not found offer");
  }

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
    if (widget.offerDTO == null) {
      getOfferFromSharedPreference().then((offer) {
        log(offer);
        setState(() => widget.offerDTO = OfferDTO.fromJson(jsonDecode(offer)));
      }).catchError((error) => log("$error"));
    }

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
    return Container(
        margin: EdgeInsets.only(top: topMargin),
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.32,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: screenHeight * 0.06,
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black38, width: 1),
                              color: Colors.purple
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white,),
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (BuildContext context) {
                                return CurrentOffersScreen();
                              })
                          );
                        },
                      )
                      ,
                    ],
                  ),
                  const Flexible(
                    child: FractionallySizedBox(
                      heightFactor: 0.99,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.offerDTO?.product?.productName ?? "", style: const TextStyle(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Flexible(
                    child: FractionallySizedBox(
                      heightFactor: 0.1,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(10),
                          width: screenHeight * 0.14,
                          height: screenHeight * 0.14,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black38, width: 1)
                          ),
                        child: const Image(image: AssetImage("images/bike-oil.jpg"))
                      ),
                      const Flexible(
                        child: FractionallySizedBox(
                          widthFactor: 0.5,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              height: screenHeight * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Description", style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w700)),
                  const Flexible(
                    child: FractionallySizedBox(
                      heightFactor: 0.02,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(widget.offerDTO?.product?.productDescription ?? "", overflow: TextOverflow.fade,),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              height: screenHeight * 0.12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Flexible(
                    child: FractionallySizedBox(
                      heightFactor: 0.1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Text("Qty:", style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            ),

                            SizedBox(width: 55,),
                            Text("1", style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                                textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            const Text("Total:", style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            ),
                            const SizedBox(width: 45,),
                            Text(widget.offerDTO?.offerDiscountAmount ?? "0.0", style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
              height: screenHeight * 0.1,
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  widget.offerDTO?.customer = Provider.of<ProfileManager>(context, listen: false).customerDTO;

                  log("offer: ${jsonEncode(widget.offerDTO)}");
                  updateOffer(widget.offerDTO!).then((offer) {

                  });

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return const PaymentScreen();
                      })
                  );

                  },
                child: const Text("Purchase"),
              ),
            ))
          ],
        ),
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
