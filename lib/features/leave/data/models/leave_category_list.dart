class LeaveCategory {
  final int id;
  final String leaveType;
  final int leaveCategoryId;
  final int year;
  final int totalLeaveDays;
  final int companyId;
  final String companyName;

  LeaveCategory({
    required this.id,
    required this.leaveType,
    required this.leaveCategoryId,
    required this.year,
    required this.totalLeaveDays,
    required this.companyId,
    required this.companyName,
  });

  factory LeaveCategory.fromJson(Map<String, dynamic> json) {
    return LeaveCategory(
      id: json['id'] ?? 0,
      leaveType: json['leave_type'] ?? '',
      leaveCategoryId: json['leave_category_id'] ?? 0,
      year: json['year'] ?? 0,
      totalLeaveDays: json['total_leave_days'] ?? 0,
      companyId: json['company_id'] ?? 0,
      companyName: json['company_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leave_type': leaveType,
      'leave_category_id':leaveCategoryId,
      'year': year,
      'total_leave_days': totalLeaveDays,
      'company_id': companyId,
      'company_name': companyName,
    };
  }
}
