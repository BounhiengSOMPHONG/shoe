import 'package:app_shoe/controller/profile_c.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Helper function to format date for display using built-in Dart methods
  String _formatDateForDisplay(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'ບໍ່ໄດ້ລະບຸ';

    try {
      // Handle both date formats (YYYY-MM-DD or ISO format)
      String cleanDate = dateString;
      if (dateString.contains('T')) {
        cleanDate = dateString.split('T')[0];
      }

      final date = DateTime.parse(cleanDate);

      // Format date manually: dd MMM yyyy
      final months = [
        'ມ.ກ.',
        'ກ.ພ.',
        'ມ.ນ.',
        'ເມ.ສ.',
        'ພ.ຄ.',
        'ມິ.ຖ.',
        'ກ.ລ.',
        'ສ.ຫ.',
        'ກ.ຍ.',
        'ຕ.ລ.',
        'ພ.ຈ.',
        'ທ.ວ.',
      ];

      return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmation(ProfileC profileC) {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'ລົບບັນຊີ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'ທ່ານແນ່ໃຈບໍ່ວ່າຕ້ອງການລົບບັນຊີຂອງທ່ານ? ການກະທຳນີ້ບໍ່ສາມາດຍົກເລີກໄດ້.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('ຍົກເລີກ'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              profileC.deleteAccount();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('ລົບ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileC profileC = Get.put(ProfileC());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'ໂປຣໄຟລ໌',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (profileC.isLoading.value && profileC.currentUser.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Header
              _buildProfileHeader(profileC),
              const SizedBox(height: 24),

              // Profile Form
              _buildProfileForm(context, profileC),
              const SizedBox(height: 24),

              // Password Change Section
              _buildPasswordChangeSection(profileC),
              const SizedBox(height: 32),

              // Action Buttons
              _buildActionButtons(profileC),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(ProfileC profileC) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.person, size: 40, color: Colors.blue),
          ),
          const SizedBox(width: 16),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    profileC.currentUser.value?.fullName ?? 'ກຳລັງໂຫຼດ...',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    profileC.currentUser.value?.email ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    'ID: ${profileC.currentUser.value?.uid ?? ''}',
                    style: const TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context, ProfileC profileC) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ຂໍ້ມູນສ່ວນບຸກຄົນ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Obx(
                () => IconButton(
                  onPressed: () => profileC.toggleEditMode(),
                  icon: Icon(
                    profileC.isEditing.value ? Icons.close : Icons.edit,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // First Name
          _buildFormField(
            controller: profileC.firstNameController,
            label: 'ຊື່',
            icon: Icons.person_outline,
            enabled: profileC.isEditing.value,
          ),

          // Last Name
          _buildFormField(
            controller: profileC.lastNameController,
            label: 'ນາມສະກຸນ',
            icon: Icons.person_outline,
            enabled: profileC.isEditing.value,
          ),

          // Email
          _buildFormField(
            controller: profileC.emailController,
            label: 'ອີເມວ',
            icon: Icons.email_outlined,
            enabled: profileC.isEditing.value,
            keyboardType: TextInputType.emailAddress,
          ),

          // Phone
          _buildFormField(
            controller: profileC.phoneController,
            label: 'ເບີໂທ',
            icon: Icons.phone_outlined,
            enabled: profileC.isEditing.value,
            keyboardType: TextInputType.phone,
          ),

          // Date of Birth
          Obx(
            () => _buildFormField(
              controller: profileC.datebirthController,
              label: 'ວັນເກີດ',
              icon: Icons.calendar_today_outlined,
              enabled: profileC.isEditing.value,
              readOnly: true,
              onTap:
                  profileC.isEditing.value
                      ? () => profileC.selectDate(context)
                      : null,
            ),
          ),

          // Sex
          Obx(() => _buildSexDropdown(profileC)),

          // Update Button (shown only in edit mode)
          Obx(
            () =>
                profileC.isEditing.value
                    ? Container(
                      margin: const EdgeInsets.only(top: 16),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            profileC.isLoading.value
                                ? null
                                : () => profileC.updateProfile(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child:
                            profileC.isLoading.value
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  'ອັບເດດໂປຣໄຟລ໌',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    )
                    : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        readOnly: readOnly,
        keyboardType: keyboardType,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          filled: !enabled,
          fillColor: enabled ? null : Colors.grey.shade50,
        ),
      ),
    );
  }

  Widget _buildSexDropdown(ProfileC profileC) {
    // Define the dropdown items
    final List<DropdownMenuItem<String>> dropdownItems = [
      const DropdownMenuItem<String>(value: 'ຊາຍ', child: Text('ຊາຍ')),
      const DropdownMenuItem<String>(value: 'ຍິງ', child: Text('ຍິງ')),
    ];

    // Get current value, ensure it's valid
    String currentValue = profileC.selectedSex.value;
    if (currentValue != 'ຊາຍ' && currentValue != 'ຍິງ') {
      currentValue = 'ຊາຍ'; // Default fallback
      profileC.selectedSex.value = currentValue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        onChanged:
            profileC.isEditing.value
                ? (value) {
                  if (value != null) {
                    profileC.selectedSex.value = value;
                  }
                }
                : null,
        decoration: InputDecoration(
          labelText: 'ເພດ',
          prefixIcon: const Icon(Icons.wc_outlined, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          filled: !profileC.isEditing.value,
          fillColor: profileC.isEditing.value ? null : Colors.grey.shade50,
        ),
        items: dropdownItems,
      ),
    );
  }

  Widget _buildPasswordChangeSection(ProfileC profileC) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ປ່ຽນລະຫັດຜ່ານ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Obx(
                () => IconButton(
                  onPressed: () => profileC.togglePasswordChangeMode(),
                  icon: Icon(
                    profileC.isChangingPassword.value
                        ? Icons.close
                        : Icons.lock_outline,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),

          Obx(
            () =>
                profileC.isChangingPassword.value
                    ? Column(
                      children: [
                        const SizedBox(height: 16),

                        // Current Password
                        _buildPasswordField(
                          controller: profileC.currentPasswordController,
                          label: 'ລະຫັດຜ່ານປັດຈຸບັນ',
                          isHidden: profileC.isCurrentPasswordHidden.value,
                          onToggleVisibility:
                              () => profileC.toggleCurrentPasswordVisibility(),
                        ),

                        // New Password
                        _buildPasswordField(
                          controller: profileC.newPasswordController,
                          label: 'ລະຫັດຜ່ານໃໝ່',
                          isHidden: profileC.isNewPasswordHidden.value,
                          onToggleVisibility:
                              () => profileC.toggleNewPasswordVisibility(),
                        ),

                        // Confirm New Password
                        _buildPasswordField(
                          controller: profileC.confirmPasswordController,
                          label: 'ຢືນຢັນລະຫັດຜ່ານໃໝ່',
                          isHidden: profileC.isConfirmPasswordHidden.value,
                          onToggleVisibility:
                              () => profileC.toggleConfirmPasswordVisibility(),
                        ),

                        // Password Requirements Info
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.blue.shade600,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'ລະຫັດຜ່ານຕ້ອງມີຄວາມຍາວຢ່າງໜ້ອຍ 6 ຕົວອັກສອນ',
                                  style: TextStyle(
                                    color: Colors.blue.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Change Password Button
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                profileC.isLoading.value
                                    ? null
                                    : () => profileC.changePassword(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            child:
                                profileC.isLoading.value
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Text(
                                      'ປ່ຽນລະຫັດຜ່ານ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    )
                    : Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'ກົດເພື່ອປ່ຽນລະຫັດຜ່ານຂອງທ່ານ',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isHidden,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: isHidden,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.blue),
          suffixIcon: IconButton(
            onPressed: onToggleVisibility,
            icon: Icon(
              isHidden ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey.shade600,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(ProfileC profileC) {
    return Column(
      children: [
        // Delete Account Button
        Container(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed:
                profileC.isLoading.value
                    ? null
                    : () => _showDeleteConfirmation(profileC),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text(
              'ລົບບັນຊີ',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Registration Date Info
        Obx(
          () => Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey.shade600, size: 16),
                const SizedBox(width: 8),
                Text(
                  'ສະມາຊິກຕັ້ງແຕ່: ${_formatDateForDisplay(profileC.currentUser.value?.registrationDate)}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
