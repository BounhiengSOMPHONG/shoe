import 'package:app_shoe/controller/shop_c.dart';
import 'package:app_shoe/controller/favorite_c.dart';
import 'package:app_shoe/controller/search_c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_shoe/view/Home/product_details.dart';
import 'package:app_shoe/controller/product_details_c.dart';

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

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      shop_c.loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header Section with Search
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'ຄົ້ນຫາສິນຄ້າ...',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.blue[600],
                          size: 22,
                        ),
                        suffixIcon: Obx(
                          () =>
                              search_c.isSearchActive.value
                                  ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.grey[600],
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      search_c.clearSearch();
                                    },
                                  )
                                  : SizedBox.shrink(),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length >= 2) {
                          search_c.searchProducts(value);
                        } else if (value.isEmpty) {
                          search_c.clearSearch();
                        }
                      },
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          search_c.searchProducts(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Filter Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              child: Column(
                children: [
                  // Filter Row 1: Product Type and Brand
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterDropdown(
                          label: 'ປະເພດ',
                          hint: 'ເລືອກປະເພດ',
                          value:
                              search_c.selectedProductType.value.isEmpty
                                  ? null
                                  : search_c.selectedProductType.value,
                          items: [
                            DropdownMenuItem<String>(
                              value: '',
                              child: Text(
                                'ທັງໝົດ',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            ...search_c.productTypes.map((productType) {
                              return DropdownMenuItem<String>(
                                value: productType.productTypeId.toString(),
                                child: Text(
                                  productType.productTypeName,
                                  style: TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                          ],
                          onChanged: (String? newValue) {
                            search_c.applyProductTypeFilter(newValue ?? '');
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildFilterDropdown(
                          label: 'ແບຣນ',
                          hint: 'ເລືອກແບຣນ',
                          value:
                              search_c.selectedBrand.value.isEmpty
                                  ? null
                                  : search_c.selectedBrand.value,
                          items: [
                            DropdownMenuItem<String>(
                              value: '',
                              child: Text(
                                'ທັງໝົດ',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            ...search_c.brands.map((brand) {
                              return DropdownMenuItem<String>(
                                value: brand.brandName,
                                child: Text(
                                  brand.brandName,
                                  style: TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                          ],
                          onChanged: (String? newValue) {
                            search_c.applyBrandFilter(newValue ?? '');
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Filter Row 2: Sort and Actions
                  Row(
                    children: [
                      Icon(Icons.sort, color: Colors.blue[600], size: 18),
                      SizedBox(width: 6),
                      Text(
                        'ຈັດຮຽງ:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
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
                              hint: Text(
                                'ເລືອກການຈັດຮຽງ',
                                style: TextStyle(fontSize: 13),
                              ),
                              isExpanded: true,
                              underline: SizedBox(),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              items:
                                  shop_c.sortOptions.map((option) {
                                    return DropdownMenuItem<String>(
                                      value: option['value'],
                                      child: Text(
                                        option['label']!,
                                        style: TextStyle(fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (String? newValue) {
                                if (search_c.isSearchActive.value) {
                                  search_c.sortByPrice(newValue ?? '');
                                } else {
                                  shop_c.sortByPrice(newValue ?? '');
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),

                      // Action Buttons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildActionButton(
                            icon: Icons.refresh_rounded,
                            label: 'ໂຫຼດ',
                            gradient: [Colors.blue[400]!, Colors.blue[600]!],
                            onTap: () async {
                              await search_c.refreshFilterData();
                            },
                          ),
                          SizedBox(width: 6),
                          Obx(
                            () => AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child:
                                  (search_c.isSearchActive.value ||
                                          search_c.hasAnyFilter)
                                      ? _buildActionButton(
                                        key: ValueKey('clear_button'),
                                        icon: Icons.clear_all_rounded,
                                        label: 'ລ້າງ',
                                        gradient: [
                                          Colors.orange[400]!,
                                          Colors.red[500]!,
                                        ],
                                        onTap: () {
                                          _searchController.clear();
                                          search_c.clearAllFilters();
                                          if (!search_c.isSearchActive.value) {
                                            shop_c.sortOrder.value = '';
                                            shop_c.refreshShopData();
                                          }
                                        },
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

            // Products Grid
            Expanded(
              child: Obx(() {
                if (search_c.isSearchActive.value) {
                  return _buildSearchResults();
                }
                return _buildShopProducts();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<String>(
            value: value,
            hint: Text(hint, style: TextStyle(fontSize: 13)),
            isExpanded: true,
            underline: SizedBox(),
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey[600],
              size: 18,
            ),
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    Key? key,
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text(
                  label,
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
    );
  }

  Widget _buildSearchResults() {
    if (search_c.isLoading.value) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.blue[600]),
            SizedBox(height: 16),
            Text(
              'ກຳລັງຄົ້ນຫາ "${search_c.searchQuery.value}"...',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
            Icon(Icons.search_off, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              search_c.error.value,
              style: TextStyle(fontSize: 16, color: Colors.orange),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => search_c.refreshSearch(),
              child: Text('ລອງຄົ້ນຫາອີກຄັ້ງ'),
            ),
          ],
        ),
      );
    }

    if (search_c.searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'ບໍ່ພົບສິນຄ້າທີ່ຄົ້ນຫາ',
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
                'ລອງຄົ້ນຫາດ້ວຍຄຳອື່ນ',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[600], size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'ພົບສິນຄ້າ ${search_c.searchResults.length} ລາຍການ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
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

  Widget _buildShopProducts() {
    if (shop_c.isLoading.value && shop_c.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.blue[600]),
            SizedBox(height: 16),
            Text(
              'ກຳລັງໂຫຼດສິນຄ້າ...',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              shop_c.error.value,
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => shop_c.refreshShopData(),
              child: Text('ລອງໃໝ່'),
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
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'ບໍ່ພົບສິນຄ້າ',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return _buildProductGrid(shop_c.items);
  }

  Widget _buildProductGrid(
    List<dynamic> items, {
    bool isSearchResults = false,
  }) {
    return GridView.builder(
      controller: isSearchResults ? null : _scrollController,
      padding: EdgeInsets.all(12),
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        // childAspectRatio: 0.75,
        childAspectRatio:
            MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.3),
      ),
      itemCount:
          items.length + (!isSearchResults && shop_c.hasMore.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (!isSearchResults && index == items.length) {
          return Center(
            child: CircularProgressIndicator(color: Colors.blue[600]),
          );
        }

        final item = items[index];
        int totalStock = 0;
        bool hasStockData = false;

        if (item.Stock != null && item.Stock!.isNotEmpty) {
          totalStock = item.Stock!.fold(
            0,
            (sum, stock) => sum + (stock.Quantity ?? 0),
          );
          hasStockData = true;
        }

        bool isOutOfStock = hasStockData && totalStock == 0;

        return GestureDetector(
          onTap: () => Get.to(() => ProductDetails(product: item)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Section
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          color: Colors.grey[100],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Hero(
                            tag: 'product_${item.id}',
                            child: Image.network(
                              item.image ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // Out of Stock Badge
                      if (isOutOfStock)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[600],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'ສິນຄ້າໝົດ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      // Favorite Button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                favorite_c.isFavorite(item.id)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    favorite_c.isFavorite(item.id)
                                        ? Colors.red
                                        : Colors.grey[600],
                                size: 20,
                              ),
                              onPressed: () => favorite_c.toggleFavorite(item),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Product Info Section
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          item.name ?? 'ສິນຄ້າບໍ່ມີຊື່',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),

                        // Price and Stock Row
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${item.price} K',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (hasStockData)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isOutOfStock
                                          ? Colors.red[100]
                                          : (totalStock <= 5
                                              ? Colors.orange[100]
                                              : Colors.green[100]),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color:
                                        isOutOfStock
                                            ? Colors.red[300]!
                                            : (totalStock <= 5
                                                ? Colors.orange[300]!
                                                : Colors.green[300]!),
                                  ),
                                ),
                                child: Text(
                                  '${totalStock}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color:
                                        isOutOfStock
                                            ? Colors.red[700]
                                            : (totalStock <= 5
                                                ? Colors.orange[700]
                                                : Colors.green[700]),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        Spacer(),

                        // Add to Cart Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                isOutOfStock
                                    ? null
                                    : () => PDC.showOptionsModal(item, context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isOutOfStock
                                      ? Colors.grey[400]
                                      : Colors.blue[600],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 8),
                              elevation: isOutOfStock ? 0 : 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isOutOfStock
                                      ? Icons.block
                                      : Icons.add_shopping_cart,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  isOutOfStock ? 'ໝົດ' : 'ເພີ່ມ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    );
  }
}
