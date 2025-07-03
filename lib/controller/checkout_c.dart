import 'package:app_shoe/view/Home/orders.dart';
import 'package:get/get.dart';
import 'package:app_shoe/model/address_m.dart';
import 'package:app_shoe/services/apiservice.dart';
import 'package:app_shoe/services/apiconstants.dart';
import 'package:app_shoe/controller/cart_c.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CheckoutC extends GetxController {
  final ApiService _apiService = ApiService();
  final RxString selectedPaymentMethod = 'cod'.obs;
  final Rx<Address?> selectedAddress = Rx<Address?>(null);

  void updatePaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void updateSelectedAddress(Address address) {
    selectedAddress.value = address;
  }

  Future<void> processCheckout({
    required String paymentMethod,
    required int addressId,
    required num totalAmount,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final Map<String, dynamic> orderData = {
        "paymentMethode": paymentMethod,
        "Address_ID": addressId,
        "totalAmount": totalAmount,
        "items": items,
      };
      // print('Order Data: $orderData');
      final response = await _apiService.post(
        ApiConstants.checkoutEndpoint,
        data: orderData,
      );
      if (response.success) {
        final datas = response.data; // ไม่ต้อง jsonDecode แล้ว
        print('Response status: $datas');
        final returnedUrl = datas['session_url'];
        print('URL received: $returnedUrl');
        try {
          bool launched = await launchUrlString(returnedUrl);
          final cartController = Get.find<CartC>();
          await cartController.clearCart(); // ใช้ method ใหม่แทน (async)
          if (launched) {
            // เปิด Stripe ได้ → พาไปหน้ารอดำเนินการ
            await Future.delayed(Duration(seconds: 5));
            Get.off(() => OrdersPage());
          } else {
            Get.snackbar(
              'Error',
              'ไม่สามารถเปิดหน้าชำระเงินได้',
              snackPosition: SnackPosition.TOP,
            );
          }
        } catch (e) {
          print('Could not launch URL: $e');
          Get.snackbar(
            'Error',
            'Cannot open payment page. Please try again.',
            snackPosition: SnackPosition.TOP,
          );
        }
      } else {
        throw Exception(response.message ?? 'Failed to place order');
      }
    } catch (e) {
      print('Error placing order: $e');
      // Get.snackbar(
      //   'Error',
      //   'Failed to place order: ${e.toString()}',
      //   snackPosition: SnackPosition.TOP,
      // );
      Get.defaultDialog(
        title: 'Error',
        middleText: 'Failed to place order: ${e.toString()}',
        onConfirm: () {
          Get.back();
        },
        textConfirm: 'OK',
      );
    }
  }
}
