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
    final token = prefs.getString('token') ?? '';

    if (userId.value.isNotEmpty && token.isNotEmpty) {
      fetchFavorites();
    } else {
      debugPrint('No User ID or token found in SharedPreferences');
    }
  }

  Future<void> fetchFavorites() async {
    if (isLoading.value) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      error.value = 'กະລຸນາເຂົ້າສູ່ລະບົບກ່ອນ';
      return;
    }

    isLoading.value = true;
    error.value = '';
    EasyLoading.show(status: 'ກຳລັງໂຫຼດລາຍການທີ່ມັກ...');

    try {
      final response = await _apiService.post(
        ApiConstants.showWishlistEndpoint,
        data: {}, // Backend ใช้ userId จาก JWT token
      );

      debugPrint('Wishlist Response: ${response.data}');

      if (response.success) {
        if (response.data != null && response.data['data'] != null) {
          List<PItem> products =
              (response.data['data'] as List).map((item) {
                return PItem(
                  id: double.tryParse(item['Product_ID']?.toString() ?? '0'),
                  name: item['Name'] as String?,
                  price: double.tryParse(item['Price']?.toString() ?? '0'),
                  image: item['Image'] as String?,
                  brand: item['Brand'] as String?,
                  description: item['Description'] as String?,
                );
              }).toList();

          favoriteItems.clear();
          favoriteItems.addAll(products);
          debugPrint('Loaded ${products.length} favorite items');
        } else {
          favoriteItems.clear();
          debugPrint('No favorite items found');
        }
      } else {
        error.value = response.message ?? 'ບໍ່ສາມາດໂຫຼດລາຍການທີ່ມັກໄດ້';
        debugPrint('Error: ${response.message}');
      }
    } catch (e) {
      error.value = 'ຂໍ້ຜິດພາດໃນການໂຫຼດ: $e';
      debugPrint('Error fetching favorites: $e');
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
      update();
    }
  }

  Future<void> toggleFavorite(PItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      Get.snackbar(
        'ຂໍ້ຜິດພາດ',
        'ກະລຸນາເຂົ້າສູ່ລະບົບກ່ອນ',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    try {
      EasyLoading.show(status: 'ກຳລັງອັບເດດ...');

      bool isFav = favoriteItems.any((fav) => fav.id == item.id);

      if (isFav) {
        // Remove from favorites
        final response = await _apiService.post(
          '${ApiConstants.removeFromWishlistEndpoint}${item.id?.toInt()}',
          data: {},
        );

        if (response.success) {
          favoriteItems.removeWhere((fav) => fav.id == item.id);
          Get.snackbar(
            'ສຳເລັດ',
            'ລຶບອອກຈາກລາຍການທີ່ມັກແລ້ວ',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );
        } else {
          throw Exception(
            response.message ?? 'ບໍ່ສາມາດລຶບອອກຈາກລາຍການທີ່ມັກໄດ້',
          );
        }
      } else {
        // Add to favorites
        final response = await _apiService.post(
          ApiConstants.addToWishlistEndpoint,
          data: {'Product_ID': item.id?.toInt()},
        );

        if (response.success) {
          favoriteItems.add(item);
          Get.snackbar(
            'ສຳເລັດ',
            'ເພີ່ມເຂົ້າລາຍການທີ່ມັກແລ້ວ',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );
        } else {
          throw Exception(
            response.message ?? 'ບໍ່ສາມາດເພີ່ມເຂົ້າລາຍການທີ່ມັກໄດ້',
          );
        }
      }
      update();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      Get.snackbar(
        'ຂໍ້ຜິດພາດ',
        'ບໍ່ສາມາດອັບເດດລາຍການທີ່ມັກໄດ້: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
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
