import 'package:app_shoe/controller/onboard_c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  final Onboard_C = Get.put(OnboardC());

  Widget _buildOnboard(BuildContext context, int index) {
    var Size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Onboard_C.onboardData[index]['image']),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      Onboard_C.onboardData[index]['title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF5B9EE1),
                        fontSize: Size.width * 0.07,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      Onboard_C.onboardData[index]['description'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: Size.width * 0.033,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 80),
                  Container(
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          Onboard_C.onboardData.length,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color:
                                  index == Onboard_C.currentboard.value
                                      ? Color(0xFF5B9EE1)
                                      : Color(0xFFD9D9D9),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: 300,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF5B9EE1), Color(0xFF5B9EE1)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ElevatedButton(
                      onPressed: Onboard_C.onNextPage,
                      child: Obx(
                        () => Text(
                          Onboard_C.currentboard.value <
                                  Onboard_C.onboardData.length - 1
                              ? 'ຕໍ່ໄປ'
                              : 'ເລີ່ມຕົ້ນ',
                          style: TextStyle(
                            fontSize: Size.width * 0.07,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD8FFFF),
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // ເຮັດໃຫ້ປຸ່ມໂປ່ງໃສ
                        shadowColor: Colors.transparent, // ລົບເງົາ
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: _buildOnboard,
      itemCount: Onboard_C.onboardData.length,
      onPageChanged: Onboard_C.onPageChanged,
      controller: Onboard_C.pageonbord,
    );
  }
}
