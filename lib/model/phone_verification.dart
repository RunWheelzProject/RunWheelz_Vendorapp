class PhoneVerification {
  String? phoneNumber;
  String? otp;
  String? verificationRef;

  PhoneVerification({this.phoneNumber,
    this.otp,
    this.verificationRef});

  Map toJson() => {
    "phoneNumber": phoneNumber,
    "otp": otp,
    "verificationRef": verificationRef
  };
}