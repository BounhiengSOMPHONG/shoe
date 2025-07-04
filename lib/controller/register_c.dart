import 'package:app_shoe/Services/apiconstants.dart';
import 'package:app_shoe/Services/apiservice.dart';
import 'package:app_shoe/view/Login/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class RegisterC extends GetxController {
  // Text controllers
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController(
    text: "ຊາຍ",
  );
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Password visibility
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;

  // Form validation
  final RxString confirmPasswordError = ''.obs;
  final RxString phoneError = ''.obs;
  final RxString emailError = ''.obs;
  final RxBool isFormValid = false.obs;
  final RxBool isLoading = false.obs;

  // Birthday dropdown selections
  final Rx<String?> selectedDay = Rx<String?>(null);
  final Rx<String?> selectedMonth = Rx<String?>(null);
  final Rx<String?> selectedYear = Rx<String?>(null);

  // Lists for dropdown items
  final List<String> days = List.generate(
    31,
    (index) => (index + 1).toString().padLeft(2, '0'),
  );

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<String> years = List.generate(
    100,
    (index) => (DateTime.now().year - index).toString(),
  );

  // Services
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
  }

  @override
  void onClose() {
    // Remove listeners
    phoneController.removeListener(validatePhone);
    emailController.removeListener(validateEmail);
    passwordController.removeListener(validatePasswordMatch);
    confirmPasswordController.removeListener(validatePasswordMatch);

    // Dispose controllers
    phoneController.dispose();
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    genderController.dispose();
    birthdayController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }

  void _setupListeners() {
    phoneController.addListener(() => validatePhone());
    emailController.addListener(() => validateEmail());
    passwordController.addListener(() => validatePasswordMatch());
    confirmPasswordController.addListener(() => validatePasswordMatch());

    // Update birthday field when dropdowns change
    ever(selectedDay, (_) => _updateBirthdayField());
    ever(selectedMonth, (_) => _updateBirthdayField());
    ever(selectedYear, (_) => _updateBirthdayField());
  }

  void _updateBirthdayField() {
    if (selectedDay.value != null &&
        selectedMonth.value != null &&
        selectedYear.value != null) {
      birthdayController.text =
          '${selectedYear.value}/${_getMonthNumber(selectedMonth.value!)}/${selectedDay.value}';
    }
  }

  String _getMonthNumber(String monthName) {
    final monthIndex = months.indexOf(monthName) + 1;
    return monthIndex.toString().padLeft(2, '0');
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void validatePasswordMatch() {
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = '';
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = "Passwords do not match";
    } else {
      confirmPasswordError.value = "";
    }
    _checkFormValidity();
  }

  void validatePhone() {
    final phone = phoneController.text;
    if (phone.isEmpty) {
      phoneError.value = 'กรุณากรอกเบอร์โทรศัพท์';
    } else if (phone.length < 8) {
      phoneError.value = 'เบอร์โทรศัพท์ต้องมีอย่างน้อย 8 หลัก';
    } else {
      phoneError.value = '';
    }
    _checkFormValidity();
  }

  void validateEmail() {
    final email = emailController.text;
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (email.isEmpty) {
      emailError.value = 'กรุณากรอกอีเมล';
    } else if (!emailRegex.hasMatch(email)) {
      emailError.value = 'รูปแบบอีเมลไม่ถูกต้อง';
    } else {
      emailError.value = '';
    }
    _checkFormValidity();
  }

  void _checkFormValidity() {
    isFormValid.value =
        phoneController.text.isNotEmpty &&
        phoneError.value.isEmpty &&
        emailController.text.isNotEmpty &&
        emailError.value.isEmpty &&
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        genderController.text.isNotEmpty &&
        birthdayController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        confirmPasswordError.value.isEmpty;
  }

  Future<void> register() async {
    if (!isFormValid.value) {
      _showErrorDialog('กรุณากรอกข้อมูลให้ถูกต้องและครบถ้วน');
      return;
    }

    // Show confirmation dialog
    _showConfirmationDialog();
  }

  void _showErrorDialog(String message) {
    Get.snackbar(
      'ข้อผิดพลาด',
      message,
      icon: const Icon(Icons.error, color: Colors.red),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void _showConfirmationDialog() {
    _updateBirthdayField();
    Get.defaultDialog(
      title: "ตรวจสอบข้อมูล",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("โทรศัพท์: ${phoneController.text}"),
          Text("อีเมล: ${emailController.text}"),
          Text("ชื่อ: ${firstNameController.text} ${lastNameController.text}"),
          Text("เพศ: ${genderController.text}"),
          Text("วันเกิด: ${birthdayController.text}"),
        ],
      ),
      textConfirm: "ตกลง",
      confirmTextColor: Colors.white,
      onConfirm: () => _submitRegistration(),
      textCancel: "ยกเลิก",
    );
  }

  Future<void> _submitRegistration() async {
    Get.back();
    isLoading.value = true;
    EasyLoading.show(status: 'Loading...');

    try {
      final response = await _apiService.post(
        ApiConstants.registerEndpoint,
        data: {
          'Phone': phoneController.text,
          'Email': emailController.text,
          'FirstName': firstNameController.text,
          'LastName': lastNameController.text,
          'Sex': genderController.text,
          'Datebirth': birthdayController.text,
          'Password': passwordController.text,
        },
      );

      isLoading.value = false;
      EasyLoading.dismiss();

      if (response.message?.toLowerCase().contains('success') == true) {
        Get.snackbar(
          'สำเร็จ',
          'ลงทะเบียนสำเร็จ',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        navigateToWelcome();
      } else {
        _showErrorDialog(
          response.message ?? 'การลงทะเบียนล้มเหลว โปรดลองอีกครั้ง',
        );
      }
    } catch (e) {
      isLoading.value = false;
      EasyLoading.dismiss();
      _showErrorDialog('เกิดข้อผิดพลาดในการเชื่อมต่อ โปรดลองอีกครั้ง');
      print('Registration error: $e');
    }
  }

  void clearForm() {
    phoneController.clear();
    emailController.clear();
    firstNameController.clear();
    lastNameController.clear();
    genderController.text = "ຊາຍ";
    birthdayController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    selectedDay.value = null;
    selectedMonth.value = null;
    selectedYear.value = null;

    phoneError.value = '';
    emailError.value = '';
    confirmPasswordError.value = '';
    isFormValid.value = false;
  }

  void navigateToWelcome() {
    clearForm();
    Get.to(
      () => Welcome(),
      transition: Transition.leftToRight,
      duration: const Duration(milliseconds: 300),
    );
  }
}
