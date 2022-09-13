import 'dart:typed_data';
import 'dart:ui';

import 'package:untitled/model/role.dart';

class StaffDTO {
  int? id;
  String? name;
  String? phoneNumber;
  Uint8List? proPic;
  String? aadharNumber;
  String? addressLine;
  String? city;
  String? state;
  String? zipcode;
  String? country;
  RoleDTO? role;
  String? jwt;
  bool? registrationStatus;
  String? deviceToken;
  double? latitude;
  double? longitude;

  StaffDTO({
    this.id = 0,
    this.name = "",
    this.phoneNumber = "",
    this.proPic,
    this.aadharNumber = "",
    this.addressLine = "",
    this.city = "",
    this.state = "",
    this.zipcode = "",
    this.country = "",
    this.role,
    this.jwt,
    this.registrationStatus = false,
    this.deviceToken,
    this.latitude = 0.0,
    this.longitude = 0.0
  });

  Map toJson() => {
      "id": id,
      "name": name,
      "phoneNumber": phoneNumber,
      "proPic": proPic,
      "aadharNumber": aadharNumber,
      "addressLine": addressLine,
      "city": city,
      "state": state,
      "zipcode": zipcode,
      "country": country,
      "role": role,
      "jwt": jwt,
      "registrationStatus": registrationStatus,
      "deviceToken": deviceToken,
      "latitude": latitude,
      "longitude": longitude
  };

  factory StaffDTO.fromJson(Map<String, dynamic> json) {
    return StaffDTO(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        proPic: json["proPic"],
        aadharNumber: json["aadharNumber"],
        addressLine: json["addressLine"],
        city: json["city"],
        state: json["state"],
        zipcode: json["zipcode"],
        role: RoleDTO.fromJson(json["role"]),
        jwt: json["jwt"],
        registrationStatus: json["registrationStatus"],
        deviceToken: json["deviceToken"],
        latitude: json["latitude"],
        longitude: json["longitude"]
    );
  }

}