import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../exceptions/app_exceptions.dart';
import '../model/otp_response.dart';
import '../resources/resources.dart' as res;


class PhoneVerificationService {


  Future<VendorOtpResponse> sendOtp(int phoneNumber, String? deviceToken, String urlType) async {
    Uri vendorSendOtpURL = Uri.parse("${urlType}phoneNumber=91${phoneNumber}&deviceToken=${deviceToken}");
    log("_vendorSendOtpURL: $vendorSendOtpURL");

    http.Response response = await http.get(vendorSendOtpURL);
    var responseJson = jsonDecode(response.body);
    log("responseJson: $responseJson");

    if (response.statusCode == 200) {
      log("responseJsonVal: $responseJson");
      VendorOtpResponse vendorOtpResponse = VendorOtpResponse(phoneNumber: responseJson["phoneNumber"],
          verificationRef: responseJson["verificationRef"], statusMessage: responseJson["statusMessage"]);

      return vendorOtpResponse;
    }

    throw OTPException(responseJson["message"]);
  }

  Future<http.Response> verifyOtp(String phoneVerification, String urlType) async {
    Uri vendorVerifyURL = Uri.parse(urlType);
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