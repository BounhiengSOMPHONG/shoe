import 'dart:math';

import 'package:app_shoe/view/Home/cart.dart';
import 'package:app_shoe/view/Home/layout.dart';
import 'package:get/get.dart';
import 'package:app_shoe/model/address_m.dart';
import 'package:app_shoe/services/apiservice.dart';
import 'package:app_shoe/services/apiconstants.dart';
import 'package:app_shoe/controller/cart_c.dart';

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
      print('Order Data: $orderData');
      final response = await _apiService.post(
        ApiConstants.checkoutEndpoint,
        data: orderData,
      );
      if (response.success) {
        print('Order placed successfully: ${response.data}');
        final cartController = Get.find<CartC>();
        cartController.items.clear();
        await cartController.saveCartItems(); // Save empty cart to storage
        Get.snackbar(
          'Success',
          'Order placed successfully',
          snackPosition: SnackPosition.TOP,
        );
        Get.offAll(() => Layout());
      } else {
        throw Exception(response.message ?? 'Failed to place order');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to place order: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
