import 'package:untitled/screens/vendor_registration_screen_v1.dart';

class VendorMechanic {
  int? id;
  String? name;
  String? phoneNumber;
  String? aadharNumber;
  VendorRegistration? vendorRegistration;
  bool? registrationStatus;
  String? deviceToken;


  VendorMechanic({
    this.id = 0,
    this.name = '',
    this.phoneNumber = "",
    this.aadharNumber,
    this.vendorRegistration,
    this.registrationStatus = false,
    this.deviceToken = ""
  });

  Map toJson() => {
    "id": id,
    "name": name,
    "phoneNumber": phoneNumber,
    "aadharNumber": aadharNumber,
    "vendorRegistrationRequest": vendorRegistration,
    "registrationStatus": registrationStatus,
    "deviceToken": deviceToken
  };

  factory VendorMechanic.fromJson(Map<String, dynamic> json) {
    return VendorMechanic(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        aadharNumber: json[" aadharNumber"],
        vendorRegistration: json["vendorRegistrationRequest"],
        registrationStatus: json["registrationStatus"],
        deviceToken: json["deviceToken"]
    );
  }
}