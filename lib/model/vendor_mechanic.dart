import 'package:untitled/model/vendor.dart';
import 'package:untitled/screens/vendor_registration_screen_v1.dart';

class VendorMechanic {
  int? id;
  String? name;
  String? phoneNumber;
  String? aadharNumber;
  VendorDTO? vendor;
  bool? registrationStatus;
  String? deviceToken;
  String? status;

  VendorMechanic({
    this.id = 0,
    this.name = '',
    this.phoneNumber = "",
    this.aadharNumber,
    this.vendor,
    this.registrationStatus = false,
    this.deviceToken = "",
    this.status = ""
  });

  Map toJson() => {
    "id": id,
    "name": name,
    "phoneNumber": phoneNumber,
    "aadharNumber": aadharNumber,
    "vendor": vendor,
    "registrationStatus": registrationStatus,
    "deviceToken": deviceToken,
    "status": status
  };

  factory VendorMechanic.fromJson(Map<String, dynamic> json) {
    return VendorMechanic(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        aadharNumber: json[" aadharNumber"],
        vendor: VendorDTO.fromJson(json["vendor"]),
        registrationStatus: json["registrationStatus"],
        deviceToken: json["deviceToken"],
        status: json["status"]
    );
  }
}