import 'package:untitled/screens/vendor_registration_screen_v1.dart';

class VendorMechanic {
  int? id;
  String? name;
  String? phoneNumber;
  VendorRegistration? vendorRegistration;
  bool? registrationStatus;
  String? deviceToken;


  VendorMechanic({
    this.id = 0,
    this.name = '',
    this.phoneNumber = "",
    this.vendorRegistration,
    this.registrationStatus = false,
    this.deviceToken = ""
  });

  Map toJson() => {
    "id": id,
    "name": name,
    "phoneNumber": phoneNumber,
    "vendorRegistrationRequest": vendorRegistration,
    "registrationStatus": registrationStatus,
    "deviceToken": deviceToken
  };

  factory VendorMechanic.fromJson(Map<String, dynamic> json) {
    return VendorMechanic(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        vendorRegistration: json["vendorRegistrationRequest"],
        registrationStatus: json["registrationStatus"],
        deviceToken: json["deviceToken"]
    );
  }
}