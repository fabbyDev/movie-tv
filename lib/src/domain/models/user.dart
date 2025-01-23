import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'username')
  final String username;

  const User({required this.id, required this.username});

  @override
  List<Object?> get props => [id, username];

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJSON() => _$UserToJson(this);
}
