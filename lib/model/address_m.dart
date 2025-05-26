class Address {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String village;
  final String district;
  final String province;
  final String? transportation;
  final String? branch;
  final bool isDefault;

  Address({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.village,
    required this.district,
    required this.province,
    this.transportation,
    this.branch,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['Address_ID'] ?? '',
      firstName: json['FirstName'] ?? '',
      lastName: json['LastName'] ?? '',
      phone: json['Phone'] ?? '',
      village: json['Village'] ?? '',
      district: json['District'] ?? '',
      province: json['Province'] ?? '',
      transportation: json['Transportation'],
      branch: json['Branch'],
      isDefault: json['IsDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Address_ID': id,
      'FirstName': firstName,
      'LastName': lastName,
      'Phone': phone,
      'Village': village,
      'District': district,
      'Province': province,
      'Transportation': transportation,
      'Branch': branch,
      'IsDefault': isDefault,
    };
  }
}
