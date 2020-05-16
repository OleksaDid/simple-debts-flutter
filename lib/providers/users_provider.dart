import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/api_service_with_auth_headers.dart';
import 'package:simpledebts/models/user/user.dart';

class UsersProvider extends ApiServiceWithAuthHeaders with ChangeNotifier {

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
      request.headers.addAll(authHeaders);
      final response = await request.send();
      if(response.statusCode >= 400) {
        print('Image Upload faild');
        print(response.statusCode);
        return null;
      }
      return User.fromJson(jsonDecode(utf8.decode(await response.stream.toBytes())));
    } catch(error) {
      ErrorHelper.handleError(error);
    }
  }

  Future<List<User>> getUsers(String searchString) async {
    final url = '$baseUrl/users/?name=$searchString';
    final response = await get(url, headers: authHeaders);
    final List users = jsonDecode(response.body);
    return users.map((user) => User.fromJson(user)).toList();
  }

  Future<User> getUser(String id) async {
    final url = '$baseUrl/users/$id';
    final response = await get(url, headers: authHeaders);
    return User.fromJson(jsonDecode(response.body));
  }

  // TODO: push notifications
  Future<void> pushDeviceToken(String token) async {
    final url = '$baseUrl/users/push_tokens';
    final response = await post(url, headers: authHeaders, body: {
      'token': token
    });
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
  }

}