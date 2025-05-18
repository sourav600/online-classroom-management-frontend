import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class GetPhoto implements UseCase<List<int>, GetPhotoParams> {
  final UserRepository repository;

  GetPhoto(this.repository);

  @override
  Future<Either<Failure, List<int>>> call(GetPhotoParams params) async {
    return await repository.getPhoto(params.filename);
  }
}

class GetPhotoParams {
  final String filename;

  GetPhotoParams({required this.filename});
}
