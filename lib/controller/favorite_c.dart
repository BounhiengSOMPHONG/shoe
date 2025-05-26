import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/product_m.dart';
import '../services/apiconstants.dart';
import '../services/apiservice.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FavoriteC extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<PItem> favoriteItems = <PItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString userId = ''.obs;
  @override
  void onInit() {
    super.onInit();
    initUserId();
  }

  Future<void> initUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString('userId') ?? '';
    if (userId.value.isNotEmpty) {
      fetchFavorites();
    } else {
      debugPrint('No User ID found in SharedPreferences');
    }
  }

  Future<void> fetchFavorites() async {
    if (isLoading.value) return;
    if (userId.value.isEmpty) {
      error.value = 'Please login first';
      return;
    }

    isLoading.value = true;
    error.value = '';
    EasyLoading.show(status: 'Loading favorites...');

    try {
      final response = await _apiService.post(
        '${ApiConstants.showWishlistEndpoint}',
        data: {},
      );
      debugPrint('Response: ${response.data}');
      if (response.success) {
        if (response.data != null && response.data['data'] != null) {
          List<PItem> products =
              (response.data['data'] as List).map((item) {
                return PItem(
                  id: double.tryParse(item['Product_ID']?.toString() ?? '0'),
                  name: item['Name'] as String?,
                  price: double.tryParse(item['Price']?.toString() ?? '0'),
                  image: item['Image'] as String?,
                );
              }).toList();
          favoriteItems.clear();
          favoriteItems.addAll(products);
        } else {
          favoriteItems.clear();
        }
      } else {
        error.value = response.message ?? 'Failed to fetch favorites';
      }
    } catch (e) {
      error.value = 'Error fetching favorites: $e';
      print('Error fetching favorites: $e');
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
      update();
    }
  }

  Future<void> toggleFavorite(PItem item) async {
    if (userId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please login first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    try {
      EasyLoading.show(status: 'Updating...');

      if (favoriteItems.any((fav) => fav.id == item.id)) {
        // Remove from favorites
        final response = await _apiService.post(
          '${ApiConstants.removeFromWishlistEndpoint}${item.id}',
          data: {'Product_ID': item.id},
        );

        if (response.success) {
          favoriteItems.removeWhere((fav) => fav.id == item.id);
        } else {
          throw Exception(
            response.message ?? 'Failed to remove from favorites',
          );
        }
      } else {
        // Add to favorites
        final response = await _apiService.post(
          ApiConstants.addToWishlistEndpoint,
          data: {'User_ID': userId.value, 'Product_ID': item.id},
        );

        if (response.success) {
          favoriteItems.add(item);
        } else {
          throw Exception(response.message ?? 'Failed to add to favorites');
        }
      }
      update();
    } catch (e) {
      print('Error toggling favorite: $e');
      Get.snackbar(
        'Error',
        'Failed to update favorites: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  bool isFavorite(num? productId) {
    if (productId == null) return false;
    return favoriteItems.any((item) => item.id == productId);
  }
}
