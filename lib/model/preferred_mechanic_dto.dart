import 'package:untitled/model/vendor.dart';
import '../model/vendor.dart';
class PreferredMechanicDTO {
  int? id;
  VendorDTO? vendor;

  PreferredMechanicDTO({
    this.id = 0,
    this.vendor
  });

  Map toJson() => {
    "id": id,
    "vendor": vendor
  };

  factory PreferredMechanicDTO.fromJson(Map<String, dynamic> json) {
    return PreferredMechanicDTO(
        id: json["id"],
        vendor: VendorDTO.fromJson(json["vendor"])
    );
  }
}