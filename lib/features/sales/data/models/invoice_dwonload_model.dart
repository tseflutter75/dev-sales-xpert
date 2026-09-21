class SalesItemDwonloadModel {
  int? id;
  String? attachment;

  SalesItemDwonloadModel({this.id, this.attachment});

  factory SalesItemDwonloadModel.fromJson(Map<String, dynamic> json) {
    return SalesItemDwonloadModel(
      id: json['id'] ?? 0,
      attachment: json['attachment'] ?? "",
    );
  }
}
