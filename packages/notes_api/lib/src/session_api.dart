import '../notes_api.dart';

abstract class SessionApi {
  void saveUser(User user);
  User getUser();
  void deleteUser(User user);
}
