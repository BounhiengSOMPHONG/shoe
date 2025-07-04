import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_shoe/controller/account/address_c.dart';
import 'package:app_shoe/model/address_m.dart';

class EditAddress extends StatelessWidget {
  EditAddress({super.key});

  final AddressC controller = Get.put(AddressC());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Addresses'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.addresses.length + 1,
              itemBuilder: (context, index) {
                if (index == controller.addresses.length) {
                  return _buildAddNewAddressButton();
                }

                final address = controller.addresses[index];
                return _buildAddressCard(address);
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAddNewAddressButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
        onPressed: controller.addNewAddress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text('Add New Address', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(Address address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border:
            address.isDefault ? Border.all(color: Colors.blue, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Default badge row
          Row(
            children: [
              Expanded(
                child: Text(
                  '${address.firstName} ${address.lastName}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Default',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          // Phone number
          const SizedBox(height: 4),
          Text(
            'Tel: ${address.phone}',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          // Address details
          const SizedBox(height: 8),
          Text(
            address.village,
            style: TextStyle(color: Colors.grey[800], fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            '${address.district}, ${address.province}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          if (address.transportation != null &&
              address.transportation!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Transport: ${address.transportation}${address.branch != null ? ' (${address.branch})' : ''}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          const SizedBox(height: 16),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Edit button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => controller.editAddress(address),
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: Colors.teal,
                  ),
                  label: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.teal, fontSize: 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.teal),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Delete button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => controller.deleteAddress(address),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
