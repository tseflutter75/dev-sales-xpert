



class ItemAttribute {
  int? id;
  String? attributeName;
  double? attributePrice;
  int? openingStock;
  int? attributeStock;

  ItemAttribute({
    this.id,
    this.attributeName,
    this.attributePrice,
    this.openingStock,
    this.attributeStock,
  });

  // JSON theke object banano
  factory ItemAttribute.fromJson(Map<String, dynamic> json) {
    return ItemAttribute(
      id: json['id'],
      attributeName: json['attribute_name'],
      attributePrice: json['attribute_price'] != null
          ? (json['attribute_price'] as num).toDouble()
          : null,
      openingStock: json['opening_stock'],
      attributeStock: json['attribute_stock'],
    );
  }

  // Object ke JSON e convert kora
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attribute_name': attributeName,
      'attribute_price': attributePrice,
      'opening_stock': openingStock,
      'attribute_stock': attributeStock,
    };
  }
}