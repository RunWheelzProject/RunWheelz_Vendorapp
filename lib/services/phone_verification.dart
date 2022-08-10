import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../exceptions/app_exceptions.dart';
import '../model/otp_response.dart';
import '../resources/resources.dart' as res;

class PhoneVerificationService {

  //final String _vendorSendOtp = "${res.APP_URL}/api/auth/login/sendotp?phoneNumber=91";
  //final String _vendorVerify = "http://10.0.2.2:8081/api/auth/login/verifyotp";

  Future<http.Response> sendOtp(int phoneNumber, Uri vendorSendOTP) async {
    Uri vendorSendOtpURL = Uri.parse("$vendorSendOTP$phoneNumber");
    log("_vendorSendOtpURL: $vendorSendOtpURL");

    http.Response response = await http.get(vendorSendOtpURL);

    return response;
  }

  Future<http.Response> verifyOtp(String phoneVerification, Uri vendorVerifyURL) async {
    log("_vendorVerifyURL: $vendorVerifyURL");
    log("phoneVerification: $phoneVerification");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    http.Response response = await http.post(vendorVerifyURL, body: phoneVerification, headers: headers);

    return response;
  }

}