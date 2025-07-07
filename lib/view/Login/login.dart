import 'package:app_shoe/controller/login_c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginC = Get.put(LoginC());
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
              // avatar icon
              SizedBox(height: Size.height * 0.1),
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 100, color: Colors.black),
              ),
              SizedBox(height: Size.height * 0.05),
              // Phone or Email field
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() {
                  String identifier = _loginC.savedIdentifier.value;
                  if (identifier.isNotEmpty) {
                    if (identifier.contains('@')) {
                      // Mask email
                      List<String> parts = identifier.split('@');
                      String username = parts[0];
                      String domain = parts[1];

                      // Show first 2 characters of username, mask the rest
                      String maskedUsername =
                          username.length > 2
                              ? username.substring(0, 2) +
                                  '*' * (username.length - 2)
                              : username;

                      String maskedEmail = maskedUsername + '@' + domain;
                      return Column(
                        children: [
                          Text(
                            maskedEmail,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          // InkWell(
                          //   onTap: () {
                          //     _loginC.navigateToWelcome();
                          //   },
                          //   child: Text(
                          //     'ປ່ຽນບັນຊີ',
                          //     style: TextStyle(
                          //       color: Color(0xFF1723AC),
                          //       fontSize: 14,
                          //       decoration: TextDecoration.underline,
                          //     ),
                          //   ),
                          // ),
                        ],
                      );
                    } else {
                      // Mask phone number
                      // Show first 4 digits and last 2 digits, mask the middle
                      String maskedPhone =
                          identifier.length > 6
                              ? identifier.substring(0, 4) +
                                  '*' * (identifier.length - 6) +
                                  identifier.substring(identifier.length - 2)
                              : identifier;
                      return Column(
                        children: [
                          Text(
                            maskedPhone,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              _loginC.navigateToWelcome();
                            },
                            child: Text(
                              'ປ່ຽນບັນຊີ',
                              style: TextStyle(
                                color: Color(0xFF1723AC),
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  } else {
                    return Column(
                      children: [
                        Text(
                          'ຍັງບໍ່ໄດ້ເຂົ້າສູ່ລະບົບ',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            _loginC.navigateToWelcome();
                          },
                          child: Text(
                            'ເຂົ້າສູ່ລະບົບ',
                            style: TextStyle(
                              color: Color(0xFF1723AC),
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }),
              ),
              SizedBox(height: Size.height * 0.02),
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
                            _loginC.isPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0xFF1723AC),
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
                          color: Color(0xFF1723AC),
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
                    colors: [Color(0xFF1723AC), Color(0xFF1723AC)],
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
              SizedBox(height: Size.height * 0.05),
              // link to register
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: _loginC.navigateToWelcome,
                      child: Text(
                        "ປ່ຽນໝາຍເລກໃຫມ່",
                        style: TextStyle(
                          color: Color(0xFF1723AC),
                          fontSize: 18,
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
