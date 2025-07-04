import 'package:app_shoe/model/user_m.dart';
import 'package:app_shoe/services/apiconstants.dart';
import 'package:app_shoe/services/apiservice.dart';
import 'package:app_shoe/view/Home/profile/v_address.dart';
import 'package:app_shoe/view/Home/profile/profile.dart';
import 'package:get/get.dart';

class AccountC extends GetxController {
  // Observables
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  // Services
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  // Load user profile data
  Future<void> loadUserProfile() async {
    isLoading.value = true;

    try {
      final response = await _apiService.get(
        ApiConstants.getUserProfileEndpoint,
      );

      if (response.success) {
        currentUser.value = User.fromJson(response.data['data']);
      } else {
        print('Failed to load user profile: ${response.message}');
      }
    } catch (e) {
      print('Load user profile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void page_add_address() {
    Get.to(
      () => EditAddress(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  void navigateToProfile() {
    Get.to(
      () => const ProfilePage(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }
}
