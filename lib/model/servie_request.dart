import 'dart:developer';

import 'customer.dart';

class ServiceRequestDTO {
  int? id;
  String? serviceType;
  String? make;
  String? vehicleNumber;
  double? latitude;
  double? longitude;
  int? acceptedByVendor;
  int? assignedToMechanic;
  int? requestedCustomer;
  String? status;
  String? comments;
  CustomerDTO? customerDTO;
  /*VendorDTO? vendorDTO;
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
    this.requestedCustomer,
    this.status,
    this.comments,
    this.customerDTO
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
    "requestedCustomer": requestedCustomer,
    "status": status,
    "comments": comments,
    "customerDTO": customerDTO
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
      requestedCustomer: json["requestedCustomer"],
      status: json["status"],
      comments: json["comments"],
      customerDTO: json["customerDTO"]
    );
  }
}

