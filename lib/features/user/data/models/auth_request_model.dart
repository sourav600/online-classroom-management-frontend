import 'package:json_annotation/json_annotation.dart';

part 'auth_request_model.g.dart';

@JsonSerializable()
class AuthRequestModel {
  final String username;
  final String password;

  AuthRequestModel({
    required this.username,
    required this.password,
  });

  factory AuthRequestModel.fromJson(Map<String, dynamic> json) => _$AuthRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthRequestModelToJson(this);
}