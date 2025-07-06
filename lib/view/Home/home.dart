import 'package:app_shoe/controller/shop_c.dart';
import 'package:app_shoe/view/Home/shop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_shoe/services/apiservice.dart';
import 'package:app_shoe/model/product_m.dart';
import 'package:app_shoe/services/apiconstants.dart';
import 'product_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class Page extends StatelessWidget {
  const Page({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page 1'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Shop(),
    );
  }
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final shop_c = Get.put(ShopC());
  final ApiService _apiService = ApiService();
  List<PItem> popularProducts = [];
  List<PItem> latestProducts = [];
  bool isLoading = true;
  String? error;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> imgList = [
    {'image': 'images/bg123.png', 'page': () => const Page()},
    {'image': 'images/bg123.png', 'page': () => const Page()},
    {'image': 'images/bg123.png', 'page': () => const Page()},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    fetchHomeProducts();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchHomeProducts() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final popRes = await _apiService.get(
        ApiConstants.popularProductsEndpoint,
      );
      final latestRes = await _apiService.get(
        ApiConstants.latestProductsEndpoint,
      );
      if (popRes.success && latestRes.success) {
        popularProducts =
            (popRes.data['data'] as List)
                .map((e) => PItem.fromJson(e))
                .toList();
        latestProducts =
            (latestRes.data['data'] as List)
                .map((e) => PItem.fromJson(e))
                .toList();
        _animationController.forward();
      } else {
        error = popRes.message ?? latestRes.message;
      }
    } catch (e) {
      error = e.toString();
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget buildModernProductCard(PItem product) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Get.to(() => ProductDetails(product: product));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 1.2,
                child:
                    product.image != null
                        ? Image.network(
                          product.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.blue.shade50,
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.blue.shade300,
                              ),
                            );
                          },
                        )
                        : Container(
                          color: Colors.blue.shade50,
                          child: Icon(Icons.image, color: Colors.blue.shade300),
                        ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 16,
                        color: Colors.blue.shade600,
                      ),
                      Text(
                        '${product.price?.toStringAsFixed(0) ?? '-'} ฿',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductList(List<PItem> products) {
    return Container(
      height: 240,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, idx) {
          return buildModernProductCard(products[idx]);
        },
      ),
    );
  }

  Widget buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue.shade600, size: 20),
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child:
          isLoading
              ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue.shade50, Colors.white],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue.shade600,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'ກຳລັງໂຫລດ...',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : error != null
              ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue.shade50, Colors.white],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red.shade400,
                        size: 48,
                      ),
                      SizedBox(height: 16),
                      Text(
                        error!,
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchHomeProducts,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('ລອງອີກຄັ້ງ'),
                      ),
                    ],
                  ),
                ),
              )
              : Container(
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     begin: Alignment.topCenter,
                //     end: Alignment.bottomCenter,
                //     colors: [Colors.blue.shade50, Colors.white],
                //   ),
                // ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Modern Carousel Section
                        Container(
                          height: size.height * 0.3,
                          margin: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.blue.shade200.withOpacity(0.3),
                            //     blurRadius: 12,
                            //     offset: Offset(0, 4),
                            //   ),
                            // ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: size.height * 0.3,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 1.0,
                                autoPlayInterval: Duration(seconds: 4),
                              ),
                              items:
                                  imgList.asMap().entries.map((item) {
                                    String imageUrl =
                                        item.value['image'] as String;
                                    Widget Function()? pageBuilder =
                                        item.value['page']
                                            as Widget Function()?;
                                    return GestureDetector(
                                      onTap: () {
                                        if (pageBuilder != null)
                                          Get.to(() => pageBuilder());
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        child: Image.asset(
                                          imageUrl,
                                          fit: BoxFit.contain,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.image,
                                                      color: Colors.white,
                                                      size: 48,
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      'ໂປຣໂມຊັນພິເສດ',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Popular Products Section
                        buildSectionHeader('ສິນຄ້າແນະນຳ', Icons.star),
                        SizedBox(height: 8),
                        buildProductList(popularProducts),
                        SizedBox(height: 32),

                        // Latest Products Section
                        buildSectionHeader('ສິນຄ້າມາໃໝ່', Icons.new_releases),
                        SizedBox(height: 8),
                        buildProductList(latestProducts),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
