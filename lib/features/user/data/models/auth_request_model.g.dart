// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRequestModel _$AuthRequestModelFromJson(Map<String, dynamic> json) =>
    AuthRequestModel(
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$AuthRequestModelToJson(AuthRequestModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };
