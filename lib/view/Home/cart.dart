import 'package:app_shoe/controller/cart_c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final cart_c = Get.put(CartC());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed background to white
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cart header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    16,
                  ), // Increased border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(
                        0.1,
                      ), // Changed shadow color to blue
                      spreadRadius: 2, // Adjusted spread radius
                      blurRadius: 8, // Adjusted blur radius
                      offset: Offset(0, 4), // Adjusted offset
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Cart',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800], // Changed text color to blue
                      ),
                    ),
                    Obx(
                      () => Text(
                        '${cart_c.items.length} Items',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[600],
                        ), // Changed text color to blue
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Cart items
              Expanded(
                child: Obx(
                  () =>
                      cart_c.items.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 64,
                                  color:
                                      Colors
                                          .blue[300], // Changed icon color to blue
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Your cart is empty',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        Colors
                                            .blue[600], // Changed text color to blue
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            itemCount: cart_c.items.length,
                            itemBuilder: (context, index) {
                              final item = cart_c.items[index];
                              return Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  cart_c.removeItem(index);
                                },
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 20.0),
                                  color:
                                      Colors
                                          .redAccent, // Kept red for delete action
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      16,
                                    ), // Increased border radius
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(
                                          0.1,
                                        ), // Changed shadow color to blue
                                        spreadRadius:
                                            2, // Adjusted spread radius
                                        blurRadius: 8, // Adjusted blur radius
                                        offset: Offset(0, 4), // Adjusted offset
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        // Product image
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12, // Adjusted image border radius
                                          ),
                                          child: Image.network(
                                            item.image ?? '',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Container(
                                                width: 80,
                                                height: 80,
                                                color:
                                                    Colors
                                                        .blue[50], // Changed placeholder color to light blue
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color:
                                                      Colors
                                                          .blue[300], // Changed icon color to blue
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        // Product details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.name ?? 'Unnamed Product',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      Colors
                                                          .blue[800], // Changed text color to blue
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              if (item.size != null)
                                                Text(
                                                  'Size: ${item.size}',
                                                  style: TextStyle(
                                                    color:
                                                        Colors
                                                            .blue[600], // Changed text color to blue
                                                  ),
                                                ),
                                              if (item.color != null)
                                                Text(
                                                  'Color: ${item.color}',
                                                  style: TextStyle(
                                                    color:
                                                        Colors
                                                            .blue[600], // Changed text color to blue
                                                  ),
                                                ),
                                              SizedBox(height: 4),
                                              Text(
                                                'ລາຄາ: ${item.price} K',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      Colors
                                                          .blue, // Changed price color to blue
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                            ],
                                          ),
                                        ),
                                        // Quantity controls
                                        Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors
                                                        .blue[50], // Changed background color to light blue
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.remove,
                                                      size: 20,
                                                    ),
                                                    color:
                                                        Colors
                                                            .blue, // Changed icon color to blue
                                                    onPressed:
                                                        () => cart_c
                                                            .updateQuantity(
                                                              index,
                                                              -1,
                                                            ),
                                                  ),
                                                  Text(
                                                    '${item.quantity ?? 1}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors
                                                              .blue[800], // Changed text color to blue
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.add,
                                                      size: 20,
                                                    ),
                                                    color:
                                                        Colors
                                                            .blue, // Changed icon color to blue
                                                    onPressed:
                                                        () => cart_c
                                                            .updateQuantity(
                                                              index,
                                                              1,
                                                            ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ),

              // Cart total and checkout
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    16,
                  ), // Increased border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(
                        0.1,
                      ), // Changed shadow color to blue
                      spreadRadius: 2, // Adjusted spread radius
                      blurRadius: 8, // Adjusted blur radius
                      offset: Offset(0, 4), // Adjusted offset
                    ),
                  ],
                ),
                child: Obx(
                  () => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ທັງໝົດ:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  Colors
                                      .blue[800], // Changed text color to blue
                            ),
                          ),
                          Text(
                            '${cart_c.total.toStringAsFixed(0)} K',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue, // Changed text color to blue
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              cart_c.items.isEmpty
                                  ? null
                                  : () => cart_c.Checkout(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blue, // Changed button color to blue
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Checkout',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
      ),
    );
  }
}
