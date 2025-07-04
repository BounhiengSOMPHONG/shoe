import 'package:flutter/material.dart';
import 'package:app_shoe/model/product_m.dart';
import 'package:get/get.dart';
import 'package:app_shoe/controller/product_details_c.dart';
import 'package:app_shoe/controller/favorite_c.dart';

class ProductDetails extends StatefulWidget {
  final PItem product;

  ProductDetails({required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> with TickerProviderStateMixin {
  final ProductDetailsC controller = Get.put(ProductDetailsC());
  final FavoriteC favorite_c = Get.put(FavoriteC());
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    controller.setProduct(widget.product);
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        final product = controller.currentProduct.value;
        if (product == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                  strokeWidth: 3,
                ),
                SizedBox(height: 20),
                Text(
                  'กำลังโหลดข้อมูลสินค้า...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        final sizes = controller.getAvailableSizes();
        final colors = controller.getAvailableColors();
        final quantity = controller.getQuantity();

        return FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              // Custom App Bar with Image
              SliverAppBar(
                expandedHeight: screenHeight * 0.5,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                leading: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new, 
                      color: Colors.blueGrey[800], 
                      size: 20,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
                actions: [
                  // Favorite Button in top right corner
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Obx(() => IconButton(
                      icon: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: Icon(
                          favorite_c.isFavorite(product.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          key: ValueKey(favorite_c.isFavorite(product.id)),
                          color: favorite_c.isFavorite(product.id)
                              ? Colors.red.shade500
                              : Colors.blueGrey[400],
                          size: 24,
                        ),
                      ),
                      onPressed: () => favorite_c.toggleFavorite(product),
                    )),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue.shade50,
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Hero(
                      tag: 'product_${product.id}',
                      child: Container(
                        padding: EdgeInsets.only(top: 100, bottom: 20),
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.1),
                                  spreadRadius: 3,
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                product.image ?? '',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 50,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'ไม่สามารถโหลดรูปภาพได้',
                                            style: TextStyle(
                                              color: Colors.grey[500],
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
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Product Details Content
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name and Brand
                        _buildProductHeader(product),
                        
                        SizedBox(height: 24),
                        
                        // Price
                        _buildPriceSection(product),
                        
                        SizedBox(height: 24),
                        
                        // Description
                        _buildDescriptionSection(product),
                        
                        SizedBox(height: 32),
                        
                        // Size Selection
                        if (sizes.isNotEmpty) _buildSizeSelection(sizes, product),
                        
                        SizedBox(height: 24),
                        
                        // Color Selection
                        if (colors.isNotEmpty) _buildColorSelection(colors, product, sizes),
                        
                        SizedBox(height: 24),
                        
                        // Quantity Available
                        _buildQuantitySection(quantity),
                        
                        SizedBox(height: 32),
                        
                        // Add to Cart Button
                        _buildAddToCartButton(quantity),
                        
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProductHeader(PItem product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                product.brand ?? 'Unknown Brand',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          product.name ?? 'Unnamed Product',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection(PItem product) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade500, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ราคา',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${product.price} ກີບ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Icon(
            Icons.monetization_on,
            color: Colors.white.withOpacity(0.8),
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(PItem product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.description_outlined,
              color: Colors.blue.shade600,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'รายละเอียดสินค้า',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            product.description ?? 'ไม่มีรายละเอียดสินค้า',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueGrey[700],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeSelection(List<String> sizes, PItem product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.straighten,
              color: Colors.blue.shade600,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'เลือกไซส์',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sizes.length,
            itemBuilder: (context, index) {
              final size = sizes[index];
              final isSizeAvailable = product.Stock?.any(
                (stock) => stock.Size == size && (stock.Quantity ?? 0) > 0,
              ) ?? false;
              
              return Obx(() => GestureDetector(
                onTap: isSizeAvailable ? () => controller.setSelectedSize(index) : null,
                child: Container(
                  margin: EdgeInsets.only(right: 12),
                  width: 60,
                  decoration: BoxDecoration(
                    color: controller.selectedSizeIndex.value == index
                        ? Colors.blue.shade600
                        : (isSizeAvailable ? Colors.white : Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: controller.selectedSizeIndex.value == index
                          ? Colors.blue.shade600
                          : (isSizeAvailable ? Colors.grey.shade300 : Colors.grey.shade400),
                      width: 2,
                    ),
                    boxShadow: controller.selectedSizeIndex.value == index
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      size.trim(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: controller.selectedSizeIndex.value == index
                            ? Colors.white
                            : (isSizeAvailable ? Colors.blueGrey[800] : Colors.grey.shade500),
                      ),
                    ),
                  ),
                ),
              ));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelection(List<String> colors, PItem product, List<String> sizes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.palette_outlined,
              color: Colors.blue.shade600,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'เลือกสี',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: colors.length,
            itemBuilder: (context, index) {
              final color = colors[index];
              final isColorAvailable = product.Stock?.any(
                (stock) =>
                    stock.Size == sizes[controller.selectedSizeIndex.value] &&
                    stock.Color == color &&
                    (stock.Quantity ?? 0) > 0,
              ) ?? false;

              return Obx(() => GestureDetector(
                onTap: isColorAvailable ? () => controller.setSelectedColor(index) : null,
                child: Container(
                  margin: EdgeInsets.only(right: 12),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: controller.selectedColorIndex.value == index
                        ? Colors.blue.shade600
                        : (isColorAvailable ? Colors.white : Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: controller.selectedColorIndex.value == index
                          ? Colors.blue.shade600
                          : (isColorAvailable ? Colors.grey.shade300 : Colors.grey.shade400),
                      width: 2,
                    ),
                    boxShadow: controller.selectedColorIndex.value == index
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      color.trim(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: controller.selectedColorIndex.value == index
                            ? Colors.white
                            : (isColorAvailable ? Colors.blueGrey[800] : Colors.grey.shade500),
                      ),
                    ),
                  ),
                ),
              ));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySection(int quantity) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: quantity > 0 ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: quantity > 0 ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            quantity > 0 ? Icons.inventory_2_outlined : Icons.error_outline,
            color: quantity > 0 ? Colors.green.shade600 : Colors.red.shade600,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'สถานะสินค้า',
                  style: TextStyle(
                    fontSize: 14,
                    color: quantity > 0 ? Colors.green.shade700 : Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  quantity > 0 ? 'มีสินค้าในสต็อก $quantity ชิ้น' : 'สินค้าหมด',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: quantity > 0 ? Colors.green.shade800 : Colors.red.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(int quantity) {
    return Container(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: quantity > 0 ? () => controller.addToCart() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: quantity > 0 ? Colors.blue.shade600 : Colors.grey.shade400,
          foregroundColor: Colors.white,
          elevation: quantity > 0 ? 8 : 0,
          shadowColor: quantity > 0 ? Colors.blue.withOpacity(0.4) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              quantity > 0 ? Icons.add_shopping_cart : Icons.block,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              quantity > 0 ? 'เพิ่มลงตะกร้า' : 'สินค้าหมด',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
