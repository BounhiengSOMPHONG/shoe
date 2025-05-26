import 'package:app_shoe/controller/shop_c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/favorite_c.dart';
import '../../controller/product_details_c.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final favorite_c = Get.put(FavoriteC());
  final shop_c = Get.put(ShopC());
  final PDC = Get.put(ProductDetailsC());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              'Favorite Items',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => favorite_c.fetchFavorites(),
              child: Obx(() {
                if (favorite_c.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.green),
                        SizedBox(height: 16),
                        Text(
                          'Loading favorites...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (favorite_c.error.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          favorite_c.error.value,
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ],
                    ),
                  );
                }

                if (favorite_c.favoriteItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No favorite items yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.all(16),
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio:
                        MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.6),
                  ),
                  itemCount: favorite_c.favoriteItems.length,
                  itemBuilder: (context, index) {
                    final item = favorite_c.favoriteItems[index];
                    return GestureDetector(
                      onTap: () => shop_c.openProductDetails(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 120,
                                      width: double.infinity,
                                      child: Center(
                                        child: Image.network(
                                          item.image ?? '',
                                          fit: BoxFit.contain,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                              color: Colors.grey,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 8,
                                      child: Obx(
                                        () => IconButton(
                                          icon: Icon(
                                            favorite_c.isFavorite(item.id)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                favorite_c.isFavorite(item.id)
                                                    ? Colors.red
                                                    : Colors.grey,
                                          ),
                                          onPressed:
                                              () => favorite_c.toggleFavorite(
                                                item,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name ?? 'Unnamed Product',
                                        style: TextStyle(
                                          fontSize:
                                              MediaQuery.of(
                                                        context,
                                                      ).size.width >
                                                      380
                                                  ? 16
                                                  : 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'ລາຄາ: ${item.price} K',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Positioned(
                            //   right: 0,
                            //   bottom: 0,
                            //   child: ElevatedButton(
                            //     onPressed: () {
                            //       List<String> sizes = (item.size ?? "null")
                            //           .split(',');
                            //       List<String> colors = (item.color ?? "null")
                            //           .split(',');
                            //       PDC.showOptionsModal(
                            //         item,
                            //         sizes,
                            //         colors,
                            //         context,
                            //       );
                            //     },
                            //     style: ElevatedButton.styleFrom(
                            //       backgroundColor: Colors.blue,
                            //       shape: CircleBorder(),
                            //       padding: EdgeInsets.all(8),
                            //     ),
                            //     child: Icon(
                            //       Icons.add_shopping_cart,
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
