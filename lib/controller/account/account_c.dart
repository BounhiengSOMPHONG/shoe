import 'package:app_shoe/view/Home/pendingpayment.dart';
import 'package:app_shoe/view/Home/profile/v_address.dart';
import 'package:get/get.dart';

class AccountC extends GetxController {
  void page_add_address() {
    Get.to(
      () => EditAddress(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  void page_history() {
    Get.to(
      () => Pendingpayment(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }
}
