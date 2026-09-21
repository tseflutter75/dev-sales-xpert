class PurposeModel {
  int? id;
  String? visitPurpose;
  int? companyId;
  String? companyName;

  PurposeModel({this.id, this.visitPurpose, this.companyId, this.companyName});

  factory PurposeModel.fromJson(Map<String, dynamic> json) {
    return PurposeModel(
      id: json['id'] ?? 0,
      visitPurpose: json['visit_purpose'] ?? '',
      companyId: json['company_id'] ?? 0,
      companyName: json['company_name'] ?? '',
    );
  }
}