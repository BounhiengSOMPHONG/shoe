import 'package:app_shoe/Services/apiconstants.dart';
import 'package:app_shoe/Services/apiservice.dart';
import 'package:app_shoe/view/Home/layout.dart';
import 'package:app_shoe/view/Login/register.dart';
import 'package:app_shoe/view/Login/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginC extends GetxController {
  // Controllers
  final TextEditingController emailPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Observables
  final RxBool isPasswordHidden = true.obs;
  final RxBool isLoading = false.obs;
  final RxString emailPhoneError = ''.obs;

  // Services
  final ApiService _apiService = ApiService();

  // Saved identifier
  final RxString savedIdentifier = ''.obs;

  // Flag to track if controller is disposed
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    loadSavedIdentifier();
    _setupListeners();
  }

  void _setupListeners() {
    emailPhoneController.addListener(() => validateEmailPhone());
  }

  //load saved identifier from shared preferences
  Future<void> loadSavedIdentifier() async {
    if (_isDisposed) return; // Don't proceed if controller is disposed

    final prefs = await SharedPreferences.getInstance();
    savedIdentifier.value = prefs.getString('identifier') ?? '';
    if (savedIdentifier.value.isNotEmpty) {
      try {
        emailPhoneController.text = savedIdentifier.value;
      } catch (e) {
        // Controller might be disposed, ignore the error
        print('Controller disposed, skipping text setting');
      }
    }
  }

  @override
  void onClose() {
    _isDisposed = true;
    emailPhoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Validate email or phone number
  void validateEmailPhone() {
    if (_isDisposed) return; // Don't proceed if controller is disposed

    try {
      final input = emailPhoneController.text.trim();
      if (input.isEmpty) {
        emailPhoneError.value = '';
        return;
      }

      // Check if it's an email
      if (input.contains('@')) {
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (!emailRegex.hasMatch(input)) {
          emailPhoneError.value = 'ຮູບແບບອີເມວບໍ່ຖືກຕ້ອງ';
        } else {
          emailPhoneError.value = '';
        }
      } else {
        // Check if it's a phone number
        if (input.length != 8) {
          emailPhoneError.value = 'ກະລຸນາປ້ອນເບີໂທໃຫ້ຄົບ 8 ຫຼັກ';
        } else if (!RegExp(r'^[0-9]+$').hasMatch(input)) {
          emailPhoneError.value = 'ເບີໂທໂທ້ອງເປັນຕົວເລກເທົ່ານັ້ນ';
        } else {
          emailPhoneError.value = '';
        }
      }
    } catch (e) {
      // Controller might be disposed, ignore the error
      print('Controller disposed during validation');
    }
  }

  // Format identifier for API
  String _formatIdentifier(String identifier) {
    if (identifier.contains('@')) {
      // It's an email, return as is
      return identifier;
    } else {
      // It's a phone number, prepend +85620
      return '+85620$identifier';
    }
  }

  // Login function
  Future<void> login() async {
    if (_isDisposed) return; // Don't proceed if controller is disposed
    if (!_validateInputs()) return;

    try {
      final identifier = emailPhoneController.text.trim();
      final formattedIdentifier = _formatIdentifier(identifier);

      isLoading.value = true;
      EasyLoading.show(status: 'Loading...');

      try {
        final response = await _apiService.post(
          ApiConstants.loginEndpoint,
          data: {
            'identifier': formattedIdentifier,
            'Password': passwordController.text,
          },
        );

        isLoading.value = false;
        EasyLoading.dismiss();

        if (response.success) {
          final token = response.data['token'];
          // บันทึก token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          //save user id
          final userId = response.data['userId'].toString();
          await prefs.setString('userId', userId);
          // save identifier (original format for display)
          await prefs.setString('identifier', identifier);
          // save formatted identifier for API calls
          await prefs.setString('formattedIdentifier', formattedIdentifier);
          // save login status
          await prefs.setString('isLoggedIn', 'true');

          // Update saved identifier for display
          await updateSavedIdentifier(identifier);

          // ตรวจสอบอีกครั้งว่าบันทึกสำเร็จ
          final storedToken = prefs.getString('token');
          print('Stored token after login: $storedToken');
          print('User ID after login: $userId');
          print('Saved identifier: $identifier');
          print('Formatted identifier: $formattedIdentifier');

          _navigateToHome();
        } else {
          _showErrorMessage(response.message ?? 'Login failed');
        }
      } catch (e) {
        isLoading.value = false;
        EasyLoading.dismiss();
        _showErrorMessage('Connection error. Please try again.');
        print('Login error: $e');
      }
    } catch (e) {
      // Controller might be disposed, ignore the error
      print('Controller disposed during login');
    }
  }

  bool _validateInputs() {
    if (_isDisposed) return false; // Don't proceed if controller is disposed

    try {
      final identifier = emailPhoneController.text.trim();

      if (identifier.isEmpty) {
        _showErrorMessage('ກະລຸນາປ້ອນອີເມວ ຫຼື ເບີໂທ');
        return false;
      }

      if (emailPhoneError.value.isNotEmpty) {
        _showErrorMessage(emailPhoneError.value);
        return false;
      }

      if (passwordController.text.isEmpty) {
        _showErrorMessage('ກະລຸນາປ້ອນລະຫັດຜ່ານ');
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
      'ເກີດຂໍ້ຜິດພາດ',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  void _navigateToHome() {
    if (_isDisposed) return; // Don't proceed if controller is disposed
    Get.offAll(() => Layout());
  }

  void navigateToRegister() {
    if (_isDisposed) return; // Don't proceed if controller is disposed
    Get.to(
      () => Register(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  void navigateToWelcome() {
    if (_isDisposed) return; // Don't proceed if controller is disposed
    Get.to(
      () => Welcome(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // Update shared preferences when identifier changes
  Future<void> updateSavedIdentifier(String newIdentifier) async {
    if (_isDisposed) return; // Don't proceed if controller is disposed

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('identifier', newIdentifier);
    savedIdentifier.value = newIdentifier;

    // Also update formatted identifier
    final formattedIdentifier = _formatIdentifier(newIdentifier);
    await prefs.setString('formattedIdentifier', formattedIdentifier);
  }

  void logout() async {
    if (_isDisposed) return; // Don't proceed if controller is disposed

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('identifier');
    await prefs.remove('formattedIdentifier');
    await prefs.setString('isLoggedIn', 'false');

    Get.to(() => Welcome());
  }
}
