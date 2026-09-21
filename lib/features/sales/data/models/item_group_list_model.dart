class ItemGroupListModel {
  final int? id;
  final String? groupName;

  ItemGroupListModel({
    this.id,
    this.groupName,
 
  });

  factory ItemGroupListModel.fromJson(Map<String, dynamic> json) {
    return ItemGroupListModel(
      id: json['id'] ?? 0,
      groupName: json['group_name'] ?? "",
     
    );
  }
}