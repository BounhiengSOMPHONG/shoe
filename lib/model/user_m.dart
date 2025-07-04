class User {
  final int userId;
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? datebirth;
  final String? sex;
  final String? images;
  final String? registrationDate;

  User({
    required this.userId,
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.datebirth,
    this.sex,
    this.images,
    this.registrationDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['User_ID'] ?? 0,
      uid: json['UID'] ?? '',
      firstName: json['FirstName'] ?? '',
      lastName: json['LastName'] ?? '',
      email: json['Email'] ?? '',
      phone: json['Phone'],
      datebirth: json['Datebirth'],
      sex: json['Sex'],
      images: json['Images'],
      registrationDate: json['Registration_Date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'User_ID': userId,
      'UID': uid,
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'Phone': phone,
      'Datebirth': datebirth,
      'Sex': sex,
      'Images': images,
      'Registration_Date': registrationDate,
    };
  }

  String get fullName => '$firstName $lastName';
}
