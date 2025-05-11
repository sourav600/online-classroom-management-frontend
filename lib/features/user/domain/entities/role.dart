import 'package:equatable/equatable.dart';

class Role extends Equatable{
  final int id;
  final String name;
  final String authority;

  Role({
    required this.id,
    required this.name,
    required this.authority,
  });

  @override
  List<Object> get props => [id, name, authority];
}