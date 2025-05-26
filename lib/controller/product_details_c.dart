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

  void setSelectedSize(int index) {
    selectedSizeIndex.value = index;
  }

  void setSelectedColor(int index) {
    selectedColorIndex.value = index;
  }

  void showOptionsModal(
    PItem product,
    List<String> sizes,
    List<String> colors,
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? 'Product',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '${product.price} K',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Select Size:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        onTap: () => setSelectedSize(index),
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  selectedSizeIndex.value == index
                                      ? Colors.green
                                      : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color:
                                selectedSizeIndex.value == index
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              sizes[index].trim(),
                              style: TextStyle(
                                color:
                                    selectedSizeIndex.value == index
                                        ? Colors.green
                                        : Colors.black,
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
                'Select Color:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        onTap: () => setSelectedColor(index),
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  selectedColorIndex.value == index
                                      ? Colors.green
                                      : Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color:
                                selectedColorIndex.value == index
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              colors[index].trim(),
                              style: TextStyle(
                                color:
                                    selectedColorIndex.value == index
                                        ? Colors.green
                                        : Colors.black,
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    addToCart(product, sizes, colors);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void addToCart(PItem product, List<String> sizes, List<String> colors) {
    int index = shopC.items.indexOf(product);
    if (index != -1) {
      String selectedSize = sizes[selectedSizeIndex.value].trim();
      String selectedColor = colors[selectedColorIndex.value].trim();

      final cartItem = PItem(
        id: product.id,
        name: product.name,
        price: product.price,
        description: product.description,
        image: product.image,
        size: selectedSize,
        color: selectedColor,
        quantity: 1,
      );

      cartC.addItem(cartItem);
    }
  }
}
