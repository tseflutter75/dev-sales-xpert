class CustomerDetails {
  int? id;
  int? companyId;
  String? companyName;
  int? empId;
  String? employeeName;
  String? partyName;
  String? presentAddress;
  String? mobileNo;
  String? emailAddress;
  String? openingBalanceType;
  int? openingBalance;
  int? discount;
  String? openingDate;
  String? isApprove;
  int? status;
  String? statusText;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;

  CustomerDetails({
    this.id,
    this.companyId,
    this.companyName,
    this.empId,
    this.employeeName,
    this.partyName,
    this.presentAddress,
    this.mobileNo,
    this.emailAddress,
    this.openingBalanceType,
    this.openingBalance,
    this.discount,
    this.openingDate,
    this.isApprove,
    this.status,
    this.statusText,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    empId = json['emp_id'];
    employeeName = json['employee_name'];
    partyName = json['party_name'];
    presentAddress = json['present_address'];
    mobileNo = json['mobile_no'];
    emailAddress = json['email_address'];
    openingBalanceType = json['opening_balance_type'];
    openingBalance = json['opening_balance'];
    discount = json['discount'];
    openingDate = json['opening_date'];
    isApprove = json['is_approve'];
    status = json['status'];
    statusText = json['status_text'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['company_id'] = companyId;
    data['company_name'] = companyName;
    data['emp_id'] = empId;
    data['employee_name'] = employeeName;
    data['party_name'] = partyName;
    data['present_address'] = presentAddress;
    data['mobile_no'] = mobileNo;
    data['email_address'] = emailAddress;
    data['opening_balance_type'] = openingBalanceType;
    data['opening_balance'] = openingBalance;
    data['discount'] = discount;
    data['opening_date'] = openingDate;
    data['is_approve'] = isApprove;
    data['status'] = status;
    data['status_text'] = statusText;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    return data;
  }
}