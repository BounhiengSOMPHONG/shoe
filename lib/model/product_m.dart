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
