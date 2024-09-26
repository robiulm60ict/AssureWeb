import 'package:hive/hive.dart';

class LocalDB {
  static const String loginBox = 'loginBox';

  //!POST Login Information
  static Future<void> postLoginInfo({required String email, required String password}) async {
    final box = await Hive.openBox(loginBox);
    box.put(loginBox, [
      email,
      password,
    ]);
  }

  //!Get Login Information
  static Future<List<String>?> getLoginInfo() async{
    final box = await Hive.openBox(loginBox);
    final info = box.get(loginBox);
    return info;
  }

  //!DEL Login Information
  static Future<void> delLoginInfo() async {
    final box = await Hive.openBox(loginBox);
    await box.clear();
  }
}