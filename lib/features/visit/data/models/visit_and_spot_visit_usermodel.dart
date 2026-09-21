class VisitSpotModel {
  // ================= VISIT (summary fields) =================
  int? id;
  int? companyId;
  String? companyName;
  int? employeeId;
  String? employeeName;
  int? clientId;
  String? clientName;
  String? visitType;
  String? visitTypeText; 
  int? visitPurposeId;
  String? visitPurpose;

  String? visitDate;
  String? visitEndDate;

  String? formattedVisitDate; 
  String? visitStartTime;
  String? visitEndTime;
  String? visitFrom;
  String? visitTo;
  String? status;
  String? statusText; 
  String? contactPerson;
  String? contactPersonMobile;
  String? remarks;

  String? actualVisitStartDate;
  String? actualVisitReachedDate;
  String? actualVisitEndDate;

  // নতুন
  String? actualVisitStartTime;
  String? actualVisitFrom;
  String? visitReachTime;
  String? actualVisitEndTime;

  String? startLatitude;
  String? startLongitude;
  String? startAddress;
  String? startImage; 

  String? reachLatitude;
  String? reachLongitude;
  String? reachAddress;
  String? reachImage; 

  String? endLatitude;
  String? endLongitude;
  String? endAddress;
  String? endImage; 

  String? vehicleType;
  String? vehicleTypeId;
  String? vehicleBill;
  String? billReceipt; 

  // ================= SPOT (entry fields) =================
  int? spotId;
  int? spotClientId;
  String? spotClientName;
  String? spotContactPerson;
  String? spotContactPersonMobile;
  String? spotVisitTo;
  String? spotVisitPurposeID;
  String? spotVisitPurpose;
  String? spotStartLatitude; 
  String? spotStartLongitude; 
  String? spotEndLatitude;
  String? spotEndLongitude;
  String? spotEndAddress;
  String? spotVehicleTypeID;
  String? spotVehicleType;
  String? spotVehicleBill;
  String? spotImage;
  String? spotBillReceipt;
  String? spotVisitStartTime;
  String? spotVisitEndTime;
  String? spotCreatedAt;
  String? spotremarks;

  VisitSpotModel({
    this.id,
    this.companyId,
    this.companyName,
    this.employeeId,
    this.employeeName,
    this.clientId,
    this.clientName,
    this.visitType,
    this.visitTypeText,
    this.visitPurpose,
    this.visitPurposeId,
    this.visitDate,
    this.visitEndDate,
    this.formattedVisitDate,
    this.visitStartTime,
    this.visitEndTime,
    this.visitFrom,
    this.visitTo,
    this.status,
    this.statusText,
    this.actualVisitStartDate,
    this.actualVisitReachedDate,
    this.actualVisitEndDate,
    this.actualVisitStartTime,
    this.actualVisitFrom,
    this.visitReachTime,
    this.actualVisitEndTime,
    this.startLatitude,
    this.startLongitude,
    this.startAddress,
    this.startImage,
    this.reachLatitude,
    this.reachLongitude,
    this.reachAddress,
    this.reachImage,
    this.endLatitude,
    this.endLongitude,
    this.endAddress,
    this.endImage,
    this.vehicleType,
    this.vehicleTypeId,
    this.vehicleBill,
    this.billReceipt,
    this.contactPerson,
    this.contactPersonMobile,
    this.remarks,

    // spot
    this.spotId,
    this.spotClientId,
    this.spotClientName,
    this.spotContactPerson,
    this.spotContactPersonMobile,
    this.spotVisitTo,
    this.spotVisitPurpose,
    this.spotVisitPurposeID,
    this.spotStartLatitude,
    this.spotStartLongitude,
    this.spotEndLatitude,
    this.spotEndLongitude,
    this.spotEndAddress,
    this.spotVehicleTypeID,
    this.spotVehicleType,
    this.spotVehicleBill,
    this.spotImage,
    this.spotBillReceipt,
    this.spotVisitStartTime,
    this.spotVisitEndTime,
    this.spotCreatedAt,
    this.spotremarks,
  });

  factory VisitSpotModel.fromVisitJson(Map<String, dynamic> json) {
    return VisitSpotModel(
      id: json['id'] ?? json['visit_id'] ?? 0,
      companyId: json['company_id'],
      companyName: json['company_name'],
      employeeId: json['employee_id'],
      employeeName: json['employee_name'],

      clientId: json['client_id'], /////////////////////
      clientName: json['client_name'],
      visitType: json['visit_type']?.toString(),
      visitTypeText: json['visit_type_text'],

      visitPurposeId: json['visit_purpose_id'], ////////////////
      visitPurpose: json['visit_purpose'],
      visitDate: json['visit_date'],
      visitEndDate: json['visit_end_date'],

      formattedVisitDate: json['formatted_visit_date'],
      visitStartTime: json['visit_start_time'],
      visitEndTime: json['visit_end_time'],
      visitFrom: json['visit_from'],
      visitTo: json['visit_to'],
      status: json['status']?.toString(),
      statusText: json['status_text'],

      actualVisitStartDate: json['actual_visit_date'],
      actualVisitReachedDate: json['reached_date'],
      actualVisitEndDate: json['actual_visit_end_date'],

      actualVisitStartTime: json['actual_visit_start_time'],
      actualVisitFrom: json['actual_visit_from'],
      visitReachTime: json['visit_reach_time'],
      actualVisitEndTime: json['actual_visit_end_time'],
      startLatitude: json['start_latitude'],
      startLongitude: json['start_longitude'],
      startAddress: json['start_address'],
      startImage: json['start_image'],
      reachLatitude: json['reach_latitude'],
      reachLongitude: json['reach_longitude'],
      reachAddress: json['reach_address'],
      reachImage: json['reach_image'],
      endLatitude: json['end_latitude'],
      endLongitude: json['end_longitude'],
      endAddress: json['end_address'],
      endImage: json['end_image'],
      vehicleType: json['vehicle_type'],
      vehicleTypeId: json['vehicle_id']?.toString(),
      vehicleBill: json['vehicle_bill']?.toString(),
      billReceipt: json['bill_receipt'],
      contactPerson: json['contact_person'] ?? '',
      contactPersonMobile: json['contact_person_mobile'] ?? '',
      remarks: json['remarks'],
    );
  }

  factory VisitSpotModel.fromSpotJson(Map<String, dynamic> json) {
    return VisitSpotModel(
      spotId: json['id'] ?? 0,
      spotClientId: json['client_id'] ?? 0,
      spotClientName: json['client_name'] ?? '',
      spotContactPerson: json['contact_person'] ?? '',
      spotContactPersonMobile: json['contact_person_mobile'] ?? '',
      spotVisitTo: json['visit_to'] ?? '',
      spotVisitPurposeID: json['visit_purpose_id']?.toString(),
      spotVisitPurpose: json['visit_purpose'] ?? '',
      spotStartLatitude: json['start_latitude']?.toString() ?? '',
      spotStartLongitude: json['start_longitude']?.toString() ?? '',
      spotEndLatitude: json['end_latitude']?.toString() ?? '',
      spotEndLongitude: json['end_longitude']?.toString() ?? '',
      spotEndAddress: json['end_address'] ?? '',
      spotVehicleTypeID: json['vehicle_id']?.toString(),
      spotVehicleType: json['vehicle_type'] ?? '',
      spotVehicleBill: json['vehicle_bill']?.toString() ?? '',
      spotImage: json['image'] ?? '',
      spotBillReceipt: json['bill_receipt'] ?? '',
      spotVisitStartTime: json['visit_start_time'] ?? '',
      spotVisitEndTime: json['visit_end_time'] ?? '',
      spotCreatedAt: json['created_at'] ?? '',
      spotremarks: json['remarks'] ?? '',
    );
  }
}
