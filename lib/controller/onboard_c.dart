import 'package:app_shoe/view/Login/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardC extends GetxController {
  final List<Map<String, dynamic>> onboardData = [
    {
      'image': 'images/ob1.png',
      'title': 'ເບິ່ງສິນຄ້າແບບ 360 ອົງສາ',
      'description':
          'ທ່ານສາມາດເບິ່ງສິນຄ້າຈາກທຸກມຸມມອງ ທີ່ແທ້ຈິງແລະສະດວກ',
    },
    {
      'image': 'images/ob2.png',
      'title': 'ເຊື່ອມຕໍ່ກັບເພື່ອນແລະຄອບຄົວ',
      'description': 'ເຊື່ອມຕໍ່ກັບເພື່ອນແລະຄອບຄົວໄດ້ຢ່າງງ່າຍດາຍ',
    },
    {
      'image': 'images/ob3.png',
      'title': 'ເລີ່ມຕົ້ນດຽວນີ້',
      'description': 'ເຂົ້າຮ່ວມກັບພວກເຮົາແລະສຳຫຼວດໂລກແຫ່ງຄວາມເປັນໄປໄດ້',
    },
  ];
  final PageController pageonbord = PageController();
  final currentboard = 0.obs;
  void onPageChanged(int index) {
    currentboard.value = index;
  }

  void onNextPage() {
    if (currentboard.value < onboardData.length - 1) {
      pageonbord.nextPage(
        duration: Duration(milliseconds: 300), // ລະຍະເວລາເປລີ່ຍນໜ້າ
        curve: Curves.fastOutSlowIn, // ລັກສະນະການເຄື່ອນໄຫວ
      );
    } else {
      Get.to(Welcome());
    }
  }
}
