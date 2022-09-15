import './role.dart';

class CustomerDTO {
  int? id;
  String? name;
  String? phoneNumber;
  bool? registrationStatus;
  RoleDTO? role;
  String? jwt;
  CustomerDTO({
    this.id,
    this.name,
    this.phoneNumber,
    this.registrationStatus,
    this.role,
    this.jwt
  });

  Map toJson() => {
    "id": id,
    "name": name,
    "phoneNumber": phoneNumber,
    "registrationStatus": registrationStatus,
    "role": role,
    "jwt": jwt
  };

  factory CustomerDTO.fromJson( Map<String, dynamic> json) {
    return CustomerDTO(
      id: json["id"],
      name: json["name"],
      phoneNumber: json["phoneNumber"],
      registrationStatus: json["registrationStatus"],
      role: RoleDTO.fromJson(json["role"]),
      jwt: json["jwt"]
    );
  }

}