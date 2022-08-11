class RoleDTO {
  int? id;
  String? roleName;

  RoleDTO({this.id = 0, this.roleName = ""});

  Map toJson() => {
    "id": id,
    "roleName": roleName
  };

  factory RoleDTO.fromJson(Map<String, dynamic> json) {
    return RoleDTO(
      id: json["id"],
      roleName: json["roleName"]
    );
  }
}