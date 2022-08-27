import 'package:untitled/screens/vendor_registration_screen_v1.dart';

class VendorMechanic {
  int? id;
  String? name;
  String? phoneNumber;
  VendorRegistration? vendorRegistration;
  bool? registrationStatus;


  VendorMechanic({
    this.id = 0,
    this.name = '',
    this.phoneNumber = "",
    this.vendorRegistration,
    this.registrationStatus = false

  });

  Map toJson() => {
    "id": id,
    "name": name,
    "phoneNumber": phoneNumber,
    "vendorRegistrationRequest": vendorRegistration,
    "registrationStatus": registrationStatus
  };

  factory VendorMechanic.fromJson(Map<String, dynamic> json) {
    return VendorMechanic(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        vendorRegistration: json["vendorRegistrationRequest"],
        registrationStatus: json["registrationStatus"]
    );
  }
}