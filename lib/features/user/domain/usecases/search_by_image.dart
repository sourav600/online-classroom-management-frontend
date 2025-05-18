import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SearchByImage implements UseCase<List<User>, SearchByImageParams> {
  final UserRepository repository;

  SearchByImage(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(SearchByImageParams params) async {
    return await repository.searchByImage(params.image);
  }
}

class SearchByImageParams {
  final File image;

  SearchByImageParams({required this.image});
}
