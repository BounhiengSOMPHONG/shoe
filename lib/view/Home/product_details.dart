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
        backgroundColor: Colors.green,
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
                decoration: BoxDecoration(color: Color(0xFFE8F5E9)),
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
                        color: Colors.green,
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
                                            ? Colors.green
                                            : Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      controller.selectedSizeIndex.value ==
                                              index
                                          ? Colors.green.withOpacity(0.1)
                                          : (isSizeAvailable
                                              ? Colors.white
                                              : Colors.grey.shade300),
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
                                              ? Colors.green
                                              : (isSizeAvailable
                                                  ? Colors.black
                                                  : Colors.grey.shade600),
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
                                            ? Colors.green
                                            : Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      controller.selectedColorIndex.value ==
                                              index
                                          ? Colors.green.withOpacity(0.1)
                                          : (isColorAvailable
                                              ? Colors.white
                                              : Colors.grey.shade300),
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
                                              ? Colors.green
                                              : (isColorAvailable
                                                  ? Colors.black
                                                  : Colors.grey.shade600),
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
                        backgroundColor: Colors.green,
                        minimumSize: Size(double.infinity, 50),
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
