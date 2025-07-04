class PItem {
  double? id;
  String? image;
  String? name;
  String? description;
  double? price;
  String? brand;
  String? size;
  String? color;
  int? quantity;
  final List<StockItem>? Stock;

  PItem({
    this.id,
    this.image,
    this.name,
    this.description,
    this.price,
    this.brand,
    this.size,
    this.color,
    this.quantity = 1,
    this.Stock,
  });

  factory PItem.fromJson(Map<String, dynamic> json) {
    return PItem(
      id: (json['Product_ID'] as num?)?.toDouble(),
      image: json['Image'],
      name: json['Name'],
      description: json['Description'],
      price: double.tryParse(json['Price']?.toString() ?? '0.0'),
      brand: json['Brand'],
      size: json['Sizes']?.toString(),
      color: json['Colors'],
      quantity: json['Quantity'] ?? 1,
      Stock:
          (json['Stock'] as List<dynamic>?)
              ?.map((stockJson) => StockItem.fromJson(stockJson))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Product_ID'] = id;
    data['Image'] = image;
    data['Name'] = name;
    data['Description'] = description;
    data['Price'] = price;
    data['Brand'] = brand;
    data['Sizes'] = size;
    data['Colors'] = color;
    data['Quantity'] = quantity;
    return data;
  }
}

class StockItem {
  final String? Size;
  final String? Color;
  final int? Quantity;

  StockItem({this.Size, this.Color, this.Quantity});

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      Size: json['Size'] as String?,
      Color: json['Color'] as String?,
      Quantity: json['Quantity'] as int?,
    );
  }
}

// เพิ่ม ProductType model
class ProductType {
  final int productTypeId;
  final String productTypeName;

  ProductType({required this.productTypeId, required this.productTypeName});

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      productTypeId: json['productType_ID'] ?? 0,
      productTypeName: json['productType_Name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productType_ID': productTypeId,
      'productType_Name': productTypeName,
    };
  }
}

// เพิ่ม Brand model
class Brand {
  final String brandName;

  Brand({required this.brandName});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(brandName: json['Brand'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'Brand': brandName};
  }
}

class Review {
  final int? reviewId;
  final int? userId;
  final int? productId;
  final int? rating;
  final String? comment;
  final DateTime? reviewDate;
  final String? firstName;
  final String? lastName;
  final String? userImage;

  Review({
    this.reviewId,
    this.userId,
    this.productId,
    this.rating,
    this.comment,
    this.reviewDate,
    this.firstName,
    this.lastName,
    this.userImage,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: int.tryParse(json['Review_ID']?.toString() ?? '0'),
      userId: int.tryParse(json['User_ID']?.toString() ?? '0'),
      productId: int.tryParse(json['Product_ID']?.toString() ?? '0'),
      rating: int.tryParse(json['Rating']?.toString() ?? '0'),
      comment: json['Comment'] as String?,
      reviewDate: json['Review_Date'] != null 
        ? DateTime.tryParse(json['Review_Date'].toString())
        : null,
      firstName: json['FirstName'] as String?,
      lastName: json['LastName'] as String?,
      userImage: json['UserImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Review_ID': reviewId,
      'User_ID': userId,
      'Product_ID': productId,
      'Rating': rating,
      'Comment': comment,
      'Review_Date': reviewDate?.toIso8601String(),
      'FirstName': firstName,
      'LastName': lastName,
      'UserImage': userImage,
    };
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
  
  String get displayName {
    if (fullName.isNotEmpty) {
      return fullName;
    }
    return 'Anonymous User';
  }
}

class ReviewSummary {
  final int totalReviews;
  final double averageRating;
  final int rating5;
  final int rating4;
  final int rating3;
  final int rating2;
  final int rating1;

  ReviewSummary({
    required this.totalReviews,
    required this.averageRating,
    required this.rating5,
    required this.rating4,
    required this.rating3,
    required this.rating2,
    required this.rating1,
  });

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    return ReviewSummary(
      totalReviews: int.tryParse(json['totalReviews']?.toString() ?? '0') ?? 0,
      averageRating: double.tryParse(json['averageRating']?.toString() ?? '0.0') ?? 0.0,
      rating5: int.tryParse(json['rating5']?.toString() ?? '0') ?? 0,
      rating4: int.tryParse(json['rating4']?.toString() ?? '0') ?? 0,
      rating3: int.tryParse(json['rating3']?.toString() ?? '0') ?? 0,
      rating2: int.tryParse(json['rating2']?.toString() ?? '0') ?? 0,
      rating1: int.tryParse(json['rating1']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalReviews': totalReviews,
      'averageRating': averageRating,
      'rating5': rating5,
      'rating4': rating4,
      'rating3': rating3,
      'rating2': rating2,
      'rating1': rating1,
    };
  }

  // Helper method to get rating percentage
  double getRatingPercentage(int starRating) {
    if (totalReviews == 0) return 0.0;
    
    switch (starRating) {
      case 5: return (rating5 / totalReviews) * 100;
      case 4: return (rating4 / totalReviews) * 100;
      case 3: return (rating3 / totalReviews) * 100;
      case 2: return (rating2 / totalReviews) * 100;
      case 1: return (rating1 / totalReviews) * 100;
      default: return 0.0;
    }
  }

  // Helper method to get rating count by star
  int getRatingCount(int starRating) {
    switch (starRating) {
      case 5: return rating5;
      case 4: return rating4;
      case 3: return rating3;
      case 2: return rating2;
      case 1: return rating1;
      default: return 0;
    }
  }
}
