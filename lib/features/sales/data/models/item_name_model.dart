class ItemNameModel {
  final int? id;
  final String? itemName;
  final String? itemCode;
  final String? compaNyName;
  final String? brandName;
  final String? thicknessName;
  final String? groupName;
  final String? subGroupName;
  final int? status;

  ItemNameModel({
    this.id,
    this.itemName,
    this.itemCode,
    this.compaNyName,
    this.brandName,
    this.thicknessName,
    this.groupName,
    this.subGroupName,
    this.status,
  });

  factory ItemNameModel.fromJson(Map<String, dynamic> json) {
    return ItemNameModel(
      id: json['id'] ?? 0,
      itemName: json['item_name'] ?? "",
      itemCode: json['item_code'] ?? "",
      compaNyName: json['company_name'] ?? "",
      brandName: json['brand_name'] ?? "",
      thicknessName: json['thickness_name'] ?? "",
      groupName: json['group_name'] ?? "",
      subGroupName: json['sub_group_name'] ?? "",
      status: json['status'] ?? 0,
    );
  }
}
