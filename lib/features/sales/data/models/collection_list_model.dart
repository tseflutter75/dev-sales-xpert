class CollectionModel {
  int? id;
  String? mrNo;
  String? collectionDate;
  String? partyName;
  String? companyName;
  String? collectionMode;
  int? collectionAmount;
  int? previousDueAmount;
  int? dueAmount;
  String? imagedoc;
  String? status;
  String? statusText;
  String? bankName;
  String? chequeNo;
  String? chequeDate;
  String? mobile;
  String? trxId;
  String? createdAt;

  CollectionModel({
    this.id,
    this.mrNo,
    this.collectionDate,
    this.partyName,
    this.companyName,
    this.collectionMode,
    this.collectionAmount,
    this.previousDueAmount,
    this.dueAmount,
    this.imagedoc,
    this.status,
    this.statusText,
    this.bankName,
    this.chequeNo,
    this.chequeDate,
    this.mobile,
    this.trxId,
    this.createdAt,
  });

  CollectionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    mrNo = json['mr_no'] ?? '';
    collectionDate = json['collection_date'] ?? '';
    partyName = json['party_name'] ?? '';
    companyName = json['company_name'] ?? '';
    collectionMode = json['collection_mode'] ?? '';
    collectionAmount = json['collection_amount'] ?? 0;
    previousDueAmount = json['previous_due_amount'] ?? 0;
    dueAmount = json['due_amount'] ?? '';
    imagedoc = json['attachment'] ?? '';
    status = json['status'].toString();
    statusText = json['status_text'] ?? '';
    bankName = json['bank_name'];
    chequeNo = json['cheque_no'];
    chequeDate = json['cheque_date'];
    mobile = json['mobile'];
    trxId = json['trx_id'];
    createdAt = json['created_at'];
  }
}
