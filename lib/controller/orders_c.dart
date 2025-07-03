import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/apiservice.dart';
import '../services/apiconstants.dart';

class Order {
  final int orderId;
  final String oid;
  final String orderDate;
  final String orderStatus;
  final double totalAmount;
  final String? paymentStatus;
  final String? paymentMethod;
  final String? shipStatus;
  final String? trackingNumber;
  final List<OrderItem> items;

  Order({
    required this.orderId,
    required this.oid,
    required this.orderDate,
    required this.orderStatus,
    required this.totalAmount,
    this.paymentStatus,
    this.paymentMethod,
    this.shipStatus,
    this.trackingNumber,
    this.items = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['Order_ID'] ?? 0,
      oid: json['OID'] ?? '',
      orderDate: json['Order_Date'] ?? '',
      orderStatus: json['Order_Status'] ?? '',
      totalAmount: double.tryParse(json['Total_Amount'].toString()) ?? 0.0,
      paymentStatus: json['Payment_Status'],
      paymentMethod: json['Payment_Method'],
      shipStatus: json['Ship_Status'],
      trackingNumber: json['Tracking_Number'],
      items:
          json['items'] != null
              ? (json['items'] as List)
                  .map((item) => OrderItem.fromJson(item))
                  .toList()
              : [],
    );
  }

  bool get isPending => orderStatus.toLowerCase() == 'pending';
  bool get isCompleted => orderStatus.toLowerCase() == 'completed';
  bool get canRepay => isPending;

  String get statusText {
    switch (orderStatus.toLowerCase()) {
      case 'pending':
        return 'ລໍຖ້າການຈ່າຍເງິນ';
      case 'completed':
        return 'ຈ່າຍເງິນແລ້ວ';
      case 'cancelled':
        return 'ຍົກເລີກແລ້ວ';
      default:
        return orderStatus;
    }
  }

  Color get statusColor {
    switch (orderStatus.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class OrderItem {
  final int productId;
  final String name;
  final String brand;
  final String image;
  final String size;
  final String color;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  OrderItem({
    required this.productId,
    required this.name,
    required this.brand,
    required this.image,
    required this.size,
    required this.color,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['Product_ID'] ?? 0,
      name: json['Name'] ?? '',
      brand: json['Brand'] ?? '',
      image: json['Image'] ?? '',
      size: json['Size']?.toString() ?? '',
      color: json['Color'] ?? '',
      quantity: json['Quantity'] ?? 0,
      unitPrice: double.tryParse(json['Unit_Price'].toString()) ?? 0.0,
      subtotal: double.tryParse(json['Subtotal'].toString()) ?? 0.0,
    );
  }
}

class OrdersController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var orders = <Order>[].obs;
  var currentOrder = Rxn<Order>();
  var error = ''.obs;

  // Pagination
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  // ดึงรายการ orders
  Future<void> fetchOrders({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      orders.clear();
      hasMore.value = true;
    }

    if (!hasMore.value || isLoading.value) return;

    isLoading.value = true;
    error.value = '';

    try {
      final response = await _apiService.get(
        '${ApiConstants.ordersEndpoint}?page=${currentPage.value}&limit=10',
      );

      if (response.success) {
        final data = response.data['data'];
        final List<dynamic> ordersList = data['orders'] ?? [];

        List<Order> newOrders =
            ordersList.map((json) => Order.fromJson(json)).toList();

        if (refresh) {
          orders.value = newOrders;
        } else {
          orders.addAll(newOrders);
        }

        // อัปเดต pagination
        currentPage.value++;
        totalPages.value = data['pagination']['totalPages'] ?? 1;
        hasMore.value = currentPage.value <= totalPages.value;
      } else {
        error.value = response.message ?? 'ເກີດຂໍ້ຜິດພາດໃນການດຶງຂໍ້ມູນ';
      }
    } catch (e) {
      error.value = 'ເກີດຂໍ້ຜິດພາດໃນການເຊື່ອມຕໍ່: $e';
      print('Error fetching orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ดึงรายละเอียด order
  Future<void> fetchOrderDetail(String orderId) async {
    isLoading.value = true;
    error.value = '';

    try {
      final response = await _apiService.get(
        '${ApiConstants.orderDetailEndpoint}/$orderId',
      );

      if (response.success) {
        currentOrder.value = Order.fromJson(response.data['data']['order']);
      } else {
        error.value = response.message ?? 'ບໍ່ພົບຂໍ້ມູນການສັ່ງຊື້';
      }
    } catch (e) {
      error.value = 'ເກີດຂໍ້ຜິດພາດໃນການເຊື່ອມຕໍ່: $e';
      print('Error fetching order detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // จ่ายเงินใหม่
  Future<void> repayOrder(String orderId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _apiService.post(
        '${ApiConstants.repayOrderEndpoint}/$orderId/repay',
        data: {},
      );

      if (response.success) {
        final sessionUrl = response.data['session_url'];

        if (sessionUrl != null) {
          // เปิด Stripe checkout
          await _launchUrl(sessionUrl);

          // รีเฟรช orders หลังจากการจ่าย
          await fetchOrders(refresh: true);
        }
      } else {
        error.value = response.message ?? 'ເກີດຂໍ້ຜິດພາດໃນການສ້າງການຈ່າຍເງິນ';
        Get.snackbar(
          'ຂໍ້ຜິດພາດ',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      error.value = 'ເກີດຂໍ້ຜິດພາດໃນການເຊື່ອມຕໍ່: $e';
      Get.snackbar(
        'ຂໍ້ຜິດພາດ',
        error.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error repaying order: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // เปิด URL สำหรับการจ่าย
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  // รีเฟรช orders
  Future<void> refreshOrders() async {
    await fetchOrders(refresh: true);
  }

  // โหลด orders เพิ่มเติม
  void loadMoreOrders() {
    if (hasMore.value && !isLoading.value) {
      fetchOrders();
    }
  }

  // จัดรูปแบบราคา
  String formatPrice(double price) {
    String formattedPrice = price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$formattedPrice kip';
  }

  // จัดรูปแบบวันที่
  String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}
