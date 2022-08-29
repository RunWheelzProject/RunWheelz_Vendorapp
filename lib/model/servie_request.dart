import 'dart:developer';

class ServiceRequestDTO {
  int? id;
  String? serviceType;
  String? make;
  String? vehicleNumber;
  double? latitude;
  double? longitude;
  int? acceptedByVendor;
  int? assignedToMechanic;
  String? status;
  String? comments;
  /*CustomerDTO? customerDTO;
  VendorDTO? vendorDTO;
  VendorMechanicDTO? vendorMechanicDTO;*/

  ServiceRequestDTO({
    this.id,
    this.serviceType,
    this.make,
    this.vehicleNumber,
    this.latitude,
    this.longitude,
    this.acceptedByVendor,
    this.assignedToMechanic,
    this.status,
    this.comments
  });

  Map toJson() => {
    "id": id,
    "serviceType": serviceType,
    "make": make,
    "vehicleNumber": vehicleNumber,
    "longitude": longitude,
    "latitude": latitude,
    "acceptedByVendor": acceptedByVendor,
    "assignedToMechanic": assignedToMechanic,
    "status": status,
    "comments": comments,
  };

  factory ServiceRequestDTO.fromJson(Map<String, dynamic> json) {
    return ServiceRequestDTO(
      id: json["id"],
      serviceType: json["serviceType"],
      make: json["make"],
      vehicleNumber: json["vehicleNumber"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      acceptedByVendor: json["acceptedByVendor"],
      assignedToMechanic: json["assignedToMechanic"],
      status: json["status"],
      comments: json["comments"],
    );
  }
}

