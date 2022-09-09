import './role.dart';

class Customer {
  int? id;
  String? name;
  String? phoneNumber;
  bool? registrationStatus;
  RoleDTO? role;
  String? jwt;
  Customer({
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

  factory Customer.fromJson( Map<String, dynamic> json) {
    return Customer(
      id: json["id"],
      name: json["name"],
      phoneNumber: json["phoneNumber"],
      registrationStatus: json["registrationStatus"],
      role: json["role"],
      jwt: json["jwt"]
    );
  }

}