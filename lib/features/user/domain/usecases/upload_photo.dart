import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class UploadPhoto implements UseCase<String, UploadPhotoParams> {
  final UserRepository repository;

  UploadPhoto(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadPhotoParams params) async {
    return await repository.uploadPhoto(params.id, params.file);
  }
}

class UploadPhotoParams {
  final int id;
  final File file;

  UploadPhotoParams({required this.id, required this.file});
}
