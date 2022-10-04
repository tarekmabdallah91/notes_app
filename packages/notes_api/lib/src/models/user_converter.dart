import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../notes_api.dart';

class UserConverter extends JsonConverter<User, String> {
  const UserConverter();
  @override
  // ignore: avoid_renaming_method_parameters
  User fromJson(String userStringJson) {
    final jsonDate = json.decode(userStringJson);
    return User.fromJson(jsonDate);
  }

  @override
  String toJson(User object) {
    return json.encode(object.toJson());
  }
}
