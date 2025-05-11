import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../entities/auth_response.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> register(User user);
  Future<Either<Failure, AuthResponse>> login(String username, String password);
  Future<Either<Failure, AuthResponse>> refreshToken(String refreshToken);
  Future<Either<Failure, User>> getUserProfile();
  Future<Either<Failure, User>> getUserProfileById(int id);
  Future<Either<Failure, String>> uploadPhoto(int id, File file);
  Future<Either<Failure, List<int>>> getPhoto(String filename);
  Future<Either<Failure, List<User>>> searchByImage(File image);
}