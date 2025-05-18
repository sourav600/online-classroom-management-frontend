import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:online_classroom_frontend/core/error/exceptions.dart';
import 'package:online_classroom_frontend/core/error/failures.dart';
import 'package:online_classroom_frontend/features/user/data/datasources/user_local_data_source.dart';
import 'package:online_classroom_frontend/features/user/domain/entities/auth_response.dart';
import 'package:online_classroom_frontend/features/user/domain/repositories/user_repository.dart';
import '../../../../core/network/network_info.dart';
import 'package:online_classroom_frontend/features/user/data/datasources/user_remote_data_source.dart';
import 'package:online_classroom_frontend/features/user/data/models/user_model.dart';
import 'package:online_classroom_frontend/features/user/domain/entities/user.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSourceImpl remoteDataSource;
  final UserLocalDataSourceImpl localDataSource;
  final NetworkInfo networkInfo;
  final client = Get.find<http.Client>();

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> register(User user) async {
    if (await networkInfo.isConnected) {
      try {
        final Set<String> roleNames =
            user.roles.map((role) => role.name).toSet();

        final userModel = UserModel(
          firstName: user.firstName,
          lastName: user.lastName,
          currentInstitute: user.currentInstitute,
          country: user.country,
          gender: user.gender,
          roleNames: roleNames,
          profilePicture: user.profilePicture,
          username: user.username,
          email: user.email,
          password: user.password,
        );
        final result = await remoteDataSource.register(userModel);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> login(
      String username, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.login(username, password);
        await localDataSource.saveTokens(result.jwt, result.refreshToken);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> refreshToken(
      String refreshToken) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.refreshToken(refreshToken);
        await localDataSource.saveTokens(result.jwt, result.refreshToken);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getToken();
        final remoteDataSourceWithToken =
            UserRemoteDataSourceImpl(client, token: token);
        final result = await remoteDataSourceWithToken.getUserProfile();
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getUserProfileById(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getToken();
        final remoteDataSourceWithToken =
            UserRemoteDataSourceImpl(client, token: token);
        final result = await remoteDataSourceWithToken.getUserProfileById(id);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(int id, File file) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getToken();
        final remoteDataSourceWithToken =
            UserRemoteDataSourceImpl(client, token: token);
        final result = await remoteDataSourceWithToken.uploadPhoto(id, file);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<int>>> getPhoto(String filename) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getToken();
        final remoteDataSourceWithToken =
            UserRemoteDataSourceImpl(client, token: token);
        final result = await remoteDataSourceWithToken.getPhoto(filename);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<User>>> searchByImage(File image) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getToken();
        final remoteDataSourceWithToken =
            UserRemoteDataSourceImpl(client, token: token);
        final result = await remoteDataSourceWithToken.searchByImage(image);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
