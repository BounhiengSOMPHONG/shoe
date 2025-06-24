import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../model/product_m.dart';
import 'cart_c.dart';
import 'shop_c.dart';

class ProductDetailsC extends GetxController {
  late CartC cartC;
  late ShopC shopC;

  @override
  void onInit() {
    super.onInit();
    cartC = Get.put(CartC());
    shopC = Get.put(ShopC());
  }

  final RxInt selectedSizeIndex = 0.obs;
  final RxInt selectedColorIndex = 0.obs;
  final Rx<PItem?> currentProduct = Rx<PItem?>(null);
  final Rx<StockItem?> selectedStockItem = Rx<StockItem?>(null);

  void setProduct(PItem product) {
    currentProduct.value = product;
    // Reset selections when a new product is set
    selectedSizeIndex.value = 0;
    selectedColorIndex.value = 0;
    updateSelectedStockItem();
  }

  void setSelectedSize(int index) {
    selectedSizeIndex.value = index;
    // Reset color selection when size changes
    selectedColorIndex.value = 0;
    updateSelectedStockItem();
  }

  void setSelectedColor(int index) {
    selectedColorIndex.value = index;
    updateSelectedStockItem();
  }

  void updateSelectedStockItem() {
    if (currentProduct.value == null ||
        currentProduct.value!.Stock == null ||
        currentProduct.value!.Stock!.isEmpty) {
      selectedStockItem.value = null;
      return;
    }

    final availableStockForSelectedSize =
        currentProduct.value!.Stock!
            .where(
              (stock) =>
                  stock.Size == getAvailableSizes()[selectedSizeIndex.value],
            )
            .toList();

    if (availableStockForSelectedSize.isEmpty) {
      selectedStockItem.value = null;
      return;
    }

    // Ensure selectedColorIndex is within bounds of available colors for the selected size
    final availableColors = getAvailableColors();
    if (selectedColorIndex.value >= availableColors.length) {
      selectedColorIndex.value = 0;
    }

    final selectedSize = getAvailableSizes()[selectedSizeIndex.value];
    final selectedColor = availableColors[selectedColorIndex.value];

    selectedStockItem.value = currentProduct.value!.Stock!.firstWhereOrNull(
      (stock) => stock.Size == selectedSize && stock.Color == selectedColor,
    );
  }

  List<String> getAvailableSizes() {
    if (currentProduct.value == null || currentProduct.value!.Stock == null) {
      return [];
    }
    return currentProduct.value!.Stock!
        .map((stock) => stock.Size)
        .where((size) => size != null && size.isNotEmpty)
        .cast<String>() // Cast to non-nullable String
        .toSet()
        .toList();
  }

  List<String> getAvailableColors() {
    if (currentProduct.value == null || currentProduct.value!.Stock == null) {
      return [];
    }
    final selectedSize = getAvailableSizes()[selectedSizeIndex.value];
    return currentProduct.value!.Stock!
        .where(
          (stock) => stock.Size == selectedSize && (stock.Quantity ?? 0) > 0,
        )
        .map((stock) => stock.Color)
        .where((color) => color != null && color.isNotEmpty)
        .cast<String>() // Cast to non-nullable String
        .toSet()
        .toList();
  }

  int getQuantity() {
    return selectedStockItem.value?.Quantity ?? 0;
  }

  void showOptionsModal(PItem product, BuildContext context) {
    setProduct(product); // Set the current product when showing the modal
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        // Add rounded corners to the top of the modal
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            // Add decoration for shadow and background
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ), // Match shape radius
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1), // Soft blue shadow
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Obx(() {
            final sizes = getAvailableSizes();
            final colors = getAvailableColors();
            final quantity = getQuantity();
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? 'Product',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ), // Changed text color
                ),
                SizedBox(height: 8),
                Text(
                  '${product.price} K',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue, // Changed price color to blue
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Select Size:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ), // Changed text color
                ),
                SizedBox(height: 8),
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: sizes.length,
                    itemBuilder: (context, index) {
                      final size = sizes[index];
                      // Check if this size has any stock with quantity > 0
                      final isSizeAvailable =
                          product.Stock?.any(
                            (stock) =>
                                stock.Size == size && (stock.Quantity ?? 0) > 0,
                          ) ??
                          false;
                      return GestureDetector(
                        onTap:
                            isSizeAvailable
                                ? () => setSelectedSize(index)
                                : null,
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  selectedSizeIndex.value == index
                                      ? Colors
                                          .blue // Changed border color to blue
                                      : Colors
                                          .grey[300]!, // Adjusted grey shade
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color:
                                selectedSizeIndex.value == index
                                    ? Colors.blue.withOpacity(
                                      0.1,
                                    ) // Changed background color to blue with opacity
                                    : (isSizeAvailable
                                        ? Colors.white
                                        : Colors
                                            .grey
                                            .shade200), // Adjusted grey shade
                          ),
                          child: Center(
                            child: Text(
                              size.trim(),
                              style: TextStyle(
                                color:
                                    selectedSizeIndex.value == index
                                        ? Colors
                                            .blue[800] // Changed text color to blue
                                        : (isSizeAvailable
                                            ? Colors
                                                .blue[600] // Changed text color to blue
                                            : Colors.grey.shade600),
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
                  'Select Color:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ), // Changed text color
                ),
                SizedBox(height: 8),
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      final color = colors[index];
                      // Check if this color has stock with quantity > 0 for the selected size
                      final isColorAvailable =
                          product.Stock?.any(
                            (stock) =>
                                stock.Size ==
                                    getAvailableSizes()[selectedSizeIndex
                                        .value] &&
                                stock.Color == color &&
                                (stock.Quantity ?? 0) > 0,
                          ) ??
                          false;
                      return GestureDetector(
                        onTap:
                            isColorAvailable
                                ? () => setSelectedColor(index)
                                : null,
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  selectedColorIndex.value == index
                                      ? Colors
                                          .blue // Changed border color to blue
                                      : Colors
                                          .grey[300]!, // Adjusted grey shade
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color:
                                selectedColorIndex.value == index
                                    ? Colors.blue.withOpacity(
                                      0.1,
                                    ) // Changed background color to blue with opacity
                                    : (isColorAvailable
                                        ? Colors.white
                                        : Colors
                                            .grey
                                            .shade200), // Adjusted grey shade
                          ),
                          child: Center(
                            child: Text(
                              color.trim(),
                              style: TextStyle(
                                color:
                                    selectedColorIndex.value == index
                                        ? Colors
                                            .blue[800] // Changed text color to blue
                                        : (isColorAvailable
                                            ? Colors
                                                .blue[600] // Changed text color to blue
                                            : Colors.grey.shade600),
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
                    color: Colors.blue[800],
                  ), // Changed text color
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        quantity > 0
                            ? () {
                              addToCart();
                              Navigator.pop(context);
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue, // Changed button color to blue
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        // Added rounded corners to button
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ), // Kept text white for contrast
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  void addToCart() {
    if (currentProduct.value == null ||
        selectedStockItem.value == null ||
        (selectedStockItem.value!.Quantity ?? 0) == 0) {
      // Cannot add to cart if no product or stock item is selected, or if quantity is 0
      return;
    }

    final product = currentProduct.value!;
    final stockItem = selectedStockItem.value!;

    final cartItem = PItem(
      id: product.id,
      name: product.name,
      price: product.price,
      description: product.description,
      image: product.image,
      size: stockItem.Size,
      color: stockItem.Color,
      quantity: 1, // Add one item at a time
      Stock: [stockItem], // Include the selected stock item
    );

    cartC.addItem(cartItem);
  }
}
