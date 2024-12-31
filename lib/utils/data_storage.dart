import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DataStorage {
  static final DataStorage _instance = DataStorage._();

  factory DataStorage() => _instance;

  DataStorage._();

  FlutterSecureStorage storage = const FlutterSecureStorage();

  static void removeAll() {
    _instance.storage.deleteAll();
  }

  static void remove(String key) {
    _instance.storage.delete(key: key);
  }

  static void put({required String key, required String value}) {
    _instance.storage.write(key: key, value: value);
  }

  static void addListener(String key, Function listener) {
    _instance.storage.registerListener(key: key, listener:(arg){
      listener(arg);
    });
  }

  static Future<String> get(String key) async {
    if (await contains(key)) {
      final value = await _instance.storage.read(key: key);
      return value!;
    }
    return '';
  }

  static Future<bool> contains(String key) async {
    final value = await _instance.storage.read(key: key);
    if (value == null || value.isEmpty) {
      return false;
    }
    return true;
  }
}
