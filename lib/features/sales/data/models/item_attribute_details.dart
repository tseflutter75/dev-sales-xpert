
class ItemAttributeDetails {
  int? dtsid;
  String? attributeName;
  num? attributePrice;
  int? openingStock;
  int? attributeStock;

  ItemAttributeDetails({
    this.dtsid,
    this.attributeName,
    this.attributePrice,
    this.openingStock,
    this.attributeStock,
  });

  factory ItemAttributeDetails.fromJson(Map<String, dynamic> json) {
    return ItemAttributeDetails(
      dtsid: json['id'],
      attributeName: json['attribute_name'],
      attributePrice: json['attribute_price'],
      openingStock: json['opening_stock'],
      attributeStock: json['attribute_stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': dtsid,
      'attribute_name': attributeName,
      'attribute_price': attributePrice,
      'opening_stock': openingStock,
      'attribute_stock': attributeStock,
    };
  }
}