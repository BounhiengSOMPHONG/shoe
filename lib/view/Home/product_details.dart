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
  Widget build(BuildContext context) {
    List<String> sizes = (widget.product.size ?? "null").split(',');
    List<String> colors = (widget.product.color ?? "null").split(',');

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(color: Color(0xFFE8F5E9)),
              child: Image.network(
                widget.product.image ?? '',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.name ?? 'Unnamed Product',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${widget.product.price} K',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.product.description ?? 'No description available',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Size',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: sizes.length,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => GestureDetector(
                            onTap: () => controller.setSelectedSize(index),
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
                                          : Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    sizes[index].trim(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          controller.selectedSizeIndex.value ==
                                                  index
                                              ? Colors.green
                                              : Colors.black,
                                    ),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: colors.length,
                      itemBuilder: (context, index) {
                        return Obx(
                          () => GestureDetector(
                            onTap: () => controller.setSelectedColor(index),
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
                                          : Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    colors[index].trim(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          controller.selectedColorIndex.value ==
                                                  index
                                              ? Colors.green
                                              : Colors.black,
                                    ),
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
                  ElevatedButton(
                    onPressed:
                        () =>
                            controller.addToCart(widget.product, sizes, colors),
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
      ),
    );
  }
}
