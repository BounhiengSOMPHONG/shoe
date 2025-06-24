import 'package:app_shoe/view/Home/checkout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/product_m.dart';

class CartC extends GetxController {
  final RxList<PItem> _items = <PItem>[].obs;
  final RxDouble _total = 0.0.obs;
  static const String CART_ITEMS_KEY = 'cart_items';

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
  }

  List<PItem> get items => _items;
  double get total => _total.value;

  // Load cart items from local storage
  Future<void> loadCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cartItemsJson = prefs.getString(CART_ITEMS_KEY);
      if (cartItemsJson != null) {
        final List<dynamic> decodedItems = json.decode(cartItemsJson);
        _items.value =
            decodedItems.map((item) => PItem.fromJson(item)).toList();
        _calculateTotal();
      }
    } catch (e) {
      print('Error loading cart items: $e');
    }
  }

  // Save cart items to local storage
  Future<void> saveCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String cartItemsJson = json.encode(
        _items.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(CART_ITEMS_KEY, cartItemsJson);
    } catch (e) {
      print('Error saving cart items: $e');
    }
  }

  void addItem(PItem item) {
    // Check if item already exists with same id, size and color
    final existingItemIndex = _items.indexWhere(
      (existing) =>
          existing.id == item.id &&
          existing.size == item.size &&
          existing.color == item.color,
    );

    if (existingItemIndex != -1) {
      // If item exists, increment quantity
      _items[existingItemIndex].quantity =
          (_items[existingItemIndex].quantity ?? 1) + 1;
      _items.refresh();
      // Get.snackbar(
      //   'Cart Updated',
      //   'Item quantity has been increased\nSize: ${item.size}\nColor: ${item.color}',
      //   backgroundColor: Colors.green.withOpacity(0.7),
      //   colorText: Colors.white,
      //   duration: Duration(seconds: 2),
      //   margin: EdgeInsets.all(8),
      //   borderRadius: 8,
      // );
      Get.snackbar(
        'Added to Cart',
        'Successfully added',
        backgroundColor: Colors.blueAccent.withOpacity(0.7),
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // Add new item
      item.quantity ??= 1;
      item.price ??= 0.0;
      _items.add(item);
      // Get.snackbar(
      //   'Added to Cart',
      //   'Product ${item.name} has been added to your cart\nSize: ${item.size}\nColor: ${item.color}',
      //   backgroundColor: Colors.green.withOpacity(0.7),
      //   colorText: Colors.white,
      //   duration: Duration(seconds: 2),
      //   margin: EdgeInsets.all(8),
      //   borderRadius: 8,
      // );
      Get.snackbar(
        'Added to Cart',
        'Successfully added',
        backgroundColor: Colors.blueAccent.withOpacity(0.7),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    _calculateTotal();
    saveCartItems(); // Save after adding item
  }

  void removeItem(int index) {
    _items.removeAt(index);
    _calculateTotal();
    saveCartItems(); // Save after removing item
  }

  void updateQuantity(int index, int change) {
    if (index >= 0 && index < _items.length) {
      final item = _items[index];
      item.quantity ??= 1;

      if ((item.quantity! + change) > 0) {
        item.quantity = item.quantity! + change;
        _items.refresh();
        _calculateTotal();
        saveCartItems(); // Save after updating quantity
      }
    }
  }

  void _calculateTotal() {
    _total.value = _items.fold(
      0.0,
      (sum, item) => sum + ((item.price ?? 0.0) * (item.quantity ?? 1)),
    );
  }

  Future<void> Checkout() async {
    try {
      EasyLoading.show(status: 'Processing checkout...');
      await Future.delayed(Duration(seconds: 1));
      // await saveCartItems(); // Save after clearing cart
      // _items.clear();
      _calculateTotal();
      // Get.snackbar(
      //   'Success',
      //   'Your order has been placed successfully',
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      //   duration: Duration(seconds: 2),
      // );
      Get.to(() => CheckoutPage(), transition: Transition.rightToLeft);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to process checkout',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }
}
