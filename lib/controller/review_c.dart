import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/product_m.dart';
import '../services/apiconstants.dart';
import '../services/apiservice.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ReviewC extends GetxController {
  final ApiService _apiService = ApiService();

  // Observable variables
  final RxList<Review> reviews = <Review>[].obs;
  final Rx<ReviewSummary?> reviewSummary = Rx<ReviewSummary?>(null);
  final Rx<Review?> userReview = Rx<Review?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString error = ''.obs;
  final RxString userId = ''.obs;
  final RxInt currentProductId = 0.obs;

  // Form variables
  final RxInt selectedRating = 0.obs;
  final RxString reviewComment = ''.obs;
  final TextEditingController commentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    initUserId();
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  Future<void> initUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString('userId') ?? '';
  }

  // Initialize reviews for a product
  Future<void> initReviewsForProduct(int productId) async {
    currentProductId.value = productId;
    await Future.wait([
      fetchReviews(productId),
      fetchReviewSummary(productId),
      fetchUserReview(productId),
    ]);
  }

  // Fetch all reviews for a product
  Future<void> fetchReviews(int productId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _apiService.get(
        '${ApiConstants.reviewsEndpoint}/$productId',
      );

      if (response.success) {
        if (response.data != null && response.data['data'] != null) {
          List<Review> fetchedReviews =
              (response.data['data'] as List)
                  .map((item) => Review.fromJson(item))
                  .toList();
          reviews.clear();
          reviews.addAll(fetchedReviews);
        } else {
          reviews.clear();
        }
      } else {
        error.value = response.message ?? 'Failed to fetch reviews';
      }
    } catch (e) {
      error.value = 'Error fetching reviews: $e';
      debugPrint('Error fetching reviews: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch review summary for a product
  Future<void> fetchReviewSummary(int productId) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.reviewSummaryEndpoint}/$productId/summary',
      );

      if (response.success) {
        if (response.data != null && response.data['data'] != null) {
          reviewSummary.value = ReviewSummary.fromJson(response.data['data']);
        } else {
          reviewSummary.value = ReviewSummary(
            totalReviews: 0,
            averageRating: 0.0,
            rating5: 0,
            rating4: 0,
            rating3: 0,
            rating2: 0,
            rating1: 0,
          );
        }
      } else {
        debugPrint('Failed to fetch review summary: ${response.message}');
      }
    } catch (e) {
      debugPrint('Error fetching review summary: $e');
    }
  }

  // Fetch user's review for a product
  Future<void> fetchUserReview(int productId) async {
    try {
      if (userId.value.isEmpty) return;

      final response = await _apiService.get(
        '${ApiConstants.userReviewEndpoint}/$productId/user',
      );

      if (response.success) {
        if (response.data != null && response.data['data'] != null) {
          userReview.value = Review.fromJson(response.data['data']);
          // Set form data if user has existing review
          selectedRating.value = userReview.value?.rating ?? 0;
          reviewComment.value = userReview.value?.comment ?? '';
          commentController.text = reviewComment.value;
        } else {
          userReview.value = null;
          selectedRating.value = 0;
          reviewComment.value = '';
          commentController.text = '';
        }
      }
    } catch (e) {
      debugPrint('Error fetching user review: $e');
    }
  }

  // Submit or update review
  Future<bool> submitReview(int productId) async {
    if (userId.value.isEmpty) {
      Get.snackbar(
        'ข้อผิดพลาด',
        'กรุณาเข้าสู่ระบบก่อนให้คะแนน',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return false;
    }

    if (selectedRating.value == 0) {
      Get.snackbar(
        'ข้อผิดพลาด',
        'กรุณาให้คะแนนสินค้า',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.star_outline, color: Colors.white),
      );
      return false;
    }

    try {
      isSubmitting.value = true;
      EasyLoading.show(status: 'กำลังบันทึกรีวิว...');

      final response = await _apiService.post(
        ApiConstants.reviewsEndpoint,
        data: {
          'Product_ID': productId,
          'Rating': selectedRating.value,
          'Comment': commentController.text.trim(),
        },
      );

      if (response.success) {
        Get.snackbar(
          'สำเร็จ',
          userReview.value != null
              ? 'อัปเดตรีวิวเรียบร้อย'
              : 'เพิ่มรีวิวเรียบร้อย',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.check_circle_outline, color: Colors.white),
        );

        // Refresh all review data
        await initReviewsForProduct(productId);
        return true;
      } else {
        Get.snackbar(
          'ข้อผิดพลาด',
          response.message ?? 'ไม่สามารถบันทึกรีวิวได้',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.error_outline, color: Colors.white),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'ข้อผิดพลาด',
        'เกิดข้อผิดพลาด: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return false;
    } finally {
      isSubmitting.value = false;
      EasyLoading.dismiss();
    }
  }

  // Delete user's review
  Future<bool> deleteReview(int productId) async {
    if (userId.value.isEmpty || userReview.value == null) {
      return false;
    }

    try {
      EasyLoading.show(status: 'กำลังลบรีวิว...');

      final response = await _apiService.delete(
        '${ApiConstants.userReviewEndpoint}/$productId',
      );

      if (response.success) {
        Get.snackbar(
          'สำเร็จ',
          'ลบรีวิวเรียบร้อย',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.check_circle_outline, color: Colors.white),
        );

        // Reset form and refresh data
        resetForm();
        await initReviewsForProduct(productId);
        return true;
      } else {
        Get.snackbar(
          'ข้อผิดพลาด',
          response.message ?? 'ไม่สามารถลบรีวิวได้',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.error_outline, color: Colors.white),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'ข้อผิดพลาด',
        'เกิดข้อผิดพลาด: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Reset form
  void resetForm() {
    selectedRating.value = 0;
    reviewComment.value = '';
    commentController.clear();
  }

  // Update rating
  void setRating(int rating) {
    selectedRating.value = rating;
  }

  // Update comment
  void updateComment(String comment) {
    reviewComment.value = comment;
  }

  // Helper methods
  bool get hasUserReviewed => userReview.value != null;

  bool get canSubmitReview =>
      userId.value.isNotEmpty && selectedRating.value > 0;

  String get submitButtonText => hasUserReviewed ? 'อัปเดตรีวิว' : 'เพิ่มรีวิว';

  // Format date
  String formatReviewDate(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} นาทีที่แล้ว';
      }
      return '${difference.inHours} ชั่วโมงที่แล้ว';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} วันที่แล้ว';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
