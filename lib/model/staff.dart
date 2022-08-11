import 'dart:typed_data';
import 'dart:ui';

import 'package:untitled/model/role.dart';

class StaffDTO {
  int? id;
  String? name;
  String? phoneNumber;
  Uint8List? proPic;
  String? aadharNumber;
  double? longitude;
  double? latitude;
  String? addressLine;
  String? city;
  String? state;
  String? zipcode;
  String? country;
  RoleDTO? role;
  String? jwt;
  bool? registrationStatus;

  StaffDTO({
    this.id = 0,
    this.name = "",
    this.phoneNumber = "",
    this.proPic,
    this.aadharNumber = "",
    this.longitude = 0,
    this.latitude = 0,
    this.addressLine = "",
    this.city = "",
    this.state = "",
    this.zipcode = "",
    this.country = "",
    this.role,
    this.jwt,
    this.registrationStatus = false,
  });

  Map toJson() => {
      "id": id,
      "name": name,
      "phoneNumber": phoneNumber,
      "proPic": proPic,
      "aadharNumber": aadharNumber,
      "longitude": longitude,
      "latitude": latitude,
      "addressLine": addressLine,
      "city": city,
      "state": state,
      "zipcode": zipcode,
      "country": country,
      "role": role,
      "jwt": jwt,
      "registrationStatus": registrationStatus
  };

  factory StaffDTO.fromJson(Map<String, dynamic> json) {
    return StaffDTO(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        proPic: json["proPic"],
        aadharNumber: json["aadharNumber"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        addressLine: json["addressLine"],
        city: json["city"],
        state: json["state"],
        zipcode: json["zipcode"],
        role: RoleDTO.fromJson(json["role"]),
        jwt: json["jwt"],
        registrationStatus: json["registrationStatus"]
    );
  }

}