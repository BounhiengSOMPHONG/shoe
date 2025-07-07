import 'package:app_shoe/model/user_m.dart';
import 'package:app_shoe/services/apiconstants.dart';
import 'package:app_shoe/services/apiservice.dart';
import 'package:app_shoe/view/Login/welcome.dart';
import 'package:app_shoe/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileC extends GetxController {
  // Controllers for form fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController datebirthController = TextEditingController();

  // Password change controllers
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Observables
  final RxBool isLoading = false.obs;
  final RxBool isEditing = false.obs;
  final RxBool isChangingPassword = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxString selectedSex = 'ຊາຍ'.obs;

  // Password visibility
  final RxBool isCurrentPasswordHidden = true.obs;
  final RxBool isNewPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;

  // Services
  final ApiService _apiService = ApiService();

  // Flag to track if controller is disposed
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  @override
  void onClose() {
    _isDisposed = true;
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    datebirthController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Load user profile data
  Future<void> loadUserProfile() async {
    if (_isDisposed) return; // Don't proceed if controller is disposed

    isLoading.value = true;
    EasyLoading.show(status: 'Loading profile...');

    try {
      final response = await _apiService.get(
        ApiConstants.getUserProfileEndpoint,
      );

      if (response.success && !_isDisposed) {
        currentUser.value = User.fromJson(response.data['data']);
        _populateControllers();
      } else if (!_isDisposed) {
        _showErrorMessage(response.message ?? 'Failed to load profile');
      }
    } catch (e) {
      if (!_isDisposed) {
        _showErrorMessage('Connection error. Please try again.');
        print('Load profile error: $e');
      }
    } finally {
      if (!_isDisposed) {
        isLoading.value = false;
        EasyLoading.dismiss();
      }
    }
  }

  // Convert sex values between different formats
  String _convertSexToLao(String? sex) {
    if (sex == null || sex.isEmpty) return 'ຊາຍ';

    switch (sex.toLowerCase()) {
      case 'male':
      case 'm':
      case 'ຊາຍ':
        return 'ຊາຍ';
      case 'female':
      case 'f':
      case 'ຍິງ':
        return 'ຍິງ';
      default:
        return 'ຊາຍ'; // Default fallback
    }
  }

  // Convert Lao sex values back to English for API
  String _convertSexToApi(String sex) {
    switch (sex) {
      case 'ຊາຍ':
        return 'Male';
      case 'ຍິງ':
        return 'Female';
      default:
        return 'Male';
    }
  }

  // Populate form controllers with user data
  void _populateControllers() {
    if (_isDisposed) return; // Don't proceed if controller is disposed

    try {
      final user = currentUser.value;
      if (user != null) {
        firstNameController.text = user.firstName;
        lastNameController.text = user.lastName;
        emailController.text = user.email;
        phoneController.text = user.phone ?? '';

        // Handle date formatting properly
        String dateValue = user.datebirth ?? '';
        if (dateValue.isNotEmpty) {
          // If the date contains 'T' (ISO format), extract only the date part
          if (dateValue.contains('T')) {
            dateValue = dateValue.split('T')[0];
          }
          datebirthController.text = dateValue;
        } else {
          datebirthController.text = '';
        }

        // Convert sex value to Lao format for dropdown
        selectedSex.value = _convertSexToLao(user.sex);
      }
    } catch (e) {
      // Controller might be disposed, ignore the error
      print('Controller disposed during populate controllers');
    }
  }

  // Toggle edit mode
  void toggleEditMode() {
    if (_isDisposed) return; // Don't proceed if controller is disposed

    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      // Reset form when canceling edit
      _populateControllers();
    }
  }

  // Toggle password change mode
  void togglePasswordChangeMode() {
    if (_isDisposed) return; // Don't proceed if controller is disposed

    isChangingPassword.value = !isChangingPassword.value;
    if (!isChangingPassword.value) {
      // Clear password fields when canceling
      try {
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } catch (e) {
        // Controller might be disposed, ignore the error
        print('Controller disposed during password field clearing');
      }
    }
  }

  // Toggle password visibility
  void toggleCurrentPasswordVisibility() {
    if (_isDisposed) return; // Don't proceed if controller is disposed
    isCurrentPasswordHidden.value = !isCurrentPasswordHidden.value;
  }

  void toggleNewPasswordVisibility() {
    if (_isDisposed) return; // Don't proceed if controller is disposed
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    if (_isDisposed) return; // Don't proceed if controller is disposed
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  // Change password
  Future<void> changePassword() async {
    if (_isDisposed) return; // Don't proceed if controller is disposed
    if (!_validatePasswordInputs()) return;

    isLoading.value = true;
    EasyLoading.show(status: 'Changing password...');

    try {
      final response = await _apiService.put(
        ApiConstants.changePasswordEndpoint,
        data: {
          'currentPassword': currentPasswordController.text,
          'newPassword': newPasswordController.text,
        },
      );

      if (response.success && !_isDisposed) {
        isChangingPassword.value = false;
        // Clear password fields
        try {
          currentPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
        } catch (e) {
          // Controller might be disposed, ignore the error
          print('Controller disposed during password clearing');
        }
        _showSuccessMessage('Password changed successfully');
      } else if (!_isDisposed) {
        _showErrorMessage(response.message ?? 'Failed to change password');
      }
    } catch (e) {
      if (!_isDisposed) {
        _showErrorMessage('Connection error. Please try again.');
        print('Change password error: $e');
      }
    } finally {
      if (!_isDisposed) {
        isLoading.value = false;
        EasyLoading.dismiss();
      }
    }
  }

  // Validation for password change
  bool _validatePasswordInputs() {
    if (_isDisposed) return false; // Don't proceed if controller is disposed

    try {
      if (currentPasswordController.text.isEmpty) {
        _showErrorMessage('กรุณากรอกรหัสผ่านปัจจุบัน');
        return false;
      }

      if (newPasswordController.text.isEmpty) {
        _showErrorMessage('กรุณากรอกรหัสผ่านใหม่');
        return false;
      }

      if (newPasswordController.text.length < 6) {
        _showErrorMessage('รหัสผ่านใหม่ต้องมีอย่างน้อย 6 ตัวอักษร');
        return false;
      }

      if (confirmPasswordController.text.isEmpty) {
        _showErrorMessage('กรุณายืนยันรหัสผ่านใหม่');
        return false;
      }

      if (newPasswordController.text != confirmPasswordController.text) {
        _showErrorMessage('รหัสผ่านใหม่ไม่ตรงกัน');
        return false;
      }

      if (currentPasswordController.text == newPasswordController.text) {
        _showErrorMessage('รหัสผ่านใหม่ต้องแตกต่างจากรหัสผ่านปัจจุบัน');
        return false;
      }

      return true;
    } catch (e) {
      // Controller might be disposed, ignore the error
      print('Controller disposed during password validation');
      return false;
    }
  }

  // Update user profile
  Future<void> updateProfile() async {
    if (_isDisposed) return; // Don't proceed if controller is disposed
    if (!_validateInputs()) return;

    isLoading.value = true;
    EasyLoading.show(status: 'Updating profile...');

    try {
      final response = await _apiService.put(
        ApiConstants.updateUserProfileEndpoint,
        data: {
          'FirstName': firstNameController.text.trim(),
          'LastName': lastNameController.text.trim(),
          'Email': emailController.text.trim(),
          'Phone': phoneController.text.trim(),
          'Datebirth':
              datebirthController.text.trim().isEmpty
                  ? null
                  : datebirthController.text.trim(),
          'Sex': _convertSexToApi(selectedSex.value),
        },
      );

      if (response.success && !_isDisposed) {
        currentUser.value = User.fromJson(response.data['data']);
        isEditing.value = false;
        _showSuccessMessage('Profile updated successfully');
      } else if (!_isDisposed) {
        _showErrorMessage(response.message ?? 'Failed to update profile');
      }
    } catch (e) {
      if (!_isDisposed) {
        _showErrorMessage('Connection error. Please try again.');
        print('Update profile error: $e');
      }
    } finally {
      if (!_isDisposed) {
        isLoading.value = false;
        EasyLoading.dismiss();
      }
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    if (_isDisposed) return; // Don't proceed if controller is disposed

    // Show confirmation dialog
    bool confirmDelete =
        await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Delete Account'),
            content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmDelete) return;

    isLoading.value = true;
    EasyLoading.show(status: 'Deleting account...');

    try {
      final response = await _apiService.delete(
        ApiConstants.deleteUserProfileEndpoint,
      );

      if (response.success) {
        print('Account deletion successful, clearing data...');

        // Clear stored data and navigate to welcome
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        print('SharedPreferences cleared');

        // Dismiss loading before navigation
        isLoading.value = false;
        EasyLoading.dismiss();
        print('Loading dismissed');

        _showSuccessMessage('Account deleted successfully');
        print('Success message shown');

        // Mark controller as disposed and navigate
        _isDisposed = true;
        print('Controller marked as disposed, navigating...');
        Get.offAll(() => Splash());
      } else if (!_isDisposed) {
        print('Account deletion failed: ${response.message}');
        _showErrorMessage(response.message ?? 'Failed to delete account');
      }
    } catch (e) {
      if (!_isDisposed) {
        _showErrorMessage('Connection error. Please try again.');
        print('Delete account error: $e');
      }
    } finally {
      if (!_isDisposed) {
        isLoading.value = false;
        EasyLoading.dismiss();
      }
    }
  }

  // Select date for date of birth
  Future<void> selectDate(BuildContext context) async {
    if (_isDisposed) return; // Don't proceed if controller is disposed

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          datebirthController.text.isNotEmpty
              ? DateTime.tryParse(datebirthController.text) ?? DateTime.now()
              : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && !_isDisposed) {
      try {
        datebirthController.text =
            picked.toString().split(' ')[0]; // Format: YYYY-MM-DD
      } catch (e) {
        // Controller might be disposed, ignore the error
        print('Controller disposed during date selection');
      }
    }
  }

  // Validation
  bool _validateInputs() {
    if (_isDisposed) return false; // Don't proceed if controller is disposed

    try {
      if (firstNameController.text.trim().isEmpty) {
        _showErrorMessage('กรุณากรอกชื่อ');
        return false;
      }

      if (lastNameController.text.trim().isEmpty) {
        _showErrorMessage('กรุณากรอกนามสกุล');
        return false;
      }

      if (emailController.text.trim().isEmpty) {
        _showErrorMessage('กรุณากรอกอีเมล');
        return false;
      }

      if (!GetUtils.isEmail(emailController.text.trim())) {
        _showErrorMessage('กรุณากรอกอีเมลที่ถูกต้อง');
        return false;
      }

      return true;
    } catch (e) {
      // Controller might be disposed, ignore the error
      print('Controller disposed during validation');
      return false;
    }
  }

  void _showErrorMessage(String message) {
    if (_isDisposed) return; // Don't proceed if controller is disposed

    Get.snackbar(
      'ข้อผิดพลาด',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  void _showSuccessMessage(String message) {
    if (_isDisposed) return; // Don't proceed if controller is disposed

    try {
      Get.snackbar(
        'สำเร็จ',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('Error showing success message: $e');
    }
  }
}
