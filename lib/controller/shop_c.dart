import 'package:app_shoe/controller/cart_c.dart';
import 'package:app_shoe/services/apiconstants.dart';
import 'package:app_shoe/services/apiservice.dart';
import '../model/product_m.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:app_shoe/view/Home/product_details.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ShopC extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<PItem> _items = <PItem>[].obs;
  final RxList<PItem> _cartItems = <PItem>[].obs;
  final RxList<bool> isLikedList = <bool>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString currentCategory = ''.obs;
  final RxString selectedCategory = ''.obs; // เพิ่ม selectedCategory ที่นี่
  RxList<PItem> get items => _items;
  RxList<PItem> get cartItems => _cartItems;

  @override
  void onInit() {
    super.onInit();
    refreshShopData();
  }

  Future<void> refreshShopData() async {
    await fetchProducts('');
  }

  Future<void> fetchProducts(String categoryId) async {
    if (isLoading.value) return;
    EasyLoading.show(status: 'Loading category...');
    isLoading.value = true;
    error.value = '';
    currentCategory.value = categoryId;
    try {
      final response = await _apiService.post(
        '${ApiConstants.categoriesEndpoint}$categoryId',
        data: {},
      );
      if (response.success) {
        List<PItem> products =
            (response.data['products'] as List)
                .map((item) => PItem.fromJson(item))
                .toList();
        _items.clear();
        _items.addAll(products);
        print('Fetched ${response.data['products']} products');
      }
    } catch (e) {
      error.value = 'Error fetching category products: $e';
      print('Error fetching products: ' + error.value);
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
      update();
    }
  }

  void openProductDetails(int index) {
    Get.to(() => ProductDetails(product: _items[index]));
  }
}
