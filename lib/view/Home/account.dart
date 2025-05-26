import 'package:app_shoe/controller/account/account_c.dart';
import 'package:app_shoe/controller/login_c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final _loginC = Get.put(LoginC());
  @override
  Widget build(BuildContext context) {
    final _account = Get.put(AccountC());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ส่วนบนโปรไฟล์พร้อม ClipPath
            Stack(
              children: [
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(height: 350, color: const Color(0xFF5CDCB5)),
                ),
                Column(
                  children: [
                    const SizedBox(height: 50), // เพิ่มระยะห่างด้านบน
                    // โลโก้
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Image.asset(
                          'images/TUV.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // รูปโปรไฟล์
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.black45,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'NAME',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Text(
                      'NAME@gmail.com',
                      style: TextStyle(fontSize: 20, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 15),

            // กล่องแสดงยอดเงิน
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 100),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              decoration: BoxDecoration(
                color: const Color.fromARGB(156, 25, 212, 169),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'ຍອດເງີນຂອງທ່ານ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '12x,xxxx',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.visibility, color: Colors.black54, size: 25),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // รายการตั้งค่า
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF77E5C9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // เปลี่ยนสีพื้นหลังเป็นขาว
                        elevation: 0, // ไม่ต้องการเงา
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {},
                      child: ListTile(
                        dense: true,
                        leading: const Icon(
                          Icons.person, // เพิ่มไอคอน logout
                          color: Colors.black54,
                          size: 20,
                        ),
                        title: const Text(
                          'Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.black54,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF77E5C9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // เปลี่ยนสีพื้นหลังเป็นขาว
                        elevation: 0, // ไม่ต้องการเงา
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        _account.page_add_address();
                      },
                      child: ListTile(
                        dense: true,
                        leading: const Icon(
                          Icons.person, // เพิ่มไอคอน logout
                          color: Colors.black54,
                          size: 20,
                        ),
                        title: const Text(
                          'Address',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.black54,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  const Divider(
                    // เพิ่มเส้นขีดคั่น
                    color: Colors.grey,
                    thickness: 1,
                    height: 32,
                  ),
                  //Logout
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF77E5C9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // เปลี่ยนสีพื้นหลังเป็นขาว
                        elevation: 0, // ไม่ต้องการเงา
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        _loginC.logout(); // เรียกใช้ฟังก์ชัน logout จาก LoginC
                      },
                      child: ListTile(
                        dense: true,
                        leading: const Icon(
                          Icons.logout, // เพิ่มไอคอน logout
                          color: Colors.black54,
                          size: 20,
                        ),
                        title: const Text(
                          'Sign out',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.black54,
                          size: 20,
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
}

// CustomClipper สำหรับตัดขอบด้านล่างแบบโค้งคล้ายคลื่น
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);

    // สร้างเส้นโค้งแบบ bezier เพื่อให้เหมือนในรูป
    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height - 20);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 3 / 4, size.height - 40);
    final secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
