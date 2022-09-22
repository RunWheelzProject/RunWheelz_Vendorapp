import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';


import '../model/user_image_dto.dart';
import '../resources/resources.dart' as res;


class UserImageService {

  final String _uploadImageURL = "${res.APP_URL}/api/image/image-upload";
  final String _getImageURL = "${res.APP_URL}/api/image/get-image/";

  Future<String> uploadImage(File file) async {
    log("filePath: ${file.path}");
    Uri uri = Uri.parse(_uploadImageURL);

    var request = http.MultipartRequest("POST", uri);
    request.files.add(http.MultipartFile(
        'image',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: path.basename(file.path), contentType: MediaType('image', 'jpg')
    ),);
    request.send().then((response) {
      if (response.statusCode == 200) return "image uploaded";
    });

    throw Exception("image uploaded failed");

  }

  Future<UserImageDTO> getImage(int id) async {

    Uri uri = Uri.parse("$_getImageURL/$id");

    http.Response response = await http.get(uri);

    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return UserImageDTO.fromJson(jsonResponse);
    }

    throw Exception("server response failed");
  }
}