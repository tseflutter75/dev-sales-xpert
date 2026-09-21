class TranspotTyepDropDwonModel {
  final int transpotid;
  final String vehicleType;

  TranspotTyepDropDwonModel({
    required this.transpotid,
    required this.vehicleType,
  });

  factory TranspotTyepDropDwonModel.fromJson(Map<String, dynamic> json) {
    return TranspotTyepDropDwonModel(
      transpotid: json['id'] ?? 0,
      vehicleType: json['vehicle_type'] ?? '',
    );
  }
}