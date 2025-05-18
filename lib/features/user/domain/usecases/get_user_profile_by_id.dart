import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserProfileById implements UseCase<User, GetUserProfileByIdParams> {
  final UserRepository repository;

  GetUserProfileById(this.repository);

  @override
  Future<Either<Failure, User>> call(GetUserProfileByIdParams params) async {
    return await repository.getUserProfileById(params.id);
  }
}

class GetUserProfileByIdParams {
  final int id;

  GetUserProfileByIdParams({required this.id});
}
