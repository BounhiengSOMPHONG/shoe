import 'package:app_shoe/controller/shop_c.dart';
import 'package:app_shoe/view/Home/shop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:url_launcher/url_launcher.dart'; // ไม่ได้ใช้แล้ว

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class Page extends StatelessWidget {
  const Page({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Page 1')), body: Shop());
  }
}

class _HomeState extends State<Home> {
  final shop_c = Get.put(ShopC());
  // เปลี่ยนประเภทของ List และค่าใน Map
  final List<Map<String, dynamic>> imgList = [
    {'image': 'images/bg123.png', 'page': () => const Page()},
    {'image': 'images/bg123.png', 'page': () => const Page()},
    {'image': 'images/bg123.png', 'page': () => const Page()},
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                color: Colors.red,
                height: size.height * 0.3,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: size.height * 0.3,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 1.0,
                  ),
                  items:
                      imgList.asMap().entries.map((item) {
                        // int index = item.key; // ไม่ได้ใช้ index ในตัวอย่างนี้แล้ว
                        String imageUrl = item.value['image'] as String;
                        Widget Function()? pageBuilder =
                            item.value['page'] as Widget Function()?;

                        return GestureDetector(
                          onTap: () {
                            // ใช้ Get.to() เพื่อไปยังหน้าที่กำหนด
                            if (pageBuilder != null)
                              Get.to(() => pageBuilder());
                          },
                          child: Image.asset(imageUrl),
                        );
                      }).toList(),
                ),
              ),
            ),
            SizedBox(height: 16),
            //card type
            Container(
              child: Column(
                children: [
                  Row(children: [Text("Hots")]),
                  SizedBox(height: 8),
                  SingleChildScrollView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
