import 'package:hive/hive.dart';

class LocalDB {
  static const String loginBox = 'loginBox';

  //! POST Login Information
  static Future<void> postLoginInfo({
    required String email,
    required String password,
  }) async {
    final box = await Hive.openBox(loginBox);
    box.put(loginBox, [email, password]);
    print('Stored login info in $loginBox box.');
  }

  //! GET Login Information
  static Future<List<String>?> getLoginInfo() async {
    final box = await Hive.openBox(loginBox);
    final info = box.get(loginBox) as List<dynamic>?; // Cast to List<dynamic>

    // Convert List<dynamic> to List<String>
    if (info != null) {
      return info.map((e) => e.toString()).toList(); // Ensure all elements are String
    }
    return null; // Return null if info is null
  }

  //! DEL Login Information
  static Future<void> delLoginInfo() async {
    final box = await Hive.openBox(loginBox);
    await box.clear();
    print('Cleared login info from $loginBox box.');
  }
}
