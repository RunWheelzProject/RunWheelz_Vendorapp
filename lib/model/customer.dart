import './role.dart';

class CustomerDTO {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  bool? registrationStatus;
  bool? termsAndConditions;
  RoleDTO? role;
  String? jwt;
  CustomerDTO({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
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
      registrationStatus: json["registrationStatus"],
      termsAndConditions: json["termsAndConditions"],
      role: RoleDTO.fromJson(json["role"]),
      jwt: json["jwt"]
    );
  }

}