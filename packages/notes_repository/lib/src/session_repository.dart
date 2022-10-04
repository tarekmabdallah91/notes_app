import 'package:notes_api/notes_api.dart';

class SessionRepository {
  final SessionApi _sessionApi;

  SessionRepository(this._sessionApi);

  void saveUser(User user) => _sessionApi.saveUser(user);
  User getUser() => _sessionApi.getUser();
  void deleteUser(User user) => _sessionApi.deleteUser(user);
}
