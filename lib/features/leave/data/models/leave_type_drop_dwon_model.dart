class LeaveTypeModel {
  final int id;
  final String leaveType;
  final int totalLeaveDays;
  final int companyId;
  final String companyName;

  LeaveTypeModel({
    required this.id,
    required this.leaveType,
    required this.totalLeaveDays,
    required this.companyId,
     required this.companyName,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      id: json['id'],
      leaveType: json['leave_type'] ?? '',
      totalLeaveDays: json['total_leave_days'],
      companyId: json['company_id'],
      companyName: json['company_name'],
    );
  }
}