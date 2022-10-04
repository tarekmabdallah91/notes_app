part of 'local_storage_session.dart';

class SessionSharedPreferences {
  final SharedPreferences _sharedPreferences;

  SessionSharedPreferences(this._sharedPreferences);

  /// The key used for storing the Notes locally.
  /// This is only exposed for testing and shouldn't be used by consumers of
  /// this library.
  @visibleForTesting
  static const kNotesCollectionKey = '__Notes_collection_key__';


  String? getValue(String key) => _sharedPreferences.getString(key);
  Future<void> setValue(String key, String value) =>
      _sharedPreferences.setString(key, value);

  void init() {
    
  }
}
