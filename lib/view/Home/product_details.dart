import 'package:flutter/material.dart';
import 'package:app_shoe/model/product_m.dart';
import 'package:get/get.dart';
import 'package:app_shoe/controller/product_details_c.dart';

class ProductDetails extends StatefulWidget {
  final PItem product;

  ProductDetails({required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final ProductDetailsC controller = Get.put(ProductDetailsC());

  @override
  void initState() {
    super.initState();
    controller.setProduct(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Colors.blueAccent, // Changed to light blue accent
      ),
      body: Obx(() {
        final product = controller.currentProduct.value;
        if (product == null) {
          return Center(child: CircularProgressIndicator());
        }

        final sizes = controller.getAvailableSizes();
        final colors = controller.getAvailableColors();
        final quantity = controller.getQuantity();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(
                    0.1,
                  ), // Light blue background
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30), // Rounded bottom corners
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    // Subtle shadow
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2, // Corrected from spreadFactor
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  // Clip image to rounded corners
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Image.network(
                    product.image ?? '',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? 'Unnamed Product',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      product.brand ?? 'Unknown Brand',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${product.price} K',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:
                            Colors
                                .blueAccent, // Changed price color to light blue
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      product.description ?? 'No description available',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Size',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: sizes.length,
                        itemBuilder: (context, index) {
                          final size = sizes[index];
                          final isSizeAvailable =
                              product.Stock?.any(
                                (stock) =>
                                    stock.Size == size &&
                                    (stock.Quantity ?? 0) > 0,
                              ) ??
                              false;
                          return GestureDetector(
                            onTap:
                                isSizeAvailable
                                    ? () => controller.setSelectedSize(index)
                                    : null,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Container(
                                width: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        controller.selectedSizeIndex.value ==
                                                index
                                            ? Colors
                                                .blueAccent // Selected border color
                                            : Colors
                                                .grey
                                                .shade400, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ), // Rounded corners
                                  color:
                                      controller.selectedSizeIndex.value ==
                                              index
                                          ? Colors.blueAccent.withOpacity(
                                            0.2,
                                          ) // Selected background color
                                          : (isSizeAvailable
                                              ? Colors.white
                                              : Colors
                                                  .grey
                                                  .shade200), // Unavailable background color
                                  boxShadow:
                                      controller.selectedSizeIndex.value ==
                                              index
                                          ? [
                                            // Shadow for selected item
                                            BoxShadow(
                                              color: Colors.blueAccent
                                                  .withOpacity(0.3),
                                              spreadRadius:
                                                  1, // Corrected from spreadFactor
                                              blurRadius: 3,
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
                                          controller.selectedSizeIndex.value ==
                                                  index
                                              ? Colors
                                                  .blueAccent // Selected text color
                                              : (isSizeAvailable
                                                  ? Colors
                                                      .black87 // Available text color
                                                  : Colors
                                                      .grey
                                                      .shade600), // Unavailable text color
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Color',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: colors.length,
                        itemBuilder: (context, index) {
                          final color = colors[index];
                          final isColorAvailable =
                              product.Stock?.any(
                                (stock) =>
                                    stock.Size ==
                                        sizes[controller
                                            .selectedSizeIndex
                                            .value] &&
                                    stock.Color == color &&
                                    (stock.Quantity ?? 0) > 0,
                              ) ??
                              false;
                          return GestureDetector(
                            onTap:
                                isColorAvailable
                                    ? () => controller.setSelectedColor(index)
                                    : null,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Container(
                                width: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        controller.selectedColorIndex.value ==
                                                index
                                            ? Colors
                                                .blueAccent // Selected border color
                                            : Colors
                                                .grey
                                                .shade400, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ), // Rounded corners
                                  color:
                                      controller.selectedColorIndex.value ==
                                              index
                                          ? Colors.blueAccent.withOpacity(
                                            0.2,
                                          ) // Selected background color
                                          : (isColorAvailable
                                              ? Colors.white
                                              : Colors
                                                  .grey
                                                  .shade200), // Unavailable background color
                                  boxShadow:
                                      controller.selectedColorIndex.value ==
                                              index
                                          ? [
                                            // Shadow for selected item
                                            BoxShadow(
                                              color: Colors.blueAccent
                                                  .withOpacity(0.3),
                                              spreadRadius:
                                                  1, // Corrected from spreadFactor
                                              blurRadius: 3,
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
                                          controller.selectedColorIndex.value ==
                                                  index
                                              ? Colors
                                                  .blueAccent // Selected text color
                                              : (isColorAvailable
                                                  ? Colors
                                                      .black87 // Available text color
                                                  : Colors
                                                      .grey
                                                      .shade600), // Unavailable text color
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Quantity Available: ${quantity}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed:
                          quantity > 0 ? () => controller.addToCart() : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blueAccent, // Light blue button color
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          // Rounded corners
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8, // Prominent shadow
                        shadowColor: Colors.blueAccent.withOpacity(0.5),
                      ),
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
