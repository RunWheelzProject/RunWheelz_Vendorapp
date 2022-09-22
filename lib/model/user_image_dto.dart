import 'dart:convert';
import 'dart:typed_data';

class UserImageDTO {
  int? userId;
  List<int>? image;

  UserImageDTO({
    this.userId,
    this.image
  });

  Map toJson() => {
    "userId": userId,
    "image": image
  };

  factory UserImageDTO.fromJson(Map<String, dynamic> json) {
    return UserImageDTO(
      userId: json["userId"],
      image: const Base64Codec().decode(json["image"])
    );
  }
}