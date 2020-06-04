import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/http_auth_service_use.dart';
import 'package:simpledebts/models/user/user.dart';

class UsersService with HttpAuthServiceUse {

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
      final response = await http.post(url, data: formData);

      return User.fromJson(response.data);
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

  Future<List<User>> getUsers(String searchString) async {
    try {
      final url = '/users/?name=$searchString';
      final response = await http.get(url);
      final List users = response.data;
      return users.map((user) => User.fromJson(user)).toList();
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

  Future<User> getUser(String id) async {
    try {
      final url = '/users/$id';
      final response = await http.get(url);
      return User.fromJson(response.data);
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

  // TODO: push notifications
  Future<void> pushDeviceToken(String token) async {
    try {
      final url = '/users/push_tokens';
      await http.post(url, data: {
        'token': token
      });
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

}