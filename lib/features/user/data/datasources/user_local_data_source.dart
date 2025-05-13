import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';

abstract class UserLocalDataSource {
  Future<void> saveTokens(String jwt, String refreshToken);
  Future<String?> getToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final FlutterSecureStorage storage;

  UserLocalDataSourceImpl(this.storage);

  @override
  Future<void> saveTokens(String jwt, String refreshToken) async {
    try {
      await storage.write(key: 'jwt', value: jwt);
      await storage.write(key: 'refreshToken', value: refreshToken);
      Logger.log('Tokens saved');
    } catch (e) {
      Logger.error('Save tokens error', e);
      throw CacheException(e.toString());
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      final token = await storage.read(key: 'jwt');
      Logger.log('Retrieved token: $token');
      return token;
    } catch (e) {
      Logger.error('Get token error', e);
      throw CacheException(e.toString());
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      final refreshToken = await storage.read(key: 'refreshToken');
      Logger.log('Retrieved refresh token: $refreshToken');
      return refreshToken;
    } catch (e) {
      Logger.error('Get refresh token error', e);
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await storage.deleteAll();
      Logger.log('Tokens cleared');
    } catch (e) {
      Logger.error('Clear tokens error', e);
      throw CacheException(e.toString());
    }
  }
}
