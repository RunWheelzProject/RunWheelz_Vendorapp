import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/preferred_mechanic_select_screen.dart';
import 'package:untitled/utils/add_space.dart';
import '../components/customer_appbar.dart';
import '../manager/service_request_manager.dart';
import 'google_map_location_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

typedef CallBack = void Function();

class GeneralServices extends StatefulWidget {
  const GeneralServices({Key? key}) : super(key: key);

  @override
  GeneralServicesState createState() => GeneralServicesState();
}

class GeneralServicesState extends State<GeneralServices> {

  MaskTextInputFormatter maskTextInputFormatter = MaskTextInputFormatter(
      mask: 'AA ## A ####',
      filter: { "#": RegExp(r'[0-9]'), "A": RegExp(r'[a-zA-Z]'),  },
      type: MaskAutoCompletionType.lazy
  );
  String _dropDownValue = 'Select Vehicle Type';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vehicleController = TextEditingController();

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
                      "General Services",
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
                        addVerticalSpace(50),
                        RWDropDown(
                            value: _dropDownValue,
                            onChanged: (String? val) {
                              serviceRequestManager.serviceRequestDTO.make = val;
                              _dropDownValue = val!;
                            },
                            items: const [
                              'Select Vehicle Type',
                              'Honda',
                              'TVS',
                              'Suzuki'
                            ]),
                        addVerticalSpace(20),
                        RWTextFormField(
                            textEditingController: _vehicleController,
                            label: "Vehicle Number",
                            icon: const Icon(Icons.numbers),
                            helperText: "TG 21 B 4592",
                            textInputFormatters: [
                              maskTextInputFormatter
                            ],
                            onSaved: (String? val) {
                              serviceRequestManager.serviceRequestDTO.vehicleNumber = val?.toUpperCase();
                              _vehicleController.value = TextEditingValue(
                                text: val?.toUpperCase() as String,
                                  selection: _vehicleController.selection
                              );
                              if (val?.length == 12) {
                                FocusScope.of(context).unfocus();
                              }
                            }
                            ),
                        addVerticalSpace(70),
                        ElevatedButton(
                            onPressed: () => {
                              if (_formKey.currentState!.validate() && _dropDownValue != "Select Vehicle Type") {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                                  return const PreferredMechanicSelectScreen();
                                }))
                              } else {
                                  showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                          title:
                                          const Text("Message"),
                                          content: const Text("Please select vehicle type and enter vehicle number",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.red)),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(
                                                      context, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ])
                              )
                              }
                            },
                            child: const Text("Proceed"))
                      ],
                    ),
                  ))
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
  final TextCapitalization? textCapitalization;
  final TextEditingController? textEditingController;

  const RWTextFormField({
    required this.label,
    required this.icon,
    required this.onSaved,
    this.helperText,
    this.maxLength,
    this.textInputType,
    this.textInputFormatters,
    this.textCapitalization,
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
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: icon,
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
            )
        ),*/
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