import 'package:app_shoe/controller/shop_c.dart';
import 'package:app_shoe/controller/favorite_c.dart';
import 'package:app_shoe/controller/search_c.dart';
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
  final search_c = Get.put(SearchC());

  // Add a ScrollController
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Add a listener to the scroll controller
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // Dispose the scroll controller
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Scroll listener to detect when the user reaches the end of the list
  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User has scrolled to the end, load more products
      shop_c.loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar with Price Filter
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search input
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'ค้นหาสินค้า เช่น Nike, Adidas, ເກີບແຟຊັ່ນ...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.blueGrey[300],
                      ),
                      suffixIcon: Obx(
                        () =>
                            search_c.isSearchActive.value
                                ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.blueGrey[300],
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    search_c.clearSearch();
                                  },
                                )
                                : SizedBox.shrink(),
                      ),
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
                      // Real-time search เมื่อพิมพ์ครบ 2 ตัวอักษร
                      if (value.length >= 2) {
                        search_c.searchProducts(value);
                      } else if (value.isEmpty) {
                        search_c.clearSearch();
                      }
                    },
                    onSubmitted: (value) {
                      // ค้นหาเมื่อกด Enter
                      if (value.trim().isNotEmpty) {
                        search_c.searchProducts(value);
                      }
                    },
                  ),
                ],
              ),
            ),
            // Filter and Sorting Row
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  // Product Type and Brand Row
                  Row(
                    children: [
                      // Product Type Dropdown
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ประเภท:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey[700],
                              ),
                            ),
                            SizedBox(height: 4),
                            Obx(
                              () => Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: DropdownButton<String>(
                                  value:
                                      search_c.selectedProductType.value.isEmpty
                                          ? null
                                          : search_c.selectedProductType.value,
                                  hint: Text(
                                    'เลือกประเภท',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey[600],
                                    size: 18,
                                  ),
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: '',
                                      child: Text(
                                        'ทั้งหมด',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    ...search_c.productTypes.map((productType) {
                                      return DropdownMenuItem<String>(
                                        value:
                                            productType.productTypeId
                                                .toString(),
                                        child: Text(
                                          productType.productTypeName,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  onChanged: (String? newValue) {
                                    search_c.applyProductTypeFilter(
                                      newValue ?? '',
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      // Brand Dropdown
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'แบรนด์:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey[700],
                              ),
                            ),
                            SizedBox(height: 4),
                            Obx(
                              () => Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: DropdownButton<String>(
                                  value:
                                      search_c.selectedBrand.value.isEmpty
                                          ? null
                                          : search_c.selectedBrand.value,
                                  hint: Text(
                                    'เลือกแบรนด์',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey[600],
                                    size: 18,
                                  ),
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: '',
                                      child: Text(
                                        'ทั้งหมด',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    ...search_c.brands.map((brand) {
                                      return DropdownMenuItem<String>(
                                        value: brand.brandName,
                                        child: Text(
                                          brand.brandName,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                  onChanged: (String? newValue) {
                                    search_c.applyBrandFilter(newValue ?? '');
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Sorting Row with Action Buttons
                  Row(
                    children: [
                      Icon(Icons.sort, color: Colors.blueGrey[600], size: 20),
                      SizedBox(width: 8),
                      Text(
                        'เรียงตาม:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[700],
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButton<String>(
                              value:
                                  search_c.isSearchActive.value
                                      ? search_c.sortOrder.value.isEmpty
                                          ? ''
                                          : search_c.sortOrder.value
                                      : shop_c.sortOrder.value.isEmpty
                                      ? ''
                                      : shop_c.sortOrder.value,
                              hint: Text('เลือกการเรียงลำดับ'),
                              isExpanded: true,
                              underline: SizedBox(),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey[600],
                              ),
                              items:
                                  shop_c.sortOptions.map((option) {
                                    return DropdownMenuItem<String>(
                                      value: option['value'],
                                      child: Text(
                                        option['label']!,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (String? newValue) {
                                if (search_c.isSearchActive.value) {
                                  // Apply sorting to search results
                                  search_c.sortByPrice(newValue ?? '');
                                } else {
                                  // Apply sorting to shop products
                                  shop_c.sortByPrice(newValue ?? '');
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // Action Buttons ด้านหลัง dropdown เรียงตาม
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Refresh Filter Data Button
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade400,
                                  Colors.blue.shade600,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () async {
                                  await search_c.refreshFilterData();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.refresh_rounded,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'รีเฟรช',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          // Clear Filter Button
                          Obx(
                            () => AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child:
                                  (search_c.isSearchActive.value ||
                                          search_c.hasAnyFilter)
                                      ? Container(
                                        key: ValueKey('clear_button'),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.orange.shade400,
                                              Colors.red.shade500,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.orange.withOpacity(
                                                0.3,
                                              ),
                                              spreadRadius: 1,
                                              blurRadius: 6,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                            onTap: () {
                                              _searchController.clear();
                                              search_c.clearAllFilters();
                                              // Also reset shop sorting if not in search mode
                                              if (!search_c
                                                  .isSearchActive
                                                  .value) {
                                                shop_c.sortOrder.value = '';
                                                shop_c.refreshShopData();
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 8,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.clear_all_rounded,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    'ล้าง',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      : SizedBox.shrink(key: ValueKey('empty')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //products grid
            Expanded(
              child: Obx(() {
                // แสดงผลการค้นหาถ้ากำลังค้นหา
                if (search_c.isSearchActive.value) {
                  if (search_c.isLoading.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.blue),
                          SizedBox(height: 16),
                          Text(
                            'กำลังค้นหา "${search_c.searchQuery.value}"...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (search_c.error.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.orange,
                          ),
                          SizedBox(height: 16),
                          Text(
                            search_c.error.value,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.orange,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => search_c.refreshSearch(),
                            child: Text('ลองค้นหาอีกครั้ง'),
                          ),
                        ],
                      ),
                    );
                  }

                  // แสดงผลการค้นหา
                  if (search_c.searchResults.isEmpty) {
                    // ไม่พบผลการค้นหา
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'ไม่พบสินค้าที่ค้นหา',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '"${search_c.searchQuery.value}"',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'ลองค้นหาด้วยคำอื่น เช่น Nike, Adidas หรือชื่อสินค้า',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // แสดงจำนวนผลการค้นหา
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade600,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'พบสินค้า ${search_c.searchResults.length} รายการสำหรับ "${search_c.searchQuery.value}"',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _buildProductGrid(
                          search_c.searchResults,
                          isSearchResults: true,
                        ),
                      ),
                    ],
                  );
                }

                // แสดงสินค้าปกติเมื่อไม่ได้ค้นหา
                if (shop_c.isLoading.value && shop_c.items.isEmpty) {
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

                if (shop_c.items.isEmpty && !shop_c.isLoading.value) {
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

                return _buildProductGrid(shop_c.items);
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

  // Method สำหรับสร้าง Product Grid
  Widget _buildProductGrid(
    List<dynamic> items, {
    bool isSearchResults = false,
  }) {
    return GridView.builder(
      controller: isSearchResults ? null : _scrollController,
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
      itemCount:
          items.length +
          (!isSearchResults && shop_c.hasMore.value
              ? 1
              : 0), // Add loading indicator only for regular products
      itemBuilder: (context, index) {
        if (!isSearchResults && index == items.length) {
          // Show loading indicator at the end of the list (only for regular products)
          return Center(child: CircularProgressIndicator(color: Colors.blue));
        }
        final item = items[index];
        return GestureDetector(
          onTap: () => Get.to(() => ProductDetails(product: item)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 4),
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
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.blueGrey[300],
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
                                        : Colors.blueGrey[300],
                              ),
                              onPressed: () => favorite_c.toggleFavorite(item),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name ?? 'Unnamed Product',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width > 380
                                      ? 16
                                      : 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800],
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
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: ElevatedButton(
                    onPressed: () {
                      PDC.showOptionsModal(item, context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10),
                      elevation: 4,
                    ),
                    child: Icon(Icons.add_shopping_cart, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
