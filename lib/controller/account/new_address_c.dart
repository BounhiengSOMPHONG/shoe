import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_shoe/services/apiservice.dart';
import 'package:app_shoe/services/apiconstants.dart';

class NewAddressC extends GetxController {
  final village = TextEditingController();
  final district = TextEditingController();
  final province = TextEditingController();
  final transportation = TextEditingController();
  final branch = TextEditingController();
  final isLoading = false.obs;

  final ApiService _apiService = ApiService();

  @override
  void onClose() {
    village.dispose();
    district.dispose();
    province.dispose();
    transportation.dispose();
    branch.dispose();
    super.onClose();
  }

  bool _validateInputs() {
    if (village.text.isEmpty ||
        district.text.isEmpty ||
        province.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter required fields (Village/Address, District, Province)',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  Future<void> saveAddress() async {
    if (!_validateInputs()) return;

    isLoading.value = true;
    try {
      final response = await _apiService.post(
        ApiConstants.insertAddressEndpoint,
        data: {
          'Village': village.text,
          'District': district.text,
          'Province': province.text,
          'Transportation': transportation.text,
          'Branch': branch.text,
        },
      );

      if (response.success) {
        Get.back(result: true);
        Get.snackbar(
          'Success',
          'Address added successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to save address',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Connection error',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
