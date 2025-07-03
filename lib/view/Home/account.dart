import 'package:app_shoe/controller/account/account_c.dart';
import 'package:app_shoe/controller/login_c.dart';
import 'package:app_shoe/view/Home/orders.dart';
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
                  child: Container(
                    height: 350,
                    color: Colors.white,
                  ), // Changed color
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ), // Added horizontal padding
                  child: Column(
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
                            'images/LOGO.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30), // Reduced space
                      // รูปโปรไฟล์
                      Container(
                        width: 120, // Slightly larger
                        height: 120, // Slightly larger
                        decoration: BoxDecoration(
                          color: Colors.white, // Use white background
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ), // White border
                          boxShadow: [
                            // Add a subtle shadow
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person, // Keep person icon for now
                          size: 70, // Larger icon
                          color: Colors.teal, // Use a teal color
                        ),
                      ),
                      const SizedBox(height: 20), // Reduced space
                      const Text(
                        'NAME', // Placeholder name
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22, // Slightly larger font
                          color: Colors.white, // White text for contrast
                        ),
                      ),
                      const Text(
                        'NAME@gmail.com', // Placeholder email
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ), // Slightly smaller and lighter white
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25), // Adjusted space
            // กล่องแสดงยอดเงิน
            // Container(
            //   margin: const EdgeInsets.symmetric(
            //     horizontal: 16,
            //   ), // Adjusted margin to match padding
            //   padding: const EdgeInsets.symmetric(
            //     vertical: 25,
            //     horizontal: 25,
            //   ), // Adjusted padding
            //   decoration: BoxDecoration(
            //     color: Colors.white, // White background
            //     borderRadius: BorderRadius.circular(12), // More rounded corners
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.1),
            //         spreadRadius: 2,
            //         blurRadius: 8,
            //         offset: Offset(0, 4),
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Center(
            //         child: Text(
            //           'ຍອດເງີນຂອງທ່ານ', // Money title
            //           style: TextStyle(
            //             fontWeight: FontWeight.w600, // Slightly bolder
            //             fontSize: 18, // Slightly larger
            //             color: Colors.black87, // Darker text
            //           ),
            //         ),
            //       ),
            //       const SizedBox(height: 12), // Increased space
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: const [
            //           Text(
            //             '12x,xxxx', // Placeholder amount
            //             style: TextStyle(
            //               fontSize: 20, // Larger font
            //               fontWeight: FontWeight.bold,
            //               color: Colors.teal, // Teal color for amount
            //             ),
            //           ),
            //           Icon(
            //             Icons.visibility,
            //             color: Colors.teal,
            //             size: 28,
            //           ), // Teal icon, slightly larger
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 35), // Keep space
            // รายการตั้งค่า
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ), // Adjusted padding
              child: Column(
                children: [
                  // Profile
                  Card(
                    // Using Card for better visual separation
                    elevation: 2, // Add a subtle shadow
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.account_circle_outlined, // More appropriate icon
                        color: Colors.black54,
                        size: 24, // Slightly larger icon
                      ),
                      title: const Text(
                        'Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16, // Slightly larger font
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.black54,
                        size: 24, // Slightly larger icon
                      ),
                      onTap: () {
                        // TODO: Implement navigation to Profile page
                      },
                    ),
                  ),
                  // Address
                  Card(
                    // Using Card for better visual separation
                    elevation: 2, // Add a subtle shadow
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.location_on_outlined, // More appropriate icon
                        color: Colors.black54,
                        size: 24, // Slightly larger icon
                      ),
                      title: const Text(
                        'Address',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16, // Slightly larger font
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.black54,
                        size: 24, // Slightly larger icon
                      ),
                      onTap: () {
                        _account.page_add_address();
                      },
                    ),
                  ),
                  // Orders
                  Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.black54,
                        size: 24,
                      ),
                      title: const Text(
                        'ການສັ່ງຊື້ຂອງຂ້ອຍ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.black54,
                        size: 24,
                      ),
                      onTap: () {
                        Get.to(() => OrdersPage());
                      },
                    ),
                  ),

                  const Divider(
                    // Keep divider for separation
                    color: Colors.grey,
                    thickness: 0.5, // Slightly thinner divider
                    height: 32,
                  ),
                  //Logout
                  Card(
                    // Using Card for better visual separation
                    color: Colors.red,
                    elevation: 2, // Add a subtle shadow
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.logout, // Logout icon is fine
                        color: Colors.black54,
                        size: 24, // Slightly larger icon
                      ),
                      title: const Text(
                        'Sign out',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16, // Slightly larger font
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.black54,
                        size: 24, // Slightly larger icon
                      ),
                      onTap: () {
                        _loginC.logout(); // Calling logout function
                      },
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
