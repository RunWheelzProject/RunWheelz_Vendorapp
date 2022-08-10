import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/src/change_notifier_provider.dart';
import 'package:untitled/manager/manager.dart';


typedef CallBack = Widget Function(http.Response response);

class FutureManager {

  static String? goToNextScreen(BuildContext context, var response, int statusCode, Widget screen) {
    var responseJson = jsonDecode(response.body);
    log("responseJson: $responseJson");
    if (response.statusCode == statusCode) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return screen;
      }));
    }
    var messageMap = responseJson as Map;
    if (messageMap.containsKey("message")) {
      return messageMap["message"];
    }
    return null;
  }
}

