import 'package:app_shoe/controller/shop_c.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final shop_c = Get.put(ShopC());
  final List<String> imgList = [
    'images/bg123.png',
    'images/bg123.png',
    'images/bg123.png',
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
                        int index = item.key;
                        return GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('คุณกดที่รูป: $index')),
                            );
                          },
                          child: Image.asset(item.value),
                        );
                      }).toList(),
                ),
              ),
            ),
            SizedBox(height: 16),
            //card type
            Container(),
          ],
        ),
      ),
    );
  }
}
