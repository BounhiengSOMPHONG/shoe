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
  final RxString passwordError = ''.obs;
  final RxString birthdayError = ''.obs;
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
    passwordController.addListener(() => validatePassword());
    passwordController.addListener(() => validatePasswordMatch());
    confirmPasswordController.addListener(() => validatePasswordMatch());

    // Update birthday field when dropdowns change
    ever(selectedDay, (_) => _updateBirthdayField());
    ever(selectedMonth, (_) => _updateBirthdayField());
    ever(selectedYear, (_) => _updateBirthdayField());

    // Validate birthday when any dropdown changes
    ever(selectedDay, (_) => validateBirthday());
    ever(selectedMonth, (_) => validateBirthday());
    ever(selectedYear, (_) => validateBirthday());
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
      confirmPasswordError.value = "ລະຫັດຜ່ານບໍ່ກົງກັນ";
    } else {
      confirmPasswordError.value = "";
    }
    _checkFormValidity();
  }

  void validatePhone() {
    final phone = phoneController.text;
    if (phone.isEmpty) {
      phoneError.value = 'ກະລຸນາປ້ອນເບີໂທ';
    } else if (phone.length != 8) {
      phoneError.value = 'ກະລຸນາປ້ອນເບີໂທໃຫ້ຄົບ 8 ຫລັກ';
    } else {
      phoneError.value = '';
    }
    _checkFormValidity();
  }

  void validateEmail() {
    final email = emailController.text;
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (email.isEmpty) {
      emailError.value = 'ກະລຸນາປ້ອນອີເມວ';
    } else if (!emailRegex.hasMatch(email)) {
      emailError.value = 'ຮູບແບບອີເມວບໍ່ຖືກຕ້ອງ';
    } else {
      emailError.value = '';
    }
    _checkFormValidity();
  }

  void validatePassword() {
    final password = passwordController.text;
    if (password.isEmpty) {
      passwordError.value = '';
    } else if (password.length < 6) {
      passwordError.value = 'ລະຫັດຜ່ານຕ້ອງມີອຢ່າງນ້ອຍ 6 ຕັວອັກສະນາ';
    } else {
      passwordError.value = '';
    }
    _checkFormValidity();
  }

  void validateBirthday() {
    if (selectedDay.value == null ||
        selectedMonth.value == null ||
        selectedYear.value == null) {
      birthdayError.value = '';
      return;
    }

    try {
      final year = int.parse(selectedYear.value!);
      final month = months.indexOf(selectedMonth.value!) + 1;
      final day = int.parse(selectedDay.value!);

      final birthDate = DateTime(year, month, day);
      final today = DateTime.now();
      int age = today.year - birthDate.year;

      // Check if birthday has occurred this year
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      if (age < 18) {
        birthdayError.value = 'ທ່ານຕ້ອງມີອາຢຸອຢ່າງນ້ອຍ 18 ປີ';
      } else {
        birthdayError.value = '';
      }
    } catch (e) {
      birthdayError.value = '';
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
        birthdayError.value.isEmpty &&
        passwordController.text.isNotEmpty &&
        passwordError.value.isEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        confirmPasswordError.value.isEmpty;
  }

  Future<void> register() async {
    if (!isFormValid.value) {
      _showErrorDialog('ກະລຸນາປ້ອນຂໍ້ມູນໃຫ້ຖືກຕ້ອງ ແລະ ຄົບຖ້ວນ');
      return;
    }

    // Show confirmation dialog
    _showConfirmationDialog();
  }

  void _showErrorDialog(String message) {
    Get.snackbar(
      'ເກີດຂໍ້ຜິດພາດ',
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
      title: "ກວດສອບຂໍ້ມູນ",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ເບີໂທ: +85620${phoneController.text}"),
          Text("ອີເມວ: ${emailController.text}"),
          Text("ຊື່: ${firstNameController.text} ${lastNameController.text}"),
          Text("ເພຨ: ${genderController.text}"),
          Text("ວັນເກິດ: ${birthdayController.text}"),
        ],
      ),
      textConfirm: "ຕົກລົງ",
      confirmTextColor: Colors.white,
      onConfirm: () => _submitRegistration(),
      textCancel: "ຍົກເລີກ",
    );
  }

  Future<void> _submitRegistration() async {
    Get.back();
    isLoading.value = true;
    EasyLoading.show(status: 'Loading...');

    try {
      final requestData = {
        'Phone': '+85620${phoneController.text}',
        'Email': emailController.text,
        'FirstName': firstNameController.text,
        'LastName': lastNameController.text,
        'Sex': genderController.text,
        'Datebirth': birthdayController.text,
        'Password': passwordController.text,
        'Images': null, // Optional field
      };

      // Debug logging
      print('Registration request data:');
      print(requestData);

      final response = await _apiService.post(
        ApiConstants.registerEndpoint,
        data: requestData,
      );

      isLoading.value = false;
      EasyLoading.dismiss();

      // Debug logging
      print('Registration response:');
      print('Success: ${response.success}');
      print('Message: ${response.message}');
      print('Data: ${response.data}');

      if (response.success == true ||
          response.message?.toLowerCase().contains('success') == true ||
          response.message?.toLowerCase().contains('insert successful') ==
              true ||
          response.message?.toLowerCase().contains('registration successful') ==
              true) {
        Get.snackbar(
          'ສຳເລັດ',
          'ລົງທະບຽນສຳເລັດ',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        navigateToWelcome();
      } else {
        _showErrorDialog(response.message ?? 'ລົງທະບຽນບໍ່ສຳເລັດ ກະລຸນາລອງໃໝ່');
      }
    } catch (e) {
      isLoading.value = false;
      EasyLoading.dismiss();
      _showErrorDialog('ເກີດຂໍ້ຜິດພາດໃນການເຊື່ອມຕ່າງ ກະລຸນາລອງໃໝ່');
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
    passwordError.value = '';
    birthdayError.value = '';
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
