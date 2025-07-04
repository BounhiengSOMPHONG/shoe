import 'package:flutter/material.dart';
import 'package:app_shoe/model/product_m.dart';
import 'package:get/get.dart';
import 'package:app_shoe/controller/product_details_c.dart';
import 'package:app_shoe/controller/favorite_c.dart';
import 'package:app_shoe/controller/review_c.dart';

class ProductDetails extends StatefulWidget {
  final PItem product;

  ProductDetails({required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with TickerProviderStateMixin {
  final ProductDetailsC controller = Get.put(ProductDetailsC());
  final FavoriteC favorite_c = Get.put(FavoriteC());
  final ReviewC reviewController = Get.put(ReviewC());
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    controller.setProduct(widget.product);

    // Initialize reviews when product is loaded
    if (widget.product.id != null) {
      reviewController.initReviewsForProduct(widget.product.id!.toInt());
    }

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

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
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue.shade600,
                  ),
                  strokeWidth: 3,
                ),
                SizedBox(height: 20),
                Text(
                  'ກຳລັງໂຫຼດຂໍ້ມູນສິນຄ້າ...',
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
                    icon: Icon(
                      Icons.arrow_back_ios_new,
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
                    child: Obx(
                      () => IconButton(
                        icon: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: Icon(
                            favorite_c.isFavorite(product.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            key: ValueKey(favorite_c.isFavorite(product.id)),
                            color:
                                favorite_c.isFavorite(product.id)
                                    ? Colors.red.shade500
                                    : Colors.blueGrey[400],
                            size: 24,
                          ),
                        ),
                        onPressed: () => favorite_c.toggleFavorite(product),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue.shade50, Colors.white],
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 50,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'ບໍ່ສາມາດໂຫຼດຮູບພາບໄດ້',
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

                        // Reviews Summary
                        _buildReviewsSummary(),

                        SizedBox(height: 24),

                        // Description
                        _buildDescriptionSection(product),

                        SizedBox(height: 32),

                        // Size Selection
                        if (sizes.isNotEmpty)
                          _buildSizeSelection(sizes, product),

                        SizedBox(height: 24),

                        // Color Selection
                        if (colors.isNotEmpty)
                          _buildColorSelection(colors, product, sizes),

                        SizedBox(height: 24),

                        // Quantity Available
                        _buildQuantitySection(quantity),

                        SizedBox(height: 32),

                        // Add to Cart Button
                        _buildAddToCartButton(quantity),

                        SizedBox(height: 32),

                        // Reviews Section
                        _buildReviewsSection(),

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
                product.brand ?? 'ແບຣນບໍ່ຮູ້ຈັກ',
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
          product.name ?? 'ສິນຄ້າບໍ່ມີຊື່',
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
                'ລາຄາ',
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
              'ລາຍລະອຽດສິນຄ້າ',
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
            product.description ?? 'ບໍ່ມີລາຍລະອຽດສິນຄ້າ',
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
            Icon(Icons.straighten, color: Colors.blue.shade600, size: 24),
            SizedBox(width: 8),
            Text(
              'ເລືອກໄຊສ໌',
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
              final isSizeAvailable =
                  product.Stock?.any(
                    (stock) => stock.Size == size && (stock.Quantity ?? 0) > 0,
                  ) ??
                  false;

              return Obx(
                () => GestureDetector(
                  onTap:
                      isSizeAvailable
                          ? () => controller.setSelectedSize(index)
                          : null,
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    width: 60,
                    decoration: BoxDecoration(
                      color:
                          controller.selectedSizeIndex.value == index
                              ? Colors.blue.shade600
                              : (isSizeAvailable
                                  ? Colors.white
                                  : Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color:
                            controller.selectedSizeIndex.value == index
                                ? Colors.blue.shade600
                                : (isSizeAvailable
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade400),
                        width: 2,
                      ),
                      boxShadow:
                          controller.selectedSizeIndex.value == index
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
                          color:
                              controller.selectedSizeIndex.value == index
                                  ? Colors.white
                                  : (isSizeAvailable
                                      ? Colors.blueGrey[800]
                                      : Colors.grey.shade500),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelection(
    List<String> colors,
    PItem product,
    List<String> sizes,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.palette_outlined, color: Colors.blue.shade600, size: 24),
            SizedBox(width: 8),
            Text(
              'ເລືອກສີ',
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
              final isColorAvailable =
                  product.Stock?.any(
                    (stock) =>
                        stock.Size ==
                            sizes[controller.selectedSizeIndex.value] &&
                        stock.Color == color &&
                        (stock.Quantity ?? 0) > 0,
                  ) ??
                  false;

              return Obx(
                () => GestureDetector(
                  onTap:
                      isColorAvailable
                          ? () => controller.setSelectedColor(index)
                          : null,
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color:
                          controller.selectedColorIndex.value == index
                              ? Colors.blue.shade600
                              : (isColorAvailable
                                  ? Colors.white
                                  : Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color:
                            controller.selectedColorIndex.value == index
                                ? Colors.blue.shade600
                                : (isColorAvailable
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade400),
                        width: 2,
                      ),
                      boxShadow:
                          controller.selectedColorIndex.value == index
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
                          color:
                              controller.selectedColorIndex.value == index
                                  ? Colors.white
                                  : (isColorAvailable
                                      ? Colors.blueGrey[800]
                                      : Colors.grey.shade500),
                        ),
                      ),
                    ),
                  ),
                ),
              );
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
                  'ສະຖານະສິນຄ້າ',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        quantity > 0
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  quantity > 0 ? 'ມີສິນຄ້າໃນສຕ໌ອກ $quantity ຊິ້ນ' : 'ສິນຄ້າໝົດ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        quantity > 0
                            ? Colors.green.shade800
                            : Colors.red.shade800,
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
        onPressed:
            quantity > 0
                ? () {
                  controller.addToCart();
                  // ສະແດງຂໍ້ຄວາມແຈ້ງເຕືອນສຳເລັດ
                  Get.snackbar(
                    'ສຳເລັດ',
                    'ເພີ່ມສິນຄ້າລົງຕະກຣ້າແລ້ວ',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.shade600,
                    colorText: Colors.white,
                    duration: Duration(seconds: 3),
                    margin: EdgeInsets.all(16),
                    borderRadius: 10,
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  );
                }
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              quantity > 0 ? Colors.blue.shade600 : Colors.grey.shade400,
          foregroundColor: Colors.white,
          elevation: quantity > 0 ? 8 : 0,
          shadowColor:
              quantity > 0 ? Colors.blue.withOpacity(0.4) : Colors.transparent,
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
              quantity > 0 ? 'ເພີ່ມລົງຕະກຣ້າ' : 'ສິນຄ້າໝົດ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSummary() {
    return Obx(() {
      final summary = reviewController.reviewSummary.value;
      if (summary == null) {
        return SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber.shade50, Colors.orange.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.orange.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Average Rating Display
            Column(
              children: [
                Text(
                  summary.averageRating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < summary.averageRating.round()
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.orange.shade600,
                      size: 20,
                    );
                  }),
                ),
                SizedBox(height: 4),
                Text(
                  '${summary.totalReviews} ຣີວິວ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(width: 24),
            // Rating Breakdown
            Expanded(
              child: Column(
                children: List.generate(5, (index) {
                  final starRating = 5 - index;
                  final count = summary.getRatingCount(starRating);
                  final percentage = summary.getRatingPercentage(starRating);

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Text(
                          '$starRating',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.star,
                          size: 12,
                          color: Colors.orange.shade600,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: percentage / 100,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade400,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.rate_review_outlined,
              color: Colors.blue.shade600,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'ຣີວິວແລະຄະແນນ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Add Review Form
        _buildAddReviewForm(),

        SizedBox(height: 24),

        // Reviews List
        _buildReviewsList(),
      ],
    );
  }

  Widget _buildAddReviewForm() {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reviewController.hasUserReviewed
                  ? 'ແກ້ໄຂຣີວິວຂອງທ່ານ'
                  : 'ເພີ່ມຣີວິວຂອງທ່ານ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),

            SizedBox(height: 16),

            // Star Rating
            Text(
              'ຄະແນນ:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                final starValue = index + 1;
                return GestureDetector(
                  onTap: () {
                    reviewController.setRating(starValue);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      reviewController.selectedRating.value >= starValue
                          ? Icons.star
                          : Icons.star_border,
                      color:
                          reviewController.selectedRating.value >= starValue
                              ? Colors.orange.shade600
                              : Colors.grey.shade400,
                      size: 32,
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: 16),

            // Comment Field
            Text(
              'ຄວາມຄິດເຫັນ (ບໍ່ບັງຄັບ):',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: reviewController.commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'ຂຽນຄວາມຄິດເຫັນກ່ຽວກັບສິນຄ້ານີ້...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                reviewController.updateComment(value);
              },
            ),

            SizedBox(height: 20),

            // Submit Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        reviewController.canSubmitReview &&
                                !reviewController.isSubmitting.value
                            ? () {
                              reviewController.submitReview(
                                widget.product.id!.toInt(),
                              );
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          reviewController.canSubmitReview
                              ? Colors.blue.shade600
                              : Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child:
                        reviewController.isSubmitting.value
                            ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : Text(
                              reviewController.submitButtonText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
                if (reviewController.hasUserReviewed) ...[
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _showDeleteReviewDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade500,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Icon(Icons.delete_outline, size: 20),
                  ),
                ],
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildReviewsList() {
    return Obx(() {
      if (reviewController.isLoading.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(color: Colors.blue.shade600),
          ),
        );
      }

      if (reviewController.reviews.isEmpty) {
        return Container(
          padding: EdgeInsets.all(40),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.rate_review_outlined,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 16),
                Text(
                  'ຍັງບໍ່ມີຣີວິວສຳລັບສິນຄ້ານີ້',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'ເປັນຄົນທຳອິດທີ່ຣີວິວສິນຄ້ານີ້',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.reviews, color: Colors.blueGrey[600], size: 20),
                SizedBox(width: 8),
                Text(
                  'ຣີວິວຈາກລູກຄ້າ (${reviewController.reviews.length})',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[700],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          ...reviewController.reviews
              .map((review) => _buildReviewItem(review))
              .toList(),
        ],
      );
    });
  }

  Widget _buildReviewItem(Review review) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade100,
                backgroundImage:
                    review.userImage != null && review.userImage!.isNotEmpty
                        ? NetworkImage(review.userImage!)
                        : null,
                child:
                    review.userImage == null || review.userImage!.isEmpty
                        ? Icon(
                          Icons.person,
                          color: Colors.blue.shade600,
                          size: 20,
                        )
                        : null,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.displayName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < (review.rating ?? 0)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.orange.shade600,
                              size: 16,
                            );
                          }),
                        ),
                        SizedBox(width: 8),
                        Text(
                          reviewController.formatReviewDate(review.reviewDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            SizedBox(height: 12),
            Text(
              review.comment!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blueGrey[700],
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showDeleteReviewDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'ລົບຣີວິວ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red.shade700,
          ),
        ),
        content: Text('ທ່ານຕ້ອງການລົບຣີວິວນີ້ຫຼືບໍ່?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'ຍົກເລີກ',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              reviewController.deleteReview(widget.product.id!.toInt());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade500,
            ),
            child: Text('ລົບ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
