import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/role.dart';

part 'role_model.g.dart';

@JsonSerializable()
class RoleModel extends Role {
  RoleModel({
    required int id,
    required String name,
    required String authority,
  }) : super(id: id, name: name, authority: authority);

  factory RoleModel.fromJson(Map<String, dynamic> json) => _$RoleModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoleModelToJson(this);
}