import 'dart:io';
import 'package:dartz/dartz.dart';
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
  Future<Either<Failure, List<int>>> getPhoto(String filename) {
    // TODO: implement getPhoto
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> getUserProfile() {
    // TODO: implement getUserProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> getUserProfileById(int id) {
    // TODO: implement getUserProfileById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AuthResponse>> refreshToken(String refreshToken) {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<User>>> searchByImage(File image) {
    // TODO: implement searchByImage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(int id, File file) {
    // TODO: implement uploadPhoto
    throw UnimplementedError();
  }
}
