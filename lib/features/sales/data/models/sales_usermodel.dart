class SalesItemModel {
  // sale feilds
  final int? id;
  final String? memoNo;
  final int? companyId;
  final String? companyName;
  final int? employeeId;
  final String? employeeName;
  final int? partyId;
  final String? partyName;
  final String? deliveryAddress;
  final String? saleDate;
  final String? receiveDate;
  final String? chequeDate;
  final int? paymentType;
  final String? paymentTypeText;
  final String? collectionMode;
  final num? credit;
  final num? grossTotal;
  final num? grossDiscount;
  final num? grossDiscountAmount;
  final num? netTotal;
  final num? collectionAmount;
  final num? dueAmount;
  final String? bankName;
  final String? accNo;
  final String? accName;
  final String? branchName;
  final String? chequeNo;
  final String? trxId;
  final String? remarks;
  final int? status;
  final String? statusText;
  final String? createdAt;
  final String? updatedAt;
  final int? createdBy;
  final int? updatedBy;

  // item feilds

  final int? Iid;
  final int? itemId;
  final int? attributeId;
  final String? attributeName;
  final int? groupId;
  final String? groupName;
  final String? itemName;
  final String? itemCode;
  final String? uom;
  final num? quantity;
  final num? itemRate;
  final num? totalAmount;
  final String? itemcreatedAt;

  SalesItemModel({
    this.id,
    this.memoNo,
    this.companyId,
    this.companyName,
    this.employeeId,
    this.employeeName,
    this.partyId,
    this.partyName,
    this.deliveryAddress,
    this.saleDate,
    this.receiveDate,
    this.chequeDate,
    this.paymentType,
    this.paymentTypeText,
    this.collectionMode,
    this.credit,
    this.grossTotal,
    this.grossDiscount,
    this.grossDiscountAmount,
    this.netTotal,
    this.collectionAmount,
    this.dueAmount,
    this.bankName,
    this.accNo,
    this.accName,
    this.branchName,
    this.chequeNo,
    this.trxId,
    this.remarks,
    this.status,
    this.statusText,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.Iid,
    this.itemId,
    this.attributeId,
    this.attributeName,
    this.groupId,
    this.groupName,
    this.itemName,
    this.itemCode,
    this.uom,
    this.quantity,
    this.itemRate,
    this.totalAmount,
    this.itemcreatedAt,
  });

  factory SalesItemModel.fromSaleJson(Map<String, dynamic> json) {
    return SalesItemModel(
      // sales
      id: json['id'] ?? 0,
      memoNo: json['memo_no'] ?? "",
      companyId: json['company_id'] ?? 0,
      companyName: json['company_name'] ?? "",
      employeeId: json['employee_id'] ?? 0,
      employeeName: json['employee_name'] ?? "",
      partyId: json['party_id'] ?? 0,
      partyName: json['party_name'] ?? "",
      deliveryAddress: json['delivery_address'] ?? "",
      saleDate: json['sale_date'] ?? "",
      receiveDate: json['receive_date'] ?? "",
      chequeDate: json['cheque_date'] ?? "",
      paymentType: json['payment_type'] ?? 0,
      paymentTypeText: json['payment_type_text'] ?? "",
      collectionMode: json['collection_mode'] ?? "",
      credit: json['credit'] ?? 0,
      grossTotal: json['gross_total'] ?? 0,
      grossDiscount: json['gross_discount'] ?? 0,
      grossDiscountAmount: json['gross_discount_amount'] ?? 0,
      netTotal: json['net_total'] ?? 0,
      collectionAmount: json['collection_amount'] ?? 0,
      dueAmount: json['due_amount'] ?? 0,
      bankName: json['bank_name'] ?? "",
      accNo: json['acc_no'] ?? "",
      accName: json['acc_name'] ?? "",
      branchName: json['branch_name'] ?? "",
      chequeNo: json['cheque_no'] ?? "",
      trxId: json['trx_id'] ?? "",
      remarks: json['remarks'] ?? "",
      status: json['status'] ?? 0,
      statusText: json['status_text'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      createdBy: json['created_by'] ?? 0,
      updatedBy: json['updated_by'] ?? 0,
    );
  }

  factory SalesItemModel.fromItemJson(Map<String, dynamic> json) {
    return SalesItemModel(
      // items
      Iid: json['id'] ?? 0,
      itemId: json['item_id'] ?? 0,
      attributeId: json['attribute_id'] ?? 0,
      attributeName: json['attribute_name'] ?? "",
      groupId: json['group_id'] ?? 0,
      groupName: json['group_name'] ?? "",
      itemName: json['item_name'] ?? "",
      itemCode: json['item_code'] ?? "",
      uom: json['uom'] ?? "",
      quantity: json['quantity'] ?? 0,
      itemRate: json['item_rate'] ?? 0,
      totalAmount: json['total_amount'] ?? 0,
      itemcreatedAt: json['created_at'] ?? "",
    );
  }
}