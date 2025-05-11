import 'package:json_annotation/json_annotation.dart';

part 'error_details_model.g.dart';

@JsonSerializable()
class ErrorDetailsModel {
  final String message;

  ErrorDetailsModel({required this.message});

  factory ErrorDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorDetailsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorDetailsModelToJson(this);
}