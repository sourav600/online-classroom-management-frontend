import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/auth_response.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel extends AuthResponse {
  AuthResponseModel({
    required String jwt,
    required String refreshToken,
  }) : super(jwt: jwt, refreshToken: refreshToken);

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}