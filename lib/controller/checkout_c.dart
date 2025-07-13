import 'package:app_shoe/view/Home/profile/orders.dart';
import 'package:get/get.dart';
import 'package:app_shoe/model/address_m.dart';
import 'package:app_shoe/services/apiservice.dart';
import 'package:app_shoe/services/apiconstants.dart';
import 'package:app_shoe/controller/cart_c.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter/material.dart';

class CheckoutC extends GetxController {
  final ApiService _apiService = ApiService();
  final RxString selectedPaymentMethod = 'destination'.obs;
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

        // จัดการตาม payment method
        if (paymentMethod == 'destination') {
          // สำหรับ COD - ไม่มี session_url, ไปหน้ารายการ orders เลย
          final cartController = Get.find<CartC>();
          await cartController.clearCart();

          Get.snackbar(
            'ສຳເລັດ',
            'ການສັ່ງຊື້ສຳເລັດແລ້ວ ກະລຸນາຈ່າຍເງິນປາຍທາງ',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green[100],
            colorText: Colors.green[900],
            duration: Duration(seconds: 3),
          );

          await Future.delayed(Duration(seconds: 2));
          Get.to(() => OrdersPage());
        } else if (paymentMethod == 'card') {
          // สำหรับ card payment - เปิด Stripe session
          final returnedUrl = datas['session_url'];
          print('URL received: $returnedUrl');

          if (returnedUrl != null && returnedUrl.isNotEmpty) {
            try {
              bool launched = await launchUrlString(returnedUrl);
              final cartController = Get.find<CartC>();
              await cartController.clearCart();

              if (launched) {
                // เปิด Stripe ได้ → พาไปหน้ารอดำเนินการ
                await Future.delayed(Duration(milliseconds: 300));
                Get.to(() => OrdersPage());
              } else {
                Get.snackbar(
                  'Error',
                  'ບໍ່ສາມາດເປີດໜ້າຊຳລະເງິນໄດ້',
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
            Get.snackbar(
              'Error',
              'Payment session URL not received',
              snackPosition: SnackPosition.TOP,
            );
          }
        }
      } else if (response.statusCode == 400) {
        Get.snackbar(
          'ຂໍ້ຜິດພາດ',
          'ສິນຄ້າບາງລາຍບໍ່ພຽງພໍ ກະລຸນາກວດສອບການສັ່ງຊື້ຄືນ',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
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
