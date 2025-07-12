import 'package:app_shoe/controller/home_c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_shoe/model/product_m.dart';
import 'product_details.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final homeC = Get.put(HomeC());
    return _HomeView();
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final homeC = Get.find<HomeC>();
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Obx(
        () =>
            homeC.isLoading.value
                ? _buildLoadingView()
                : homeC.error.value.isNotEmpty
                ? _buildErrorView(homeC)
                : _buildHomeContent(homeC, size),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Container(
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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
            ),
            SizedBox(height: 16),
            Text(
              'ກຳລັງໂຫລດ...',
              style: TextStyle(color: Colors.blue.shade600, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(HomeC homeC) {
    return Container(
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
            Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
            SizedBox(height: 16),
            Text(
              homeC.error.value,
              style: TextStyle(color: Colors.red.shade400, fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: homeC.fetchHomeProducts,
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
    );
  }

  Widget _buildHomeContent(HomeC homeC, Size size) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[50]!, Colors.white],
        ),
      ),
      child: FadeTransition(
        opacity: homeC.fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Modern Carousel Section
              Container(
                height: size.height * 0.25,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: size.height * 0.25,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      autoPlayInterval: Duration(seconds: 4),
                    ),
                    items:
                        homeC.imgList.asMap().entries.map((item) {
                          String imageUrl = item.value['image'] as String;
                          Widget Function()? pageBuilder =
                              item.value['page'] as Widget Function()?;
                          return GestureDetector(
                            onTap: () {
                              if (pageBuilder != null)
                                Get.to(() => pageBuilder());
                            },
                            child: Container(
                              width: double.infinity,
                              // decoration: BoxDecoration(
                              //   gradient: LinearGradient(
                              //     begin: Alignment.topLeft,
                              //     end: Alignment.bottomRight,
                              //     colors: [Colors.blue[50]!, Colors.blue[100]!],
                              //   ),
                              // ),
                              child: Image.asset(
                                imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.blue[100]!,
                                          Colors.blue[200]!,
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.local_offer,
                                            color: Colors.blue[600],
                                            size: 48,
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            'ໂປຣໂມຊັນພິເສດ',
                                            style: TextStyle(
                                              color: Colors.blue[700],
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'ສິນຄ້າຄຸນນະພາບສູງ',
                                            style: TextStyle(
                                              color: Colors.blue[600],
                                              fontSize: 14,
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

              // Popular Products Section
              _buildSectionHeader('🔥 ສິນຄ້າແນະນຳ', Icons.star),
              SizedBox(height: 12),
              _buildProductList(homeC.popularProducts, homeC),
              SizedBox(height: 32),

              // Latest Products Section
              _buildSectionHeader('🆕 ສິນຄ້າມາໃໝ່', Icons.new_releases),
              SizedBox(height: 12),
              _buildProductList(homeC.latestProducts, homeC),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernProductCard(PItem product, HomeC homeC) {
    // ตรวจสอบจำนวนสินค้าคงเหลือ
    int totalStock = homeC.getProductTotalStock(product);
    bool hasStockData = homeC.hasProductStockData(product);
    bool isOutOfStock = homeC.isProductOutOfStock(product);

    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Get.to(() => ProductDetails(product: product));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: AspectRatio(
                  aspectRatio: 1.1,
                  child: Stack(
                    children: [
                      // Product Image
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.grey[50]!, Colors.white],
                          ),
                        ),
                        child:
                            product.image != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                  child: Image.network(
                                    product.image!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.grey[100]!,
                                              Colors.grey[50]!,
                                            ],
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey[400],
                                                size: 32,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'ບໍ່ມີຮູບ',
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                                : Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.grey[100]!,
                                        Colors.grey[50]!,
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          color: Colors.grey[400],
                                          size: 32,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'ບໍ່ມີຮູບ',
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                      ),

                      // Out of Stock Badge
                      if (isOutOfStock)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[600],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'ໝົດ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      // Stock Indicator
                      if (hasStockData && !isOutOfStock)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  totalStock <= 5
                                      ? Colors.orange[100]
                                      : Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    totalStock <= 5
                                        ? Colors.orange[300]!
                                        : Colors.green[300]!,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${totalStock}',
                              style: TextStyle(
                                fontSize: 10,
                                color:
                                    totalStock <= 5
                                        ? Colors.orange[700]
                                        : Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Product Info Section
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product.name ?? 'ສິນຄ້າບໍ່ມີຊື່',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),

                      // Price
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 16,
                            color: Colors.green[600],
                          ),
                          Text(
                            '${product.price?.toStringAsFixed(0) ?? '-'} K',
                            style: TextStyle(
                              color: Colors.green[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(RxList<PItem> products, HomeC homeC) {
    return Container(
      height: 280,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, idx) {
          return _buildModernProductCard(products[idx], homeC);
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[100]!, Colors.blue[200]!],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.blue[700], size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'ສິນຄ້າຄຸນນະພາບສູງ ລາຄາຍຸ່ນຍ້າຍ',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
