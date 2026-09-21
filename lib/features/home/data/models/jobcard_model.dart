class JobCardModel {
  // ===== summary fields =====
  final String? employeeName;
  final int? empId;
  final String? month;
  final int? totalDays;
  final int? totalLate;
  final int? totalEarly;

  // ===== item fields =====
  final String? day;
  final String? date;
  final String? inTime;
  final String? outTime;
  final String? status;
  final String? source;
  final String? remarks;
  final int? lateMin;
  final int? earlyLeaveMin;

  JobCardModel({
    // summary
    this.employeeName,
    this.empId,
    this.month,
    this.totalDays,
    this.totalLate,
    this.totalEarly,

    // item
    this.day,
    this.date,
    this.inTime,
    this.outTime,
    this.status,
    this.source,
    this.remarks,
    this.lateMin,
    this.earlyLeaveMin,
  });

  /// single factory for both summary & item
  factory JobCardModel.fromJson(Map<String, dynamic> json) {
    return JobCardModel(
      // summary fields
      employeeName: json.containsKey('employee_name') ? json['employee_name'] : null,
      empId: json.containsKey('emp_id') ? json['emp_id'] : null,
      month: json.containsKey('month') ? json['month'] : null,
      totalDays: json.containsKey('total_days') ? json['total_days'] : null,
      totalLate: json.containsKey('total_late') ? json['total_late'] : null,
      totalEarly: json.containsKey('total_early') ? json['total_early'] : null,

      // item fields
      day: json.containsKey('day') ? json['day'] : null,
      date: json.containsKey('date') ? json['date'] : null,
      inTime: json.containsKey('in_time') ? json['in_time'] : null,
      outTime: json.containsKey('out_time') ? json['out_time'] : null,
      status: json.containsKey('status') ? json['status'] : null,
      source: json.containsKey('source') ? json['source'] : null,
      remarks: json.containsKey('remarks') ? json['remarks'] : null,
      lateMin: json.containsKey('late_min') ? json['late_min'] : null,
      earlyLeaveMin: json.containsKey('early_leave_min') ? json['early_leave_min'] : null,
    );
  }
}
