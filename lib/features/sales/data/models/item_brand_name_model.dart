class ItemBrandNameModel {
  final int? id;
  final String? BrandName;


  ItemBrandNameModel({
    this.id,
    this.BrandName,
 
  });

  factory ItemBrandNameModel.fromJson(Map<String, dynamic> json) {
    return ItemBrandNameModel(
      id: json['id'] ?? 0,
      BrandName: json['brand_name'] ?? "",
     
    );
  }
}