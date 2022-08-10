class VendorOtpResponse {
  String phoneNumber;
  String verificationRef;
  String statusMessage;

  VendorOtpResponse({required this.phoneNumber,
    required this.verificationRef,
    required this.statusMessage});

  Map toJson() => {
    "phoneNumber": phoneNumber,
    "verificationRef": verificationRef,
    "statusMessage": statusMessage
  };
}