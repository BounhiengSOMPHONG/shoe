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
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedUserId = prefs.getString('userId') ?? '';
      userId.value = storedUserId;
      debugPrint('Initialized userId: "${userId.value}"');

      // Also get token for debugging
      final token = prefs.getString('token') ?? '';
      debugPrint('Token exists: ${token.isNotEmpty}');
    } catch (e) {
      debugPrint('Error initializing userId: $e');
    }
  }

  // Manual refresh method
  Future<void> refreshReviewData() async {
    if (currentProductId.value > 0) {
      debugPrint(
        'Refreshing review data for product ${currentProductId.value}',
      );
      await initUserId(); // Refresh user ID first
      await initReviewsForProduct(currentProductId.value);
    }
  }

  // Initialize reviews for a product
  Future<void> initReviewsForProduct(int productId) async {
    try {
      debugPrint('=== Initializing reviews for product $productId ===');
      currentProductId.value = productId;

      // Reset form data
      selectedRating.value = 0;
      reviewComment.value = '';
      commentController.text = '';
      userReview.value = null;

      // Ensure we have userId first
      if (userId.value.isEmpty) {
        debugPrint('UserId is empty, initializing...');
        await initUserId();
      }

      debugPrint('Using userId: "${userId.value}"');

      // Fetch data in parallel
      await Future.wait([
        fetchReviews(productId),
        fetchReviewSummary(productId),
        if (userId.value.isNotEmpty) fetchUserReview(productId),
      ]);

      debugPrint('Review initialization completed for product $productId');
    } catch (e) {
      debugPrint('Error initializing reviews: $e');
    }
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
      if (userId.value.isEmpty) {
        debugPrint('User not logged in, skipping user review fetch');
        return;
      }

      final endpoint = '${ApiConstants.userReviewEndpoint}/$productId/user';
      final fullUrl = '${ApiConstants.baseUrl}$endpoint';
      debugPrint('Fetching user review for product $productId');
      debugPrint('User ID: "${userId.value}"');
      debugPrint('Full URL: $fullUrl');

      final response = await _apiService.get(endpoint);

      debugPrint('User review response status: ${response.success}');
      debugPrint('User review response data: ${response.data}');
      debugPrint('User review response message: ${response.message}');

      if (response.success) {
        if (response.data != null && response.data['data'] != null) {
          userReview.value = Review.fromJson(response.data['data']);
          // Set form data if user has existing review
          selectedRating.value = userReview.value?.rating ?? 0;
          reviewComment.value = userReview.value?.comment ?? '';
          commentController.text = reviewComment.value;
          debugPrint('✅ User review loaded successfully:');
          debugPrint('   - Review ID: ${userReview.value?.reviewId}');
          debugPrint('   - Rating: ${selectedRating.value}');
          debugPrint('   - Comment: "${reviewComment.value}"');
        } else {
          userReview.value = null;
          selectedRating.value = 0;
          reviewComment.value = '';
          commentController.text = '';
          debugPrint('ℹ️ No user review found for this product');
        }
      } else {
        debugPrint('❌ Failed to fetch user review: ${response.message}');
        // If it's a 404 or "No review found", that's normal
        if (response.message?.contains('No review found') == true ||
            response.message?.contains('404') == true) {
          userReview.value = null;
          selectedRating.value = 0;
          reviewComment.value = '';
          commentController.text = '';
          debugPrint('ℹ️ User has not reviewed this product yet');
        }
      }
    } catch (e) {
      debugPrint('❌ Error fetching user review: $e');
      userReview.value = null;
      selectedRating.value = 0;
      reviewComment.value = '';
      commentController.text = '';
    }
  }

  // Submit or update review
  Future<bool> submitReview(int productId) async {
    if (userId.value.isEmpty) {
      Get.snackbar(
        'ຂໍ້ຜິດພາດ',
        'ກະລຸນາເຂົ້າສູ່ລະບົບກ່ອນໃຫ້ຄະແນນ',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return false;
    }

    if (selectedRating.value == 0) {
      Get.snackbar(
        'ຂໍ້ຜິດພາດ',
        'ກະລຸນາໃຫ້ຄະແນນສິນຄ້າ',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.star_outline, color: Colors.white),
      );
      return false;
    }

    try {
      isSubmitting.value = true;
      EasyLoading.show(status: 'ກຳລັງບັນທຶກຣີວິວ...');

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
          'ສຳເລັດ',
          userReview.value != null ? 'ອັບເດດຣີວິວຮຽບຮ້ອຍ' : 'ເພີ່ມຣີວິວຮຽບຮ້ອຍ',
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
          'ຂໍ້ຜິດພາດ',
          response.message ?? 'ບໍ່ສາມາດບັນທຶກຣີວິວໄດ້',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.error_outline, color: Colors.white),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'ຂໍ້ຜິດພາດ',
        'ເກີດຂໍ້ຜິດພາດ: $e',
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
      EasyLoading.show(status: 'ກຳລັງລົບຣີວິວ...');

      final response = await _apiService.delete(
        '${ApiConstants.userReviewEndpoint}/$productId',
      );

      if (response.success) {
        Get.snackbar(
          'ສຳເລັດ',
          'ລົບຣີວິວຮຽບຮ້ອຍ',
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
          'ຂໍ້ຜິດພາດ',
          response.message ?? 'ບໍ່ສາມາດລົບຣີວິວໄດ້',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.error_outline, color: Colors.white),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'ຂໍ້ຜິດພາດ',
        'ເກີດຂໍ້ຜິດພາດ: $e',
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

  bool get canSubmitReview {
    final canSubmit = userId.value.isNotEmpty && selectedRating.value > 0;
    debugPrint(
      'canSubmitReview: userId=${userId.value.isNotEmpty}, rating=${selectedRating.value}, result=$canSubmit',
    );
    return canSubmit;
  }

  String get submitButtonText {
    final text = hasUserReviewed ? 'ອັບເດດຣີວິວ' : 'ເພີ່ມຣີວິວ';
    debugPrint(
      'submitButtonText: hasUserReviewed=$hasUserReviewed, text="$text"',
    );
    return text;
  }

  // Format date
  String formatReviewDate(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} ນາທີທີ່ແລ້ວ';
      }
      return '${difference.inHours} ຊົ່ວໂມງທີ່ແລ້ວ';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ວັນທີ່ແລ້ວ';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
