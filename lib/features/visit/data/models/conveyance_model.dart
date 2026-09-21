class ConveyanceModel {
  final int? conveyanceId;
  final String? companyName;
  final String? employeeName;
  final String? visitType;
  final String? visitDate;
  final String? clientName;
  final String? visitFrom;
  final String? visitTo;
  final String? entryType;
  final String? vehicleType;
  final double? originalAmount;
  final double? approvedAmount;
  final String? billstatus;
  final int? paymentStatus;

  final String? createdAt;
  final String? remarks;

  ConveyanceModel({
    this.conveyanceId,
    this.companyName,
    this.employeeName,
    this.visitType,
    this.visitDate,
    this.clientName,
    this.visitFrom,
    this.visitTo,
    this.entryType,
    this.vehicleType,
    this.originalAmount,
    this.approvedAmount,
    this.billstatus,
    this.paymentStatus,

    this.createdAt,
    this.remarks,
  });

  factory ConveyanceModel.fromJson(Map<String, dynamic> json) {
    return ConveyanceModel(
      conveyanceId: json['conveyance_id'],
      companyName: json['company_name'],
      employeeName: json['employee_name'],
      visitType: json['visit_type'],
      visitDate: json['visit_date'],
      clientName: json['client_name'],
      visitFrom: json['visit_from'],
      visitTo: json['visit_to'],
      entryType: json['entry_type'],
      vehicleType: json['vehicle_type'],
      originalAmount: (json['original_amount'] as num?)?.toDouble(),
      approvedAmount: (json['approved_amount'] as num?)?.toDouble(),
      paymentStatus: json['payment_status'],
      billstatus: json['bill_status'],

      createdAt: json['created_at'],
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conveyance_id': conveyanceId,
      'company_name': companyName,
      'employee_name': employeeName,
      'visit_type': visitType,
      'visit_date': visitDate,
      'client_name': clientName,
      'visit_from': visitFrom,
      'visit_to': visitTo,
      'entry_type': entryType,
      'vehicle_type': vehicleType,
      'original_amount': originalAmount,
      'approved_amount': approvedAmount,
      'bill_status': billstatus,
      'payment_status': paymentStatus,

      'created_at': createdAt,
      'remarks': remarks,
    };
  }
}
