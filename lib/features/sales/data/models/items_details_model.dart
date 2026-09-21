

class ItemDetailsModel {
  int? id;
  String? itemName;
  String? itemCode;
  double? openingQuantity;
  double? stock;
  double? price;
  int? companyId;
  String? companyName;
  int? brandId;
  String? brandName;
  int? groupId;
  String? groupName;
  int? subGroupId;
  String? subGroupName;
  int? thicknessId;
  String? thicknessName;
  int? uomId;
  String? uomName;
  int? hasAttribute;

  ItemDetailsModel({
    this.id,
    this.itemName,
    this.itemCode,
    this.openingQuantity,
    this.stock,
    this.price,
    this.companyId,
    this.companyName,
    this.brandId,
    this.brandName,
    this.groupId,
    this.groupName,
    this.subGroupId,
    this.subGroupName,
    this.thicknessId,
    this.thicknessName,
    this.uomId,
    this.uomName,
    this.hasAttribute,
  });

  /// ✅ factory constructor
  factory ItemDetailsModel.fromJson(Map<String, dynamic> json) {
    return ItemDetailsModel(
      id: json['id'],
      itemName: json['item_name'],
      itemCode: json['item_code'],
      openingQuantity: (json['opening_quantity'] ?? 0).toDouble(),
      stock: (json['stock'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      companyId: json['company_id'],
      companyName: json['company_name'],
      brandId: json['brand_id'],
      brandName: json['brand_name'],
      groupId: json['group_id'],
      groupName: json['group_name'],
      subGroupId: json['sub_group_id'],
      subGroupName: json['sub_group_name'],
      thicknessId: json['thickness_id'],
      thicknessName: json['thickness_name'],
      uomId: json['uom_id'],
      uomName: json['uom_name'],
      hasAttribute: json['has_attribute'],
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_name': itemName,
      'item_code': itemCode,
      'opening_quantity': openingQuantity,
      'stock': stock,
      'price': price,
      'company_id': companyId,
      'company_name': companyName,
      'brand_id': brandId,
      'brand_name': brandName,
      'group_id': groupId,
      'group_name': groupName,
      'sub_group_id': subGroupId,
      'sub_group_name': subGroupName,
      'thickness_id': thicknessId,
      'thickness_name': thicknessName,
      'uom_id': uomId,
      'uom_name': uomName,
      'has_attribute': hasAttribute,
    };
  }
}