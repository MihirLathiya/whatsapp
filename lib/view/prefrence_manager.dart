import 'package:get_storage/get_storage.dart';

class PrefrenceManager {
  static GetStorage getStorage = GetStorage();

  /// Name
  static Future setName(String name) async {
    await getStorage.write("name", name);
  }

  static getName() {
    return getStorage.read("name");
  }

  static removeName() {
    return getStorage.remove("name");
  }

  /// Number
  static Future setNumber(String name) async {
    await getStorage.write("number", name);
  }

  static getNumber() {
    return getStorage.read("number");
  }

  static removeNumber() {
    return getStorage.remove("number");
  }

  /// Image
  static Future setImage(String name) async {
    await getStorage.write("image", name);
  }

  static getImage() {
    return getStorage.read("image");
  }

  static removeImage() {
    return getStorage.remove("image");
  }

  /// Fcm Token
  static Future setToken(String name) async {
    await getStorage.write("Fcm", name);
  }

  static getToken() {
    return getStorage.read("Fcm");
  }

  static removeToken() {
    return getStorage.remove("Fcm");
  }
}
