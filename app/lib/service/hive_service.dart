import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  addAllBox<T>(Box<T> box, T value, String key) async {
    await box.put(key, value);
  }

  addOnBoxViaKey<T>(Box<T> box, String key, T value) async {
    await box.put(key, value);
  }

  T? getData<T>(Box<T> box, String index) {
    return box.get(index);
  }

  deleteBox<T>(Box<T> box) async {
    await box.deleteFromDisk();
  }

  deleteBoxField<T>(Box<T> box, String key) async {
    await box.delete(key);
  }

  updateBoxField<T>(Box<T> box, String key, T newValue) async {
    T? user = getData(box, key);
    if (user != null) {
      addAllBox(box, newValue, key);
    }
  }
}
