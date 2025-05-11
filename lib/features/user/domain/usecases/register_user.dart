import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class RegisterUser implements UseCase<User, RegisterParams> {
  final UserRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(params.user);
  }
}

class RegisterParams {
  final User user;

  RegisterParams({required this.user});
}