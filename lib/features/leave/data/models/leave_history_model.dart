class LeaveHistoryModel {
  final int id;
  final String companyName;
  final String employeeName;
  final String employeeId;
  final String leavetype;
  final String dateRange;
  final int totalDays;
  final int status;
  final String StatusText;
  final String appliedAt;
  final String reason;
  final String imagedoc;

  LeaveHistoryModel({
    required this.id,
    required this.companyName,
    required this.employeeName,
    required this.employeeId,
    required this.leavetype,
    required this.dateRange,
    required this.totalDays,
    required this.status,
    required this.StatusText,
    required this.appliedAt,
    required this.reason,
    required this.imagedoc,
  });

  factory LeaveHistoryModel.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryModel(
      id: json['id'],
      companyName: json['company_name'] ?? '',
      employeeName: json['employee_name'] ?? '',
      employeeId: json['employee_id'] ?? '',
      leavetype: json['leave_type'],
      dateRange: json['date_range'],
      totalDays: json['total_days'],
      status: json['status'],
      StatusText: json['status_text'],
      appliedAt: json['applied_at'],
      reason: json['reason'] ?? '',
      imagedoc: json['leave_document'] ?? '',
    );
  }
}
