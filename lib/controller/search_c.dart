import 'package:app_shoe/services/apiconstants.dart';
import 'package:app_shoe/services/apiservice.dart';
import '../model/product_m.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SearchC extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<PItem> _searchResults = <PItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearchActive = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;

  // Price filter variables
  var selectedMinPrice = Rxn<double>();
  var selectedMaxPrice = Rxn<double>();

  // Category filter variable
  var selectedCategory = ''.obs;

  // Price options in Kip (LAK)
  final List<double?> minPriceOptions = [
    null,
    300000,
    600000,
    900000,
    1200000,
    1500000,
    1800000,
  ];
  final List<double?> maxPriceOptions = [
    600000,
    900000,
    1200000,
    1500000,
    1800000,
    3000000,
    6000000,
    null,
  ];

  List<PItem> get searchResults => _searchResults;

  // ค้นหาสินค้า
  Future<void> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    print('🔍 เริ่มค้นหา: "${query}"');

    isLoading.value = true;
    isSearchActive.value = true;
    error.value = '';
    searchQuery.value = query;

    try {
      final response = await _apiService.post(
        ApiConstants.searchProductsEndpoint,
        data: {'q': query.trim()},
      );

      print('📡 Response: ${response.success}');
      print('📦 Data: ${response.data}');

      if (response.success) {
        final List<dynamic> productsData = response.data['data'] ?? [];
        _searchResults.clear();

        print('🎯 พบสินค้า ${productsData.length} รายการ');

        for (var item in productsData) {
          _searchResults.add(PItem.fromJson(item));
        }

        if (_searchResults.isEmpty) {
          error.value = 'ไม่พบสินค้าที่ค้นหา "${query}"';
        } else {
          print(
            '✅ เพิ่มสินค้าเข้า searchResults แล้ว: ${_searchResults.length} รายการ',
          );
        }
      } else {
        error.value = response.message ?? 'เกิดข้อผิดพลาดในการค้นหา';
        print('❌ API Error: ${response.message}');
      }
    } catch (e) {
      error.value = 'เกิดข้อผิดพลาดในการเชื่อมต่อ: $e';
      print('💥 Exception: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // ค้นหาแบบมีฟิลเตอร์ราคา (สำหรับ backward compatibility)
  Future<void> searchProductsWithPriceRange(
    String query, {
    double? minPrice,
    double? maxPrice,
  }) async {
    return searchProductsWithFilters(
      query,
      minPrice: minPrice,
      maxPrice: maxPrice,
      category: '',
    );
  }

  // ค้นหาแบบมีฟิลเตอร์ครบถ้วน (ราคา + ประเภท)
  Future<void> searchProductsWithFilters(
    String query, {
    double? minPrice,
    double? maxPrice,
    String? category,
  }) async {
    if (query.trim().isEmpty && query != '*') {
      clearSearch();
      return;
    }

    isLoading.value = true;
    isSearchActive.value = true;
    error.value = '';
    searchQuery.value = query == '*' ? '' : query;

    try {
      Map<String, dynamic> searchData = {'q': query.trim()};

      if (minPrice != null) {
        searchData['min_price'] = minPrice;
      }
      if (maxPrice != null) {
        searchData['max_price'] = maxPrice;
      }
      if (category != null && category.isNotEmpty) {
        searchData['category'] = category;
      }

      print('🔍 ค้นหาด้วยฟิลเตอร์: $searchData');

      final response = await _apiService.post(
        ApiConstants.searchProductsEndpoint,
        data: searchData,
      );

      if (response.success) {
        final List<dynamic> productsData = response.data['data'] ?? [];
        _searchResults.clear();

        for (var item in productsData) {
          _searchResults.add(PItem.fromJson(item));
        }

        if (_searchResults.isEmpty) {
          error.value = 'ไม่พบสินค้าที่ตรงกับเงื่อนไข';
        }
      } else {
        error.value = response.message ?? 'เกิดข้อผิดพลาดในการค้นหา';
      }
    } catch (e) {
      error.value = 'เกิดข้อผิดพลาดในการเชื่อมต่อ: $e';
      print('Error searching products with filters: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // ล้างผลการค้นหา
  void clearSearch() {
    _searchResults.clear();
    isSearchActive.value = false;
    error.value = '';
    searchQuery.value = '';
    update();
  }

  // รีเฟรชการค้นหา
  Future<void> refreshSearch() async {
    if (searchQuery.value.isNotEmpty) {
      await searchProducts(searchQuery.value);
    }
  }

  // ค้นหาด้วยฟิลเตอร์ราคา
  void applyPriceFilter() {
    applyAllFilters();
  }

  // ค้นหาด้วยฟิลเตอร์ประเภท
  void applyCategoryFilter(String category) {
    selectedCategory.value = category;
    applyAllFilters();
  }

  // ค้นหาด้วยฟิลเตอร์ทั้งหมด
  void applyAllFilters() {
    String query = searchQuery.value;
    String category = selectedCategory.value;
    double? minPrice = selectedMinPrice.value;
    double? maxPrice = selectedMaxPrice.value;

    // ถ้ามีการค้นหาข้อความหรือมีการกำหนดฟิลเตอร์ใดๆ
    if (query.isNotEmpty ||
        minPrice != null ||
        maxPrice != null ||
        category.isNotEmpty) {
      // ถ้าไม่มีคำค้นหา ใส่ * เป็น wildcard
      String searchQuery = query.isNotEmpty ? query : '*';

      searchProductsWithFilters(
        searchQuery,
        minPrice: minPrice,
        maxPrice: maxPrice,
        category: category,
      );
    }
  }

  // ล้างฟิลเตอร์ราคา
  void clearPriceFilter() {
    selectedMinPrice.value = null;
    selectedMaxPrice.value = null;
    clearSearch();
  }

  // ล้างฟิลเตอร์ทั้งหมด
  void clearAllFilters() {
    selectedMinPrice.value = null;
    selectedMaxPrice.value = null;
    selectedCategory.value = '';
    clearSearch();
  }

  // Helper method เพื่อแสดงข้อความราคา
  String formatPriceText(double? price, {bool isMin = true}) {
    if (price == null) {
      return isMin ? 'ไม่จำกัด' : 'ไม่จำกัด';
    }
    // จัดรูปแบบตัวเลขให้มีคอมมา
    String formattedPrice = price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$formattedPrice kip';
  }

  // ตรวจสอบว่ามีการตั้งค่าฟิลเตอร์หรือไม่
  bool get hasPriceFilter =>
      selectedMinPrice.value != null || selectedMaxPrice.value != null;

  // ตรวจสอบว่ามีการตั้งค่าฟิลเตอร์ใดๆ หรือไม่
  bool get hasAnyFilter =>
      selectedMinPrice.value != null ||
      selectedMaxPrice.value != null ||
      selectedCategory.value.isNotEmpty;
}
