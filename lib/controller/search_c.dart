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

  // Filter variables
  var selectedCategory = ''.obs;
  var selectedProductType = ''.obs;
  var selectedBrand = ''.obs;

  // Dynamic data lists
  final RxList<ProductType> _productTypes = <ProductType>[].obs;
  final RxList<Brand> _brands = <Brand>[].obs;

  // Price sorting variables
  var sortOrder = ''.obs; // 'asc', 'desc', or empty for no sorting
  var isSortingEnabled = false.obs;

  // Sort options
  final List<Map<String, String>> sortOptions = [
    {'value': '', 'label': 'ไม่เรียงลำดับ'},
    {'value': 'asc', 'label': 'ราคาต่ำ - สูง'},
    {'value': 'desc', 'label': 'ราคาสูง - ต่ำ'},
  ];

  List<PItem> get searchResults => _searchResults;
  List<ProductType> get productTypes => _productTypes;
  List<Brand> get brands => _brands;

  @override
  void onInit() {
    super.onInit();
    fetchProductTypes();
    fetchBrands();
  }

  // ดึงข้อมูล Product Types จาก API
  Future<void> fetchProductTypes() async {
    try {
      final response = await _apiService.get(ApiConstants.productTypesEndpoint);

      if (response.success) {
        final List<dynamic> data = response.data['data'] ?? [];
        _productTypes.clear();

        for (var item in data) {
          _productTypes.add(ProductType.fromJson(item));
        }

        print('✅ โหลด ProductTypes สำเร็จ: ${_productTypes.length} รายการ');
      } else {
        print('❌ ไม่สามารถโหลด ProductTypes ได้: ${response.message}');
      }
    } catch (e) {
      print('💥 Error fetching product types: $e');
    }
  }

  // ดึงข้อมูล Brands จาก API
  Future<void> fetchBrands() async {
    try {
      final response = await _apiService.get(ApiConstants.brandsEndpoint);

      if (response.success) {
        final List<dynamic> data = response.data['data'] ?? [];
        _brands.clear();

        for (var item in data) {
          _brands.add(Brand.fromJson(item));
        }

        print('✅ โหลด Brands สำเร็จ: ${_brands.length} รายการ');
      } else {
        print('❌ ไม่สามารถโหลด Brands ได้: ${response.message}');
      }
    } catch (e) {
      print('💥 Error fetching brands: $e');
    }
  }

  // รีเฟรชข้อมูล Product Types และ Brands
  Future<void> refreshFilterData() async {
    await Future.wait([fetchProductTypes(), fetchBrands()]);
  }

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

  // ค้นหาแบบมีฟิลเตอร์ครบถ้วน (ประเภท + แบรนด์ + การเรียงลำดับ)
  Future<void> searchProductsWithFilters(
    String query, {
    String? category,
    String? productType,
    String? brand,
    String? sortBy,
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

      if (category != null && category.isNotEmpty) {
        searchData['category'] = category;
      }
      if (productType != null && productType.isNotEmpty) {
        searchData['productType'] = productType;
      }
      if (brand != null && brand.isNotEmpty) {
        searchData['brand'] = brand;
      }
      if (sortBy != null && sortBy.isNotEmpty) {
        searchData['sort'] = sortBy;
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

        // Apply local sorting if needed
        _applySorting();

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

  // ค้นหาด้วยฟิลเตอร์ประเภท
  void applyCategoryFilter(String category) {
    selectedCategory.value = category;
    applyAllFilters();
  }

  // ค้นหาด้วยฟิลเตอร์ Product Type
  void applyProductTypeFilter(String productType) {
    selectedProductType.value = productType;
    applyAllFilters();
  }

  // ค้นหาด้วยฟิลเตอร์ Brand
  void applyBrandFilter(String brand) {
    selectedBrand.value = brand;
    applyAllFilters();
  }

  // ค้นหาด้วยฟิลเตอร์ทั้งหมด
  void applyAllFilters() {
    String query = searchQuery.value;
    String category = selectedCategory.value;
    String productType = selectedProductType.value;
    String brand = selectedBrand.value;
    String sort = sortOrder.value;

    // ถ้ามีการค้นหาข้อความหรือมีการกำหนดฟิลเตอร์ใดๆ
    if (query.isNotEmpty ||
        category.isNotEmpty ||
        productType.isNotEmpty ||
        brand.isNotEmpty ||
        sort.isNotEmpty) {
      // ถ้าไม่มีคำค้นหา ใส่ * เป็น wildcard
      String searchQuery = query.isNotEmpty ? query : '*';

      searchProductsWithFilters(
        searchQuery,
        category: category,
        productType: productType,
        brand: brand,
        sortBy: sort,
      );
    }
  }

  // Apply sorting to current search results
  void _applySorting() {
    if (sortOrder.value.isEmpty) return;

    if (sortOrder.value == 'asc') {
      _searchResults.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
    } else if (sortOrder.value == 'desc') {
      _searchResults.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
    }
  }

  // Apply sorting without re-searching
  void applySorting(String order) {
    sortOrder.value = order;
    _applySorting();
    update();
  }

  // Sort current results by price
  void sortByPrice(String order) {
    sortOrder.value = order;
    if (_searchResults.isNotEmpty) {
      _applySorting();
      update();
    } else {
      // If we have active search, re-search with sorting
      if (isSearchActive.value) {
        applyAllFilters();
      }
    }
  }

  // ล้างฟิลเตอร์ทั้งหมด
  void clearAllFilters() {
    selectedCategory.value = '';
    selectedProductType.value = '';
    selectedBrand.value = '';
    sortOrder.value = '';
    clearSearch();
  }

  // ตรวจสอบว่ามีการตั้งค่าฟิลเตอร์ใดๆ หรือไม่
  bool get hasAnyFilter =>
      selectedCategory.value.isNotEmpty ||
      selectedProductType.value.isNotEmpty ||
      selectedBrand.value.isNotEmpty;
}
