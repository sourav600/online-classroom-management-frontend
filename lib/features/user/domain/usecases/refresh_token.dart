import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_response.dart';
import '../repositories/user_repository.dart';

class RefreshToken implements UseCase<AuthResponse, RefreshTokenParams> {
  final UserRepository repository;

  RefreshToken(this.repository);

  @override
  Future<Either<Failure, AuthResponse>> call(RefreshTokenParams params) async {
    return await repository.refreshToken(params.refreshToken);
  }
}

class RefreshTokenParams {
  final String refreshToken;

  RefreshTokenParams({required this.refreshToken});
}
