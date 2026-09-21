class SaleHistoryModel {
  int? id;
  String? orderNo;
  String? saleDate;
  String? partyName;
  String? companyName;
  num?
  totalAmount; // int বা double উভয়ই সাপোর্ট করার জন্য num ব্যবহার করা হয়েছে
  num? discount;
  num? grandTotal;
  num? collectionAmount;
  int? status;
  String? statusText;
  String? createdAt;
  String? createdByName;

  SaleHistoryModel({
    this.id,
    this.orderNo,
    this.saleDate,
    this.partyName,
    this.companyName,
    this.totalAmount,
    this.discount,
    this.grandTotal,
    this.collectionAmount,
    this.status,
    this.statusText,
    this.createdAt,
    this.createdByName,
  });

  // JSON থেকে ডাটা রিসিভ করার জন্য Factory Method
  factory SaleHistoryModel.fromJson(Map<String, dynamic> json) {
    return SaleHistoryModel(
      id: json['id'],
      orderNo: json['order_no'],
      saleDate: json['sale_date'],
      partyName: json['party_name'],
      companyName: json['company_name'],
      totalAmount: json['total_amount'],
      discount: json['discount'],
      grandTotal: json['grand_total'],
      collectionAmount: json['collection_amount'],
      status: json['status'],
      statusText: json['status_text'],
      createdAt: json['created_at'],
      createdByName: json['created_by_name'],
    );
  }
}
