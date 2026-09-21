class ClientTypeModel {
  final int? clientid;
  final String? name;
  final String? ownerName;
  final String? mobileNo;
  final String? emailAddress;
  final int? companyId;
  final String? companyName;

  ClientTypeModel({
    this.clientid,
    this.name,
    this.ownerName,
    this.mobileNo,
    this.emailAddress,
    this.companyId,
    this.companyName,
  });

  factory ClientTypeModel.fromJson(Map<String, dynamic> json) {
    return ClientTypeModel(
      clientid: json['id'],
      name: json['name'] ?? '',
      ownerName: json['owner_name'] ?? '', 
      mobileNo: json['mobile_no'] ?? '',
      emailAddress: json['email_address'] ?? '', 
      companyId: json['company_id'] ?? 0,
      companyName: json['company_name'] ?? '',
    );
  }
}
