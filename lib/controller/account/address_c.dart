import 'package:app_shoe/model/address_m.dart';
import 'package:app_shoe/view/Home/profile/new_address.dart';
import 'package:app_shoe/view/Home/profile/edit_address.dart';
import 'package:app_shoe/services/apiservice.dart';
import 'package:app_shoe/services/apiconstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  void editAddress(Address address) async {
    final result = await Get.to(() => EditAddressPage(address: address));
    if (result == true) {
      fetchAddresses();
    }
  }

  Future<void> updateAddress(Address address, Map<String, dynamic> data) async {
    EasyLoading.show(status: 'Updating address...');
    try {
      final response = await _apiService.post(
        '${ApiConstants.editAddressEndpoint}/${address.id}',
        data: data,
      );

      if (response.success) {
        _showSuccess('Address updated successfully');
        Get.back(result: true);
      } else {
        _showError(response.message ?? 'Failed to update address');
      }
    } catch (e) {
      _showError('Connection error. Please try again.');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> deleteAddress(Address address) async {
    // Show confirmation dialog
    bool confirmDelete =
        await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Delete Address'),
            content: Text(
              'Are you sure you want to delete this address?\n\n${address.village}, ${address.district}, ${address.province}',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmDelete) return;

    EasyLoading.show(status: 'Deleting address...');
    try {
      final response = await _apiService.delete(
        '${ApiConstants.deleteAddressEndpoint}/${address.id}',
      );

      if (response.success) {
        _showSuccess('Address deleted successfully');
        fetchAddresses(); // Refresh the list
      } else {
        _showError(response.message ?? 'Failed to delete address');
      }
    } catch (e) {
      _showError('Connection error. Please try again.');
    } finally {
      EasyLoading.dismiss();
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

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
