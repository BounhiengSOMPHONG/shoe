import 'package:app_shoe/controller/account/address_c.dart';
import 'package:app_shoe/model/address_m.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditAddressPage extends StatefulWidget {
  final Address address;

  const EditAddressPage({super.key, required this.address});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final AddressC addressController = Get.find<AddressC>();

  late TextEditingController villageController;
  late TextEditingController districtController;
  late TextEditingController provinceController;
  late TextEditingController transportationController;
  late TextEditingController branchController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing address data
    villageController = TextEditingController(text: widget.address.village);
    districtController = TextEditingController(text: widget.address.district);
    provinceController = TextEditingController(text: widget.address.province);
    transportationController = TextEditingController(
      text: widget.address.transportation ?? '',
    );
    branchController = TextEditingController(text: widget.address.branch ?? '');
  }

  @override
  void dispose() {
    villageController.dispose();
    districtController.dispose();
    provinceController.dispose();
    transportationController.dispose();
    branchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Address',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.edit_location_alt, color: Colors.blue.shade600),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Editing Address for:',
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${widget.address.firstName} ${widget.address.lastName}',
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.address.phone,
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Form Fields
            _buildFormSection(),

            const SizedBox(height: 32),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Address Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Village
          _buildTextField(
            controller: villageController,
            label: 'Village *',
            icon: Icons.home_outlined,
            required: true,
          ),

          // District
          _buildTextField(
            controller: districtController,
            label: 'District *',
            icon: Icons.location_city_outlined,
            required: true,
          ),

          // Province
          _buildTextField(
            controller: provinceController,
            label: 'Province *',
            icon: Icons.map_outlined,
            required: true,
          ),

          // Transportation
          _buildTextField(
            controller: transportationController,
            label: 'Transportation',
            icon: Icons.local_shipping_outlined,
            required: false,
          ),

          // Branch
          _buildTextField(
            controller: branchController,
            label: 'Branch',
            icon: Icons.store_outlined,
            required: false,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool required,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Update Button
        Container(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _updateAddress,
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text(
              'Update Address',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Delete Button
        Container(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => addressController.deleteAddress(widget.address),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text(
              'Delete Address',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _updateAddress() {
    // Validate required fields
    if (villageController.text.trim().isEmpty ||
        districtController.text.trim().isEmpty ||
        provinceController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields (Village, District, Province)',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Prepare data for update
    final data = {
      'Village': villageController.text.trim(),
      'District': districtController.text.trim(),
      'Province': provinceController.text.trim(),
      'Transportation': transportationController.text.trim(),
      'Branch': branchController.text.trim(),
    };

    // Call update function
    addressController.updateAddress(widget.address, data);
  }
}
