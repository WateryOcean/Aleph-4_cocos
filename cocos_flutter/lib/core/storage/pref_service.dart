import 'package:shared_preferences/shared_preferences.dart';
 
class PrefService {
  PrefService._();
  static final PrefService instance = PrefService._();
 
  late final SharedPreferences prefs;
 
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }
}