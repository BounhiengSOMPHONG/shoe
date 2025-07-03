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
  bool get isCancelled => orderStatus.toLowerCase() == 'cancelled';
  bool get canRepay => isPending;
  bool get canCancel => isPending;

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

class TimelineItem {
  final String status;
  final String title;
  final String description;
  final DateTime? timestamp;
  final bool completed;
  final String icon;
  final bool isError;

  TimelineItem({
    required this.status,
    required this.title,
    required this.description,
    this.timestamp,
    required this.completed,
    required this.icon,
    this.isError = false,
  });

  factory TimelineItem.fromJson(Map<String, dynamic> json) {
    return TimelineItem(
      status: json['status'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      timestamp:
          json['timestamp'] != null
              ? DateTime.tryParse(json['timestamp'])
              : null,
      completed: json['completed'] ?? false,
      icon: json['icon'] ?? 'info',
      isError: json['isError'] ?? false,
    );
  }

  IconData get iconData {
    switch (icon) {
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'payment':
        return Icons.payment;
      case 'schedule':
        return Icons.schedule;
      case 'inventory':
        return Icons.inventory;
      case 'local_shipping':
        return Icons.local_shipping;
      case 'check_circle':
        return Icons.check_circle;
      case 'cancel':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Color get statusColor {
    if (isError) return Colors.red;
    if (completed) return Colors.green;
    return Colors.orange;
  }
}

class OrdersController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var orders = <Order>[].obs;
  var currentOrder = Rxn<Order>();
  var error = ''.obs;

  // Timeline
  var timeline = <TimelineItem>[].obs;
  var isLoadingTimeline = false.obs;

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

  // จัดรูปแบบวันที่ (แปลงเป็น Local timezone)
  String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);

      // แปลงเป็น local timezone ของ device
      DateTime localDate = date.toLocal();

      return '${localDate.day.toString().padLeft(2, '0')}/${localDate.month.toString().padLeft(2, '0')}/${localDate.year} ${localDate.hour.toString().padLeft(2, '0')}:${localDate.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      print('Error formatting date: $e - Input: $dateString');
      return dateString;
    }
  }

  // จัดรูปแบบวันที่แบบสั้น
  String formatDateShort(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      DateTime localDate = date.toLocal();

      return '${localDate.day}/${localDate.month}/${localDate.year}';
    } catch (e) {
      print('Error formatting short date: $e - Input: $dateString');
      return dateString;
    }
  }

  // จัดรูปแบบวันที่แบบเต็ม (สำหรับ timeline)
  String formatDateTimeline(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      DateTime localDate = date.toLocal();

      final months = [
        '',
        'ม.ค.',
        'ก.พ.',
        'มี.ค.',
        'เม.ย.',
        'พ.ค.',
        'มิ.ย.',
        'ก.ค.',
        'ส.ค.',
        'ก.ย.',
        'ต.ค.',
        'พ.ย.',
        'ธ.ค.',
      ];

      return '${localDate.day} ${months[localDate.month]} ${localDate.year} ${localDate.hour.toString().padLeft(2, '0')}:${localDate.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      print('Error formatting timeline date: $e - Input: $dateString');
      return dateString;
    }
  }

  // ยกเลิก order
  Future<void> cancelOrder(String orderId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _apiService.post(
        '${ApiConstants.cancelOrderEndpoint}/$orderId/cancel',
        data: {},
      );

      if (response.success) {
        Get.snackbar(
          'ສຳເລັດ',
          'ຍົກເລີກການສັ່ງຊື້ແລ້ວ',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // รีเฟรช orders list
        await fetchOrders(refresh: true);

        // รีเฟรช timeline ถ้ามี
        if (timeline.isNotEmpty) {
          await fetchShippingTimeline(orderId);
        }
      } else {
        error.value = response.message ?? 'ເກີດຂໍ້ຜິດພາດໃນການຍົກເລີກ';
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
      print('Error cancelling order: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ดึง shipping timeline
  Future<void> fetchShippingTimeline(String orderId) async {
    try {
      isLoadingTimeline.value = true;
      error.value = '';

      final response = await _apiService.get(
        '${ApiConstants.orderTimelineEndpoint}/$orderId/timeline',
      );

      if (response.success) {
        final data = response.data['data'];
        final List<dynamic> timelineList = data['timeline'] ?? [];

        timeline.value =
            timelineList.map((json) => TimelineItem.fromJson(json)).toList();
      } else {
        error.value = response.message ?? 'ບໍ່ສາມາດດຶງຂໍ້ມູນໄທມ୍ລາຍໄດ້';
      }
    } catch (e) {
      error.value = 'ເກີດຂໍ້ຜິດພາດໃນການເຊື່ອມຕໍ່: $e';
      print('Error fetching timeline: $e');
    } finally {
      isLoadingTimeline.value = false;
    }
  }

  // ดึงข้อมูล order พร้อม timeline
  Future<void> fetchOrderWithTimeline(String orderId) async {
    await Future.wait([
      fetchOrderDetail(orderId),
      fetchShippingTimeline(orderId),
    ]);
  }

  // แสดง confirmation dialog สำหรับการยกเลิก
  void showCancelConfirmation(String orderId, String orderOid) {
    Get.dialog(
      AlertDialog(
        title: const Text('ຢືນຢັນການຍົກເລີກ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ລາຍການທີ: $orderOid'),
            const SizedBox(height: 16),
            const Text(
              'ທ່ານຕ້ອງການຍົກເລີກການສັ່ງຊື້ນີ້ບໍ?',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              'ໝາຍເຫດ: ການສັ່ງຊື້ທີ່ຍົກເລີກແລ້ວບໍ່ສາມາດຍົກເລີກໄດ້',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('ບໍ່ຍົກເລີກ'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              cancelOrder(orderId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'ຢືນຢັນຍົກເລີກ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
