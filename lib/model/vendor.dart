import 'package:untitled/model/role.dart';

class VendorDTO {
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
  RoleDTO? role;
  bool? registrationStatus;
  String? marketingAgent;
  String? executive;
  String? status;

  VendorDTO({this.ownerName = '',
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
    this.role,
    this.registrationStatus = false,
    this.marketingAgent,
    this.executive = "",
    this.status = ""

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
    "role": role,
    "registrationStatus": registrationStatus,
    "marketingAgent": marketingAgent,
    "executive": executive,
    "status": status
  };

  factory VendorDTO.fromJson(Map<String, dynamic> json) {
    return VendorDTO(
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
      role: RoleDTO.fromJson(json["role"]),
      registrationStatus: json["registrationStatus"],
      marketingAgent: json["marketingAgent"],
      executive: json["executive"],
      status: json["status"]
    );
  }

}