import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:online_classroom_frontend/core/error/exceptions.dart';
import 'package:online_classroom_frontend/core/utils/constants.dart';
import 'package:online_classroom_frontend/core/utils/logger.dart';
import 'package:online_classroom_frontend/features/user/data/models/auth_response_model.dart';
import 'package:online_classroom_frontend/features/user/data/models/refresh_token_request_model.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> register(UserModel user);
  Future<AuthResponseModel> login(String username, String password);
  Future<AuthResponseModel> refreshToken(String refreshToken);
  Future<UserModel> getUserProfile();
  Future<UserModel> getUserProfileById(int id);
  Future<String> uploadPhoto(int id, File file);
  Future<List<int>> getPhoto(String filename);
  Future<List<UserModel>> searchByImage(File image);
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
        Uri.parse('${Constants.baseUrl}/api/user/register'),
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
        Uri.parse('${Constants.baseUrl}/api/user/login'),
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

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    try {
      final response = await client.post(
        Uri.parse('${Constants.baseUrl}/api/user/refresh'),
        headers: await _getHeaders(),
        body: jsonEncode(
            RefreshTokenRequestModel(refreshToken: refreshToken).toJson()),
      );
      Logger.log('Refresh token response: ${response.statusCode}');
      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw ServerException('Refresh token failed: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('Refresh token error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final response = await client.get(
        Uri.parse('${Constants.baseUrl}/api/user/profile'),
        headers: await _getHeaders(),
      );
      Logger.log('Get profile response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw ServerException('Get profile failed: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('Get profile error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getUserProfileById(int id) async {
    try {
      final response = await client.get(
        Uri.parse('${Constants.baseUrl}/api/user/profile/$id'),
        headers: await _getHeaders(),
      );
      Logger.log('Get profile by ID response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw ServerException(
            'Get profile by ID failed: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('Get profile by ID error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadPhoto(int id, File file) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Constants.baseUrl}/api/user/photo'),
      );
      request.headers.addAll(await _getHeaders());
      request.fields['id'] = id.toString();
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      Logger.log('Upload photo response: ${response.statusCode}');
      if (response.statusCode == 200) {
        return responseBody;
      } else {
        throw ServerException('Upload photo failed: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('Upload photo error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<int>> getPhoto(String filename) async {
    try {
      final response = await client.get(
        Uri.parse('${Constants.baseUrl}/api/user/photo/$filename'),
        headers: await _getHeaders(),
      );
      Logger.log('Get photo response: ${response.statusCode}');
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw ServerException('Get photo failed: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('Get photo error', e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<UserModel>> searchByImage(File image) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Constants.baseUrl}/api/user/search-by-image'),
      );
      request.headers.addAll(await _getHeaders());
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      Logger.log('Search by image response: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(responseBody);
        return json.map((data) => UserModel.fromJson(data)).toList();
      } else {
        throw ServerException('Search by image failed: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('Search by image error', e);
      throw ServerException(e.toString());
    }
  }
}
