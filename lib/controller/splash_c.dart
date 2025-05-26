import 'package:app_shoe/view/Home/layout.dart';
import 'package:app_shoe/view/Login/login.dart';
import 'package:app_shoe/view/onBoarding/onboard.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashC extends GetxController {
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedIdentifier = prefs.getString('identifier');
    isLoggedIn.value = savedIdentifier != null && savedIdentifier.isNotEmpty;
  }

  Future<void> loadView() async {
    await Future.delayed(const Duration(seconds: 2));
    print('isLoggedIn: ${isLoggedIn.value}');
    if (!isLoggedIn.value) {
      Get.off(Onboard());
    } else {
      // Get.off(Login());
      Get.off(Layout());
    }
  }
}
