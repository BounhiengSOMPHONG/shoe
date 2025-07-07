import 'package:app_shoe/controller/register_c.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _registerC = Get.put(RegisterC());
  String _selectedGender = 'ຊາຍ';
  Widget customRadio(String gender) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
          _registerC.genderController.text = gender;
        });
      },
      child: Row(
        children: [
          Text(gender),
          SizedBox(width: 5),
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:
                      isSelected
                          ? LinearGradient(
                            colors: [Color(0xFF1723AC), Color(0xFF1723AC)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                          : null,
                  color: isSelected ? null : Colors.grey.shade300,
                ),
              ),
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var Size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Logo
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    width: 60,
                    height: 70,
                    child: Image.asset('images/LOGO.png', fit: BoxFit.contain),
                  ),
                ],
              ),
              //Title
              Container(
                child: Text(
                  'ລົງທະບຽນ',
                  style: TextStyle(
                    color: Color(0xFF1932D7),
                    fontSize: Size.width * 0.09,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40),
              //TextField for Phone
              Obx(
                () => Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _registerC.phoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      _registerC.validatePhone(); // ເອີ້ນຟັງຊັ່ນເຊັກເບີ
                    },
                    decoration: InputDecoration(
                      labelText: 'ເບີໂທ',
                      labelStyle: TextStyle(
                        color: Color(0xFF000000).withOpacity(0.3),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFF1723AC),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFF1723AC),
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(20),
                      errorText:
                          _registerC.phoneError.value == ''
                              ? null
                              : _registerC.phoneError.value,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
              //TextField for Email
              Obx(
                () => Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _registerC.emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      _registerC.validateEmail();
                    },
                    decoration: InputDecoration(
                      labelText: 'ອີເມວ',
                      labelStyle: TextStyle(
                        color: Color(0xFF000000).withOpacity(0.3),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFF1723AC),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFF1723AC),
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(20),
                      errorText:
                          _registerC.emailError.value == ''
                              ? null
                              : _registerC.emailError.value,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              //TextField for FirstName
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _registerC.firstNameController,
                  decoration: InputDecoration(
                    labelText: 'ຊື່',
                    labelStyle: TextStyle(
                      color: Color(0xFF000000).withOpacity(0.3),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xFF1723AC),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xFF1723AC),
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
              ),
              SizedBox(height: 30),
              //TextField for LastName
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _registerC.lastNameController, //null,
                  decoration: InputDecoration(
                    labelText: 'ນາມສະກຸນ',
                    labelStyle: TextStyle(
                      color: Color(0xFF000000).withOpacity(0.3),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xFF1723AC),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(0xFF1723AC),
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
              ),
              SizedBox(height: 30),
              //Redio Gengder
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ເພດ :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    customRadio("ຊາຍ"),
                    customRadio("ຍິງ"),
                  ],
                ),
              ),
              SizedBox(height: 30),
              //BirthDay
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // เลือกวัน
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Size.width * 0.02,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF1723AC),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButton<String>(
                          value: _registerC.selectedDay.value,
                          hint: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text("ວັນ"),
                          ),
                          underline: SizedBox(),
                          icon: Image.asset('images/icons/Arrow.png'),
                          items:
                              _registerC.days.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            _registerC.selectedDay.value = newValue;
                            _registerC.birthdayController.text =
                                '${_registerC.selectedYear.value ?? ''}-${_registerC.selectedMonth.value ?? ''}-${_registerC.selectedDay.value ?? ''}';
                          },
                        ),
                      ),
                      SizedBox(width: 5),
                      // เลือกเดือน
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Size.width * 0.04,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF1723AC),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButton<String>(
                          value: _registerC.selectedMonth.value,
                          hint: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text("ເດືອນ"),
                          ),
                          underline: SizedBox(),
                          icon: Image.asset('images/icons/Arrow.png'),
                          items:
                              _registerC.months.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            _registerC.selectedMonth.value = newValue;
                            _registerC.birthdayController.text =
                                '${_registerC.selectedYear.value ?? ''}-${_registerC.selectedMonth.value ?? ''}-${_registerC.selectedDay.value ?? ''}';
                          },
                        ),
                      ),
                      SizedBox(width: 5),
                      // เลือกปี
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Size.width * 0.03,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF1723AC),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButton<String>(
                          value: _registerC.selectedYear.value,
                          hint: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text("ປີ"),
                          ),
                          underline: SizedBox(),
                          icon: Image.asset('images/icons/Arrow.png'),
                          items:
                              _registerC.years.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            _registerC.selectedYear.value = newValue;
                            _registerC.birthdayController.text =
                                '${_registerC.selectedYear.value ?? ''}-${_registerC.selectedMonth.value ?? ''}-${_registerC.selectedDay.value ?? ''}';
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Birthday error display
              Obx(
                () =>
                    _registerC.birthdayError.value.isNotEmpty
                        ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            _registerC.birthdayError.value,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        )
                        : SizedBox.shrink(),
              ),
              SizedBox(height: 30),

              //TextField for Password
              Obx(
                () => Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _registerC.passwordController,
                    obscureText: _registerC.isPasswordHidden.value,
                    decoration: InputDecoration(
                      labelText: 'ລະຫັດຜ່ານ',
                      labelStyle: TextStyle(
                        color: Color(0xFF000000).withOpacity(0.3),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFF1723AC),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFF1723AC),
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(20),
                      suffixIcon: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: IconButton(
                          icon: Icon(
                            _registerC.isPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xFF1723AC),
                          ),
                          onPressed: _registerC.togglePasswordVisibility,
                        ),
                      ),
                      errorText:
                          _registerC.passwordError.value == ''
                              ? null
                              : _registerC.passwordError.value,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              //TextField for Password Confirm
              Obx(
                () => Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _registerC.confirmPasswordController,
                    obscureText: _registerC.isConfirmPasswordHidden.value,
                    onChanged: (value) => _registerC.validatePasswordMatch(),

                    decoration: InputDecoration(
                      labelText: 'ຢືນຢັນລະຫັດຜ່ານ',
                      labelStyle: TextStyle(
                        color: Color(0xFF000000).withOpacity(0.3),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFF1723AC),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFF1723AC),
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(20),
                      suffixIcon: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: IconButton(
                          icon: Icon(
                            _registerC.isConfirmPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xFF1723AC),
                          ),
                          onPressed: _registerC.toggleConfirmPasswordVisibility,
                        ),
                      ),
                      errorText:
                          _registerC.confirmPasswordError.value == ''
                              ? null
                              : _registerC.confirmPasswordError.value,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              //Button Register
              Container(
                width: Size.width * 0.75,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1723AC), Color(0xFF1723AC)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ElevatedButton(
                  onPressed: _registerC.register,
                  child: Text(
                    'ລົງທະບຽນ',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // link to welcome
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "ເຈົ້າມີບັນຊີບໍ່? ",
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    InkWell(
                      onTap: _registerC.navigateToWelcome,
                      child: Text(
                        "ເຂົ້າສູ່ລະບົບ",
                        style: TextStyle(
                          color: Color(0xFF1723AC),
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
