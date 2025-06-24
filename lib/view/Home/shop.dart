import 'package:app_shoe/controller/shop_c.dart';
import 'package:app_shoe/controller/favorite_c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_shoe/view/Home/product_details.dart'; // Import ProductDetails page
import 'package:app_shoe/controller/product_details_c.dart'; // Import ProductDetailsC

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final shop_c = Get.put(ShopC());
  final favorite_c = Get.put(FavoriteC());
  final PDC = Get.put(ProductDetailsC());

  Widget _buildCategoryButton(
    String category,
    String label,
    String selectedCategory,
  ) {
    return ElevatedButton(
      onPressed: () {
        shop_c.selectedCategory.value = category;
        shop_c.fetchProducts(category);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            selectedCategory == category ? Colors.blue : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.blue.shade300),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selectedCategory == category ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: Icon(Icons.search, color: Colors.blueGrey[300]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 15.0,
                  ),
                ),
                onChanged: (value) {
                  // Implement search logic here
                  // shop_c.searchProducts(value);
                },
              ),
            ),
            //category buttons
            Container(
              height: 60,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Obx(() {
                    final selected = shop_c.selectedCategory.value;
                    return Row(
                      children: [
                        _buildCategoryButton('', 'ALL', selected),
                        SizedBox(width: 8),
                        _buildCategoryButton('1', 'Nike', selected),
                        SizedBox(width: 8),
                        _buildCategoryButton('2', 'Adidas', selected),
                        SizedBox(width: 8),
                        _buildCategoryButton('3', 'Puma', selected),
                        SizedBox(width: 8),
                        _buildCategoryButton('4', 'New Balance', selected),
                        SizedBox(width: 8),
                        _buildCategoryButton('5', 'Converse', selected),
                      ],
                    );
                  }),
                ),
              ),
            ),
            //products grid
            Expanded(
              child: Obx(() {
                if (shop_c.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.blue,
                        ), // Changed color
                        SizedBox(height: 16),
                        Text(
                          'Loading products...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey[600],
                          ), // Changed color
                        ),
                      ],
                    ),
                  );
                }

                if (shop_c.error.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ), // Keep red for error
                        SizedBox(height: 16),
                        Text(
                          shop_c.error.value,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ), // Keep red for error
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => shop_c.refreshShopData(),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (shop_c.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_basket_outlined,
                          size: 64,
                          color: Colors.blueGrey[300], // Changed color
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blueGrey[600],
                          ), // Changed color
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
                  itemCount: shop_c.items.length,
                  itemBuilder: (context, index) {
                    final item = shop_c.items[index];
                    return GestureDetector(
                      onTap:
                          () => Get.to(
                            () => ProductDetails(product: item),
                          ), // Keep navigation on item tap
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Keep rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(
                                0.2,
                              ), // Adjusted shadow opacity for softness
                              spreadRadius: 2, // Adjusted spread radius
                              blurRadius: 8, // Adjusted blur radius
                              offset: Offset(
                                0,
                                4,
                              ), // Added offset for soft shadow
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
                                              color:
                                                  Colors
                                                      .blueGrey[300], // Changed color
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
                                                    ? Colors
                                                        .red // Keep red for favorite
                                                    : Colors
                                                        .blueGrey[300], // Changed color
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
                                          color:
                                              Colors
                                                  .blueGrey[800], // Changed color
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'ລາຄາ: ${item.price} K',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Colors
                                                  .green, // Keep green for price
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 8, // Adjusted position
                              bottom: 8, // Adjusted position
                              child: ElevatedButton(
                                onPressed: () {
                                  // Show the modal bottom sheet when the button is pressed
                                  PDC.showOptionsModal(item, context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue, // Keep blue
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(
                                    10,
                                  ), // Adjusted padding
                                  elevation:
                                      4, // Added elevation for button shadow
                                ),
                                child: Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Navigate to cart page or show cart modal
      //     // Get.to(() => CartPage()); // Example navigation
      //   },
      //   backgroundColor: Colors.blue,
      //   child: Icon(Icons.shopping_cart, color: Colors.white),
      //   tooltip: 'Cart',
      // ),
    );
  }
}
