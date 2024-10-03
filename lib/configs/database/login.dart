import 'package:hive/hive.dart';

class LocalDB {
  static const String loginBox = 'loginBox';

  //! POST Login Information
  static Future<void> postLoginInfo({
    required String email,
    required String password,
  }) async {
    final box = await Hive.openBox(loginBox); // Opens the box for access
    box.put(loginBox, [email, password]);     // Stores the data as a list
    print('Stored login info in $loginBox box.');
  }


  //! GET Login Information
  static Future<List<String>?> getLoginInfo() async {
    final box = await Hive.openBox(loginBox);  // Opens the box for access
    final info = box.get(loginBox) as List<dynamic>?;  // Retrieves the data

    // Converts List<dynamic> to List<String>
    if (info != null) {
      return info.map((e) => e.toString()).toList();
    }
    return null; // Return null if no data found
  }


  //! DEL Login Information
  static Future<void> delLoginInfo() async {
    final box = await Hive.openBox(loginBox); // Opens the box for access
    await box.clear();                        // Clears the box
    print('Cleared login info from $loginBox box.');
  }

}
