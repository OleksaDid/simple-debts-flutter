import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/api_service_with_auth_headers.dart';
import 'package:simpledebts/models/user/user.dart';

class UsersProvider extends ApiServiceWithAuthHeaders with ChangeNotifier {

  Future<User> updateUserData(String name, File image) async {
    try {
      final url = '/users';
      final Map<String, dynamic> formDataMap = {
        'name': name
      };

      if(image != null) {
        final extension = image.path.split('.').last;
        formDataMap.addAll({
          'image': await MultipartFile.fromFile(image.path, contentType: MediaType('image', extension))
        });
      }

      final formData = FormData.fromMap(formDataMap);
      final response = await http().post(url, data: formData);
      if(response.statusCode >= 400) {
        print('Image Upload faild');
        print(response.statusCode);
        return null;
      }
      return User.fromJson(response.data);
    } catch(error) {
      ErrorHelper.handleError(error);
    }
  }

  Future<List<User>> getUsers(String searchString) async {
    final url = '/users/?name=$searchString';
    final response = await http().get(url);
    final List users = response.data;
    return users.map((user) => User.fromJson(user)).toList();
  }

  Future<User> getUser(String id) async {
    final url = '/users/$id';
    final response = await http().get(url);
    return User.fromJson(response.data);
  }

  // TODO: push notifications
  Future<void> pushDeviceToken(String token) async {
    final url = '/users/push_tokens';
    final response = await http().post(url, data: {
      'token': token
    });
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
  }

}