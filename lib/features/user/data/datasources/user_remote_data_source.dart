import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:online_classroom_frontend/core/error/exceptions.dart';
import 'package:online_classroom_frontend/core/utils/constants.dart';
import 'package:online_classroom_frontend/core/utils/logger.dart';
import 'package:online_classroom_frontend/features/user/data/models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> register(UserModel user);
  Future<AuthResponseModel> login(String username, String password);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final String? token;

  UserRemoteDataSourceImpl(this.client, {this.token});

  Future<Map<String, String>> _getHeaders() async {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  @override
  Future<UserModel> register(UserModel user) async {
    try {
      final response = await client.post(
        Uri.parse('${Constants.baseUrlLocalhost}/api/user/register'),
        headers: await _getHeaders(),
        body: jsonEncode(user.toJson()),
      );
      Logger.log('Register response: ${response.statusCode}');
      if (response.statusCode == 201) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw ServerException('Register failed: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('Register error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthResponseModel> login(String username, String password) async {
    try {
      final response = await client.post(
        Uri.parse('${Constants.baseUrlLocalhost}/api/user/login'),
        headers: await _getHeaders(),
        body: jsonEncode({'username': username, 'password': password}),
      );
      Logger.log('Login response: ${response.statusCode}');
      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw ServerException('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('Login error', e);
      throw ServerException(e.toString());
    }
  }
}
