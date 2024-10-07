import 'package:hive/hive.dart';

class LocalDB {
  static late Box loginBox; // Declare the Box variable without initializing

  // Call this method during app initialization
  static Future<void> init() async {
    loginBox = await Hive.openBox('loginBox'); // Initialize the Box
  }

  static Future<void> postLoginInfo({
    required String email,
    required String password,
  }) async {
    await loginBox.put('email', email);
    await loginBox.put('password', password);
    await loginBox.put('isLoggedIn', true);

    print('Stored login info in loginBox box.');
  }

  static Future<Map<String, String>?> getLoginInfo() async {
    final email = loginBox.get('email', defaultValue: '');
    final password = loginBox.get('password', defaultValue: '');
    final isLoggedIn = loginBox.get('isLoggedIn', defaultValue: false);

    return {
      'email': email,
      'password': password,
      // 'isLoggedIn': isLoggedIn,

    };
  }

  static Future<void> delLoginInfo() async {
    await loginBox.clear();
    print('Cleared login info from loginBox box.$loginBox');
  }
}


//for mobile
// class LocalDB {
//   static const String loginBox = 'loginBox';
//
//   //! POST Login Information
//   static Future<void> postLoginInfo({
//     required String email,
//     required String password,
//   }) async {
//     final box = await Hive.openBox(loginBox); // Opens the box for access
//     box.put(loginBox, [email, password]);     // Stores the data as a list
//     print('Stored login info in $loginBox box.');
//   }
//
//
//   //! GET Login Information
//   static Future<List<String>?> getLoginInfo() async {
//     final box = await Hive.openBox(loginBox);  // Opens the box for access
//     final info = box.get(loginBox) as List<dynamic>?;  // Retrieves the data
//
//     // Converts List<dynamic> to List<String>
//     if (info != null) {
//       return info.map((e) => e.toString()).toList();
//     }
//     return null; // Return null if no data found
//   }
//
//
//   //! DEL Login Information
//   static Future<void> delLoginInfo() async {
//     final box = await Hive.openBox(loginBox); // Opens the box for access
//     await box.clear();                        // Clears the box
//     print('Cleared login info from $loginBox box.');
//   }
//
// }
