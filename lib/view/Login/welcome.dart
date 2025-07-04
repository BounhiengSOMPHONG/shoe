import 'package:app_shoe/controller/login_c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final _loginC = Get.put(LoginC());
  @override
  Widget build(BuildContext context) {
    var Size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo and Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 120,
                        child: Image.asset(
                          'images/LOGO.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 150,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color(0xFF1723AC),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), // เงาอ่อน
                              blurRadius: 6.0, // กระจายออกกว้าง
                              spreadRadius: 1.0,
                              offset: Offset(0, 0), // เงาอยู่ที่ไหน
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'ເຂົ້າສູ່ລະບົບ',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5B9EE1),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'ໃສ່ App ',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: 'SHOE',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5B9EE1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Super APP',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 70),
                  // Phone or Email field
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _loginC.emailPhoneController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'ເບີໂທ ຫຼື ອີເມວ',
                        labelStyle: TextStyle(
                          color: Color(0xFF000000).withOpacity(0.3),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFF0500D4),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFF0500D4),
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(20),
                        suffixIcon: Container(
                          margin: EdgeInsets.only(right: 10),
                          child: IconButton(
                            icon: Image.asset('images/icons/close.png'),
                            onPressed: () {
                              _loginC.emailPhoneController.clear();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  // Password field
                  Obx(
                    () => Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _loginC.passwordController,
                        obscureText: _loginC.isPasswordHidden.value,
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
                              color: Color(0xFF0500D4),
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xFF0500D4),
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(20),
                          suffixIcon: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: IconButton(
                              icon: Icon(
                                _loginC.isPasswordHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Color(0xFF0500D4),
                              ),
                              onPressed: _loginC.togglePasswordVisibility,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // link to reset password
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 30),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "ລືມ ",
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                        InkWell(
                          onTap: () {
                            print("Password tapped");
                          },
                          child: Text(
                            "ລະຫັດຜ່ານ",
                            style: TextStyle(
                              color: Color(0xFF0500D4),
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Size.height * 0.07),
                  // Button to login
                  Container(
                    width: Size.width * 0.75,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1932D7), Color(0xFF2685D2)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ElevatedButton(
                      onPressed: _loginC.login,
                      child: Text(
                        'ເຂົ້າສູ່ລະບົບ',
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
                  SizedBox(height: Size.height * 0.3),
                  // link to register
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
                          onTap: _loginC.navigateToRegister,
                          child: Text(
                            "ລົງທະບຽນ",
                            style: TextStyle(
                              color: Color(0xFF1932D7),
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
        ),
      ),
    );
  }
}
