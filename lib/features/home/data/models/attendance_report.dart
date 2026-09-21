class AttendanceReportModel {
  // ===== summary
  final String? employeeNameSummary;
  final int? empIdsummary;
  final String? period;
  final int? totalDays;
  final int? totalPresent;
  final int? totalAbsent;
  final int? totalLeave;
  final int? totalEmployees;

  // attendance data
  final String? date;
  final String? day;
  final String? employeeName;
  final String? empId;
  final String? department;
  final String? designation;
  final String? inTime;
  final String? outTime;
  final String? source;
  final String? status;
  final String? remarks;
  final int? lateMin;
  final int? earlyLeaveMin;

  // filter
  // final int? year;
  // final int? month;

  AttendanceReportModel({
    // summary
    this.employeeNameSummary,
    this.empIdsummary,
    this.period,
    this.totalDays,
    this.totalPresent,
    this.totalAbsent,
    this.totalLeave,
    this.totalEmployees,

    // attendance data
    this.date,
    this.day,
    this.employeeName,
    this.empId,
    this.department,
    this.designation,
    this.inTime,
    this.outTime,
    this.source,
    this.status,
    this.remarks,
    this.lateMin,
    this.earlyLeaveMin,

    // filter
    // this.year,
    // this.month,
  });

  /// 🔹 factory for summary object
  factory AttendanceReportModel.fromSummaryJson(Map<String, dynamic> json) {
    return AttendanceReportModel(
      employeeName: json['employee_name'] ?? '',
      empId: json['emp_id'].toString(),
      period: json['period'] ?? '',
      totalDays: json['total_days'] ?? 0,
      totalPresent: json['total_present'] ?? 0,
      totalAbsent: json['total_absent'] ?? 0,
      totalLeave: json['total_leave'] ?? 0,
      totalEmployees: json['total_employees'] ?? 0,
    );
  }

  /// 🔹 factory for single entry
  factory AttendanceReportModel.fromEntryJson(Map<String, dynamic> json) {
    return AttendanceReportModel(
      date: json['date'] ?? '',
      day: json['day'] ?? '',
      employeeName: json['employee_name'] ?? '',
      empId: json['emp_id']?.toString(), // int/string safe
      department: json['department'] ?? '',
      designation: json['designation'] ?? '',
      inTime: json['in_time'] ?? '',
      outTime: json['out_time'] ?? '',
      source: json['source'] ?? '',
      status: json['status'] ?? '',
      remarks: json['remarks'] ?? '',
      lateMin: json['late_min'] ?? 0,
      earlyLeaveMin: json['early_leave_min'] ?? 0,
    );
  }

  // filter
  // factory AttendanceReportModel.fromJson(Map<String, dynamic> json) {
  //   return AttendanceReportModel(year: json['year'], month: json['month']);
  // }
}
