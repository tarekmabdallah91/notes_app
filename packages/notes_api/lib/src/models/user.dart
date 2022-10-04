import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  final String id;
  final String token;

 User({required this.id, required this.token});

  @override
  List<Object?> get props => [id, token];

  User copyWith({
    String? id,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      token: token ?? this.token,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User{id: $id\ntoken: $token}';
  }
}
