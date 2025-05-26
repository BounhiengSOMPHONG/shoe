import 'package:app_shoe/model/address_m.dart';
import 'package:app_shoe/view/Home/profile/new_address.dart';
import 'package:app_shoe/services/apiservice.dart';
import 'package:app_shoe/services/apiconstants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressC extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<Address> addresses = <Address>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    isLoading.value = true;
    try {
      final response = await _apiService.post(
        ApiConstants.showAddressEndpoint,
        data: {},
      );
      if (response.success) {
        final List<dynamic> addressData = response.data['data'];
        addresses.value =
            addressData.map((data) => Address.fromJson(data)).toList();
      }
      print('Fetched addresses: ${response}');
    } catch (e) {
      _showError('Could not fetch addresses');
    } finally {
      isLoading.value = false;
    }
  }

  void addNewAddress() async {
    final result = await Get.to(() => const NewAddress());
    if (result == true) {
      fetchAddresses();
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
