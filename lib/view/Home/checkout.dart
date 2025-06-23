import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_shoe/controller/account/address_c.dart';
import 'package:app_shoe/controller/cart_c.dart';
import 'package:app_shoe/controller/checkout_c.dart';
import 'package:app_shoe/model/address_m.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final AddressC addressController = Get.put(AddressC());
  final CartC cartController = Get.put(CartC());
  final CheckoutC checkoutController = Get.put(CheckoutC());

  Widget _buildCartItem(dynamic item) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  if (item.size != null)
                    Text(
                      'Size: ${item.size}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  if (item.color != null)
                    Text(
                      'Color: ${item.color}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${item.quantity}x',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${item.price} K',
                  style: TextStyle(
                    color: Colors.teal[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }

  void _handleCheckout() {
    if (checkoutController.selectedAddress.value == null) {
      Get.snackbar(
        'Error',
        'Please select a delivery address',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Prepare items data for checkout with null safety
    final itemsList =
        cartController.items
            .map(
              (item) => {
                'Product_ID': item.id ?? '',
                'Size': item.size ?? '',
                'Color': item.color ?? '',
                'Quantity': item.quantity ?? 0,
                'Unit_Price': item.price ?? 0,
                'Subtotal': (item.price ?? 0) * (item.quantity ?? 0),
              },
            )
            .toList();

    // Process checkout
    checkoutController.processCheckout(
      paymentMethod: checkoutController.selectedPaymentMethod.value,
      addressId: checkoutController.selectedAddress.value!.id,
      totalAmount: cartController.total,
      items: itemsList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Checkout', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cart summary section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'สรุปรายการสั่งซื้อ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Cart items list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartController.items.length,
                    itemBuilder:
                        (context, index) =>
                            _buildCartItem(cartController.items[index]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ທັງໝົດ:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${cartController.total.toStringAsFixed(0)} K',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Shipping address section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ที่อยู่จัดส่ง',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => addressController.addNewAddress(),
                        child: const Text('+ เพิ่มที่อยู่ใหม่'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (addressController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (addressController.addresses.isEmpty) {
                      return const Text('ไม่มีที่อยู่จัดส่ง กรุณาเพิ่มที่อยู่');
                    }

                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'เลือกที่อยู่จัดส่ง',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ...addressController.addresses.map((address) {
                                    final fullName =
                                        '${address.firstName} ${address.lastName}';
                                    return ListTile(
                                      title: Text(fullName),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${address.village}, ${address.district}, ${address.province}',
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        checkoutController
                                            .updateSelectedAddress(address);
                                        Navigator.pop(context);
                                      },
                                      selected:
                                          checkoutController
                                              .selectedAddress
                                              .value
                                              ?.id ==
                                          address.id,
                                    );
                                  }).toList(),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Obx(
                                () =>
                                    checkoutController.selectedAddress.value !=
                                            null
                                        ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${checkoutController.selectedAddress.value!.firstName} ${checkoutController.selectedAddress.value!.lastName}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${checkoutController.selectedAddress.value!.village}, ${checkoutController.selectedAddress.value!.district}, ${checkoutController.selectedAddress.value!.province}',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        )
                                        : const Text(
                                          'เลือกที่อยู่จัดส่ง',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Payment section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ชำระเงิน',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => Column(
                      children: [
                        RadioListTile<String>(
                          value: 'card',
                          groupValue:
                              checkoutController.selectedPaymentMethod.value,
                          onChanged:
                              (value) => checkoutController.updatePaymentMethod(
                                value!,
                              ),
                          title: const Row(
                            children: [
                              Icon(Icons.qr_code),
                              SizedBox(width: 10),
                              Text('Payment'),
                            ],
                          ),
                        ),
                        RadioListTile<String>(
                          value: 'destination',
                          groupValue:
                              checkoutController.selectedPaymentMethod.value,
                          onChanged:
                              (value) => checkoutController.updatePaymentMethod(
                                value!,
                              ),
                          title: const Row(
                            children: [
                              Icon(Icons.payments_outlined),
                              SizedBox(width: 10),
                              Text('ຈ່າຍປາຍທາງ (COD)'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
            // Checkout button at bottom
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _handleCheckout,
                child: const Text(
                  'ยืนยันการสั่งซื้อ',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
