class VendorRegistrationRequest {
  String ownerName;
  int phoneNumber;
  String garageName;
  double longitude;
  double latitude;
  String referenceID;
  bool termsAndConditions;


  VendorRegistrationRequest({this.ownerName = '',
    this.phoneNumber = 0,
    this.garageName = '',
    this.longitude = 0.0,
    this.latitude = 0.0,
    this.referenceID = '',
    this.termsAndConditions = false});

  Map toJson() => {
    "ownerName": ownerName,
    "phoneNumber": phoneNumber,
    "garrageName": garageName,
    "longitude": longitude,
    "latitude": latitude,
    "referenceID": referenceID,
    "termsAndConditions": termsAndConditions
  };

}