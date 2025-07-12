import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_shoe/services/apiservice.dart';
import 'package:app_shoe/model/product_m.dart';
import 'package:app_shoe/services/apiconstants.dart';

class HomeC extends GetxController with GetTickerProviderStateMixin {
  final ApiService _apiService = ApiService();

  // Observable variables
  var popularProducts = <PItem>[].obs;
  var latestProducts = <PItem>[].obs;
  var isLoading = true.obs;
  var error = RxString('');

  // Animation controller
  late AnimationController animationController;
  late Animation<double> fadeAnimation;

  // Carousel data
  final List<Map<String, dynamic>> imgList = [
    {'image': 'images/bg123.png', 'page': () => const Page()},
    {'image': 'images/bg123.png', 'page': () => const Page()},
    {'image': 'images/bg123.png', 'page': () => const Page()},
  ];

  @override
  void onInit() {
    super.onInit();
    initAnimation();
    fetchHomeProducts();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void initAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> fetchHomeProducts() async {
    isLoading.value = true;
    error.value = '';

    try {
      final popRes = await _apiService.get(
        ApiConstants.popularProductsEndpoint,
      );
      final latestRes = await _apiService.get(
        ApiConstants.latestProductsEndpoint,
      );

      if (popRes.success && latestRes.success) {
        popularProducts.value =
            (popRes.data['data'] as List)
                .map((e) => PItem.fromJson(e))
                .toList();
        latestProducts.value =
            (latestRes.data['data'] as List)
                .map((e) => PItem.fromJson(e))
                .toList();
        animationController.forward();
      } else {
        error.value =
            popRes.message ??
            latestRes.message ??
            'ເກີດຂໍ້ຜິດພາດໃນການໂຫລດຂໍ້ມູນ';
      }
    } catch (e) {
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  // Helper methods for product stock checking
  int getProductTotalStock(PItem product) {
    if (product.Stock != null && product.Stock!.isNotEmpty) {
      return product.Stock!.fold(
        0,
        (sum, stock) => sum + (stock.Quantity ?? 0),
      );
    }
    return 0;
  }

  bool hasProductStockData(PItem product) {
    return product.Stock != null && product.Stock!.isNotEmpty;
  }

  bool isProductOutOfStock(PItem product) {
    return hasProductStockData(product) && getProductTotalStock(product) == 0;
  }

  String getStockStatusColor(int stock, bool isOutOfStock) {
    if (isOutOfStock) return 'red';
    if (stock <= 5) return 'orange';
    return 'green';
  }
}

// Temporary Page widget for carousel
class Page extends StatelessWidget {
  const Page({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 1'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(), // You can replace this with actual content
    );
  }
}
