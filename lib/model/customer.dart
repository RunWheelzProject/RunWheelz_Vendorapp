import './role.dart';

class CustomerDTO {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? deviceToken;
  bool? registrationStatus;
  bool? termsAndConditions;
  RoleDTO? role;
  String? jwt;
  CustomerDTO({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.deviceToken,
    this.registrationStatus,
    this.termsAndConditions,
    this.role,
    this.jwt
  });

  Map toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phoneNumber": phoneNumber,
    "deviceToken": deviceToken,
    "registrationStatus": registrationStatus,
    "termsAndConditions": termsAndConditions,
    "role": role,
    "jwt": jwt
  };

  factory CustomerDTO.fromJson( Map<String, dynamic> json) {
    return CustomerDTO(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      deviceToken: json["deviceToken"],
      registrationStatus: json["registrationStatus"],
      termsAndConditions: json["termsAndConditions"],
      role: RoleDTO.fromJson(json["role"]),
      jwt: json["jwt"]
    );
  }

}