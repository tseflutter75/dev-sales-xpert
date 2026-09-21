class PendingModel {
  int? id;
  String? orderNo;
  String? saleDate;
  String? receiveDate;
  String? deliveryAddress;
  String? remarks;
  int? paymentType;
  String? paymentTypeText;
  int? totalDays;
  String? partyName;
  String? companyName;
  double? totalAmount;
  double? discount;
  double? grandTotal;
  num? grossDiscount;
  double? collectionAmount;
  String? collectionMood;
  int? status;
  String? statusText;
  String? createdAt;
  String? createdByName;
  String? bankName;
  String? chequeNo;
  String? chequeDate;
  String? trxId;
  String? mobile;
  String? accName;

  PendingModel({
    this.id,
    this.orderNo,
    this.saleDate,
    this.receiveDate,
    this.deliveryAddress,
    this.remarks,
    this.paymentType,
    this.paymentTypeText,
    this.totalDays,
    this.partyName,
    this.companyName,
    this.totalAmount,
    this.discount,
    this.grandTotal,
    this.grossDiscount,
    this.collectionAmount,
    this.collectionMood,
    this.status,
    this.statusText,
    this.createdAt,
    this.createdByName,
    this.bankName,
    this.chequeNo,
    this.chequeDate,
    this.trxId,
    this.mobile,
    this.accName,
  });

  factory PendingModel.fromJson(Map<String, dynamic> json) {
    return PendingModel(
      id: json['id'] ?? 0,
      orderNo: json['order_no'] ?? "",
      saleDate: json['sale_date'] ?? "",
      receiveDate: json['receive_date'] ?? "",
      deliveryAddress: json['delivery_address'],
      remarks: json['remarks'],
      paymentType: json['payment_type'],
      paymentTypeText: json['payment_type_text'],
      totalDays: json['total_days'],

      partyName: json['party_name'] ?? "",
      companyName: json['company_name'] ?? "",
      totalAmount: json['total_amount'] != null
          ? (json['total_amount'] as num).toDouble()
          : null,
      discount: json['discount'] != null
          ? (json['discount'] as num).toDouble()
          : null,
      grandTotal: json['grand_total'] != null
          ? (json['grand_total'] as num).toDouble()
          : null,
      collectionAmount: json['collection_amount'] != null
          ? (json['collection_amount'] as num).toDouble()
          : null,
      status: json['status'] ?? 0,
      statusText: json['status_text'] ?? "",
      createdAt: json['created_at'] ?? "",
      createdByName: json['created_by_name'] ?? "",
      grossDiscount: json['gross_discount'] ?? 0,
      collectionMood: json['collection_mode'] ?? "",
      bankName: json['bank_name'] ?? "",
      chequeNo: json['cheque_no'] ?? "",
      chequeDate: json['cheque_date'] ?? "",
      trxId: json['trx_id'] ?? "",
      mobile: json['mobile'] ?? "",
      accName: json['acc_name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_no': orderNo,
      'sale_date': saleDate,
      'party_name': partyName,
      'company_name': companyName,
      'total_amount': totalAmount,
      'discount': discount,
      'grand_total': grandTotal,
      'collection_amount': collectionAmount,
      'status': status,
      'status_text': statusText,
      'created_at': createdAt,
      'created_by_name': createdByName,
    };
  }
}
