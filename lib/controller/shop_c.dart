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

  // Add pagination variables
  RxInt page = 1.obs;
  RxInt limit = 6.obs;
  RxBool hasMore = true.obs; // To check if there are more items to load

  RxList<PItem> get items => _items;
  RxList<PItem> get cartItems => _cartItems;

  @override
  void onInit() {
    super.onInit();
    // Initialize pagination variables and fetch initial data
    page.value = 1;
    limit.value = 6;
    hasMore.value = true;
    fetchProducts('');
  }

  Future<void> refreshShopData() async {
    // Reset pagination and fetch initial data
    page.value = 1;
    hasMore.value = true;
    await fetchProducts('');
  }

  Future<void> fetchProducts(String categoryId) async {
    if (isLoading.value || !hasMore.value)
      return; // Prevent multiple calls or loading if no more data
    EasyLoading.show(status: 'Loading products...');
    isLoading.value = true;
    error.value = '';
    currentCategory.value = categoryId;
    try {
      final response = await _apiService.post(
        '${ApiConstants.categoriesEndpoint}$categoryId?page=${page.value}&limit=${limit.value}',
        data: {},
      );
      if (response.success) {
        List<PItem> products =
            (response.data['products'] as List)
                .map((item) => PItem.fromJson(item))
                .toList();

        if (page.value == 1) {
          _items.clear(); // Clear only for the first page
        }
        _items.addAll(products);

        // Check if the number of fetched products is less than the limit, indicating no more data
        if (products.length < limit.value) {
          hasMore.value = false;
        }

        print('Fetched ${products.length} products for page ${page.value}');
      } else {
        // Handle API error response
        error.value = 'API Error: ${response.message}';
        print('API Error fetching products: ' + error.value);
        hasMore.value = false; // Assume no more data on API error
      }
    } catch (e) {
      error.value = 'Error fetching products: $e';
      print('Error fetching products: ' + error.value);
      hasMore.value = false; // Assume no more data on exception
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
      update();
    }
  }

  // Method to load more products
  Future<void> loadMoreProducts() async {
    if (!isLoading.value && hasMore.value) {
      page.value++; // Increment page number
      await fetchProducts(currentCategory.value); // Fetch next page
    }
  }

  void openProductDetails(int index) {
    Get.to(() => ProductDetails(product: _items[index]));
  }
}
