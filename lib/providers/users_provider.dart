import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:simpledebts/helpers/env_helper.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/models/user.dart';

class UsersProvider with ChangeNotifier {
  final String baseUrl = EnvHelper.env.API_URL;
  Map<String, String> _authHeaders;

  void setupAuthHeader(Map<String, String> headers) {
    _authHeaders = headers;
  }

  Future<User> updateUserData(String name, File image) async {
    try {
      final url = '$baseUrl/users';
      final request = MultipartRequest('POST', Uri.parse(url));
      if(image != null) {
        final extension = image.path.split('.').last;
        final multipartFile = await MultipartFile.fromPath(
            'image',
            image.path,
            contentType: MediaType('image', extension)
        );
        request.files.add(multipartFile);
      }
      request.fields.addAll({
        'name': name
      });
      request.headers.addAll(_authHeaders);
      final response = await request.send();
      if(response.statusCode >= 400) {
        print('Image Upload faild');
        print(response.statusCode);
      }
      return User.fromJson(jsonDecode(utf8.decode(await response.stream.toBytes())));
    } catch(error) {
      ErrorHelper.handleError(error);
    }
  }

}