import 'package:untitled/model/role.dart';

class VendorRegistrationRequest {
  String? ownerName;
  String? phoneNumber;
  String? garageName;
  double? longitude;
  double? latitude;
  String? referenceID;
  bool? termsAndConditions;
  int? id;
  int? vendorPin;
  String? aadharNumber;
  String? addressLine;
  String? city;
  String? state;
  String? zipcode;
  String? country;
  int? roleId;
  bool? registrationStatus;

  VendorRegistrationRequest({this.ownerName = '',
    this.phoneNumber = "",
    this.garageName = '',
    this.longitude = 0.0,
    this.latitude = 0.0,
    this.referenceID = '',
    this.termsAndConditions = false,
    this.id = 0,
    this.vendorPin = 0,
    this.aadharNumber = "",
    this.addressLine = "",
    this.city = "",
    this.state = "",
    this.zipcode = "",
    this.country = "",
    this.roleId,
    this.registrationStatus = false

  });

  Map toJson() => {
    "ownerName": ownerName,
    "phoneNumber": phoneNumber,
    "garageName": garageName,
    "longitude": longitude,
    "latitude": latitude,
    "referenceID": referenceID,
    "termsAndConditions": termsAndConditions,
    "id": id,
    "vendorPin": vendorPin,
    "aadharNumber": aadharNumber,
    "addressLine": addressLine,
    "city": city,
    "state": state,
    "zipcode": zipcode,
    "country": country,
    "roleId": roleId,
    "registrationStatus": registrationStatus
  };

  factory VendorRegistrationRequest.fromJson(Map<String, dynamic> json) {
    return VendorRegistrationRequest(
      id: json["id"],
      ownerName: json["ownerName"],
      phoneNumber: json["phoneNumber"],
      garageName: json["garageName"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      referenceID: json["referenceID"],
      termsAndConditions: json["termsConditions"],
      vendorPin: json["vendorPin"],
      aadharNumber: json["aadharNumber"],
      addressLine: json["addressLine"],
      city: json["city"],
      zipcode: json["zipcode"],
      country: json["country"],
      roleId: json["roleId"],
      registrationStatus: json["registrationStatus"]
    );
  }

}