import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_shoe/controller/account/new_address_c.dart';

class NewAddress extends StatelessWidget {
  const NewAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewAddressC());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Address'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(16),
            child: Obx(
              () => Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        controller: controller.village,
                        labelText: 'Village/Address*',
                        hintText: 'Enter village name or address',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: controller.district,
                        labelText: 'District*',
                        hintText: 'Enter district name',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: controller.province,
                        labelText: 'Province*',
                        hintText: 'Enter province name',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: controller.transportation,
                        labelText: 'Transportation Service (Optional)',
                        hintText: 'Enter transportation service name',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: controller.branch,
                        labelText: 'Branch (Optional)',
                        hintText: 'Enter branch name',
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed:
                            controller.isLoading.value
                                ? null
                                : controller.saveAddress,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.red,
                        ),
                        child: Text(
                          controller.isLoading.value
                              ? 'Saving...'
                              : 'Save Address',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  if (controller.isLoading.value)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
    );
  }
}
