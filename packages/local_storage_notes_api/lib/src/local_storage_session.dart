import 'dart:async';
import 'package:meta/meta.dart';
import 'package:notes_api/notes_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'session_shared_preferences.dart';

class LocalStorageSession extends SessionApi {
  LocalStorageSession({
    required SharedPreferences plugin,
  }) : _plugin = SessionSharedPreferences(plugin) {
    _init();
  }

  static const sessionCollectionKey = '__session_collection_key__';

  final SessionSharedPreferences _plugin;

  void _init() {
    _plugin.init();
  }

  @override
  void saveUser(User user) {
    _plugin.setValue(sessionCollectionKey, UserConverter().toJson(user));
  }

  @override
  void deleteUser(User user) {
    _plugin.setValue(sessionCollectionKey,
        UserConverter().toJson(user.copyWith(id: '', token: '')));
  }

  @override
  User getUser() {
    return UserConverter().fromJson(_plugin.getValue(sessionCollectionKey)!);
  }
}
