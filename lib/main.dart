import 'package:app_shoe/view/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  configLoading();
  runApp(const MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 5.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.blue
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SHOE Super App',
      debugShowCheckedModeBanner: false,
      home: Splash(),
      // home: ProductPage(),
      builder: EasyLoading.init(),
    );
  }
}

// class ProductPage extends StatefulWidget {
//   @override
//   _ProductPageState createState() => _ProductPageState();
// }

// class _ProductPageState extends State<ProductPage> {
//   List products = [];
//   int page = 1;
//   bool isLoading = false;
//   bool hasMore = true;

//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();

//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent - 200) {
//         fetchProducts();
//       }
//     });
//   }

//   Future<void> fetchProducts() async {
//     if (isLoading || !hasMore) return;

//     setState(() {
//       isLoading = true;
//     });

//     final response = await http.get(
//       Uri.parse("http://100.75.106.34:3000/api/products?page=$page&limit=10"),
//     );

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       final newProducts = jsonData['data'];

//       setState(() {
//         page++;
//         isLoading = false;
//         if (newProducts.length < 10) hasMore = false;
//         products.addAll(newProducts);
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Products")),
//       body: ListView.builder(
//         controller: _scrollController,
//         itemCount: products.length + (hasMore ? 1 : 0),
//         itemBuilder: (context, index) {
//           if (index < products.length) {
//             final product = products[index];
//             return ListTile(
//               title: Text(product['Name']),
//               subtitle: Text("Price: ${product['Price']}"),
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
