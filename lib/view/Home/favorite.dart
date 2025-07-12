import 'package:app_shoe/controller/shop_c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/favorite_c.dart';
import '../../controller/product_details_c.dart';
import '../../model/product_m.dart';
import 'product_details.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ລາຍການທີ່ມັກ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(
                          () => Text(
                            '${favorite_c.favoriteItems.length} ລາຍການ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Refresh Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () => favorite_c.fetchFavorites(),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => favorite_c.fetchFavorites(),
                color: Colors.pink.shade400,
                child: Obx(() {
                  if (favorite_c.isLoading.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pink.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.pink.shade400,
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'ກຳລັງໂຫຼດລາຍການທີ່ມັກ...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
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
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.error_outline,
                              size: 50,
                              color: Colors.red.shade400,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            favorite_c.error.value,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => favorite_c.fetchFavorites(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('ລອງໃໝ່'),
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
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.favorite_border,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'ຍັງບໍ່ມີລາຍການທີ່ມັກ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ເລີ່ມຊອບຫາສິນຄ້າທີ່ທ່ານມັກແລ້ວກົດໃສ່ໃຈ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 0.65,
                          ),
                      itemCount: favorite_c.favoriteItems.length,
                      itemBuilder: (context, index) {
                        final item = favorite_c.favoriteItems[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to product details
                            Get.to(() => ProductDetails(product: item));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Image
                                Stack(
                                  children: [
                                    Container(
                                      height: 140,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        color: Colors.grey.shade50,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        child: Image.network(
                                          item.image ?? '',
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              color: Colors.grey.shade100,
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                                color: Colors.grey.shade400,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    // Favorite Button
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            favorite_c.isFavorite(item.id)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                favorite_c.isFavorite(item.id)
                                                    ? Colors.red.shade400
                                                    : Colors.grey.shade400,
                                            size: 20,
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

                                // Product Info
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name ?? 'ສິນຄ້າບໍ່ມີຊື່',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        if (item.brand != null) ...[
                                          Text(
                                            item.brand!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                        ],
                                        const Spacer(),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.attach_money,
                                              size: 16,
                                              color: Colors.green.shade600,
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${item.price?.toStringAsFixed(0) ?? '0'} K',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.green.shade600,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            // แสดงจำนวนสินค้าคงเหลือ
                                            if (item.Stock != null &&
                                                item.Stock!.isNotEmpty) ...[
                                              const SizedBox(width: 4),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 1,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: _getStockColor(
                                                    item.Stock!,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: _getStockBorderColor(
                                                      item.Stock!,
                                                    ),
                                                    width: 0.5,
                                                  ),
                                                ),
                                                child: Text(
                                                  '${_getTotalStock(item.Stock!)}',
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color: _getStockTextColor(
                                                      item.Stock!,
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for stock display
  int _getTotalStock(List<StockItem> stockItems) {
    return stockItems.fold(0, (sum, stock) => sum + (stock.Quantity ?? 0));
  }

  Color _getStockColor(List<StockItem> stockItems) {
    int totalStock = _getTotalStock(stockItems);
    if (totalStock == 0) {
      return Colors.red.shade100;
    } else if (totalStock <= 5) {
      return Colors.orange.shade100;
    } else {
      return Colors.green.shade100;
    }
  }

  Color _getStockBorderColor(List<StockItem> stockItems) {
    int totalStock = _getTotalStock(stockItems);
    if (totalStock == 0) {
      return Colors.red.shade300;
    } else if (totalStock <= 5) {
      return Colors.orange.shade300;
    } else {
      return Colors.green.shade300;
    }
  }

  Color _getStockTextColor(List<StockItem> stockItems) {
    int totalStock = _getTotalStock(stockItems);
    if (totalStock == 0) {
      return Colors.red.shade700;
    } else if (totalStock <= 5) {
      return Colors.orange.shade700;
    } else {
      return Colors.green.shade700;
    }
  }
}
