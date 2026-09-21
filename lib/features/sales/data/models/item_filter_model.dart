// class ItemFilterModel {
//   final int? id;
//   final String? itemName;
//   final String? itemCode;
//   final String? totalLength;
//   final int? subGroupId; // Nullable
//   final int? groupId;
//   final int? brandId;

//   // Constructor
//   ItemFilterModel({
//     this.id,
//     this.itemName,
//     this.itemCode,
//     this.totalLength,
//     this.subGroupId,
//     this.groupId,
//     this.brandId,
//   });

//   // JSON থেকে Object বানানোর factory
//   factory ItemFilterModel.fromJson(Map<String, dynamic> json) {
//     return ItemFilterModel(
//       id: json['id'] ?? 0,
//       itemName: json['item_name'] ?? '',
//       itemCode: json['item_code'] ?? '',
//       totalLength: json['total_length'] ?? '',
//       subGroupId: json['sub_group_id'] != null
//           ? int.tryParse(json['sub_group_id'].toString())
//           : null,
//       groupId: json['group_id'] != null
//           ? int.tryParse(json['group_id'].toString()) ?? 0
//           : 0,
//       brandId: json['brand_id'] != null
//           ? int.tryParse(json['brand_id'].toString()) ?? 0
//           : 0,
//     );
//   }
// }

class ItemFilterModel {
  final int? id;
  final String? itemName;
  final String? itemCode;
  final String? totalLength;
  final int? subGroupId;
  final int? groupId;
  final int? brandId;

  ItemFilterModel({
    this.id,
    this.itemName,
    this.itemCode,
    this.totalLength,
    this.subGroupId,
    this.groupId,
    this.brandId,
  });

  factory ItemFilterModel.fromJson(Map<String, dynamic> json) {
    // ডাটা টাইপ সেফলি পার্স করার জন্য একটি ছোট হেল্পার লজিক
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      return int.tryParse(value.toString());
    }

    return ItemFilterModel(
      id: parseInt(json['id']),
      // item_name null হলে খালি স্ট্রিং বা item_code দেখাবে
      itemName: json['item_name']?.toString() ?? '',
      itemCode: json['item_code']?.toString() ?? '',
      totalLength: json['total_length']?.toString() ?? '',
      subGroupId: parseInt(json['sub_group_id']),
      groupId: parseInt(json['group_id']),
      brandId: parseInt(json['brand_id']),
    );
  }
}
