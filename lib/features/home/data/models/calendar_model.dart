class CalendarModel {
  // ===== summary / main fields =====
  final String? companyName;
  final String? calendarPeriod;
  final int? totalDays;

  // ===== entry fields (for each day) =====
  final String? date;
  final String? day;
  final bool? isWeekend;
  final String? leaveType;
  final String? remarks;
  final bool? isToday;

  // filter
  final int? year;
  final int? month;

  CalendarModel({
    // summary
    this.companyName,
    this.calendarPeriod,
    this.totalDays,

    // entry
    this.date,
    this.day,
    this.isWeekend,
    this.leaveType,
    this.remarks,
    this.isToday,

    // filter
    this.year,
    this.month,
  });

  /// 🔹 factory for summary object
  factory CalendarModel.fromSummaryJson(Map<String, dynamic> json) {
    return CalendarModel(
      companyName: json['company_name'],
      calendarPeriod: json['calendar_period'],
      totalDays: json['total_days'],
    );
  }

  /// 🔹 factory for single entry
  factory CalendarModel.fromEntryJson(Map<String, dynamic> json) {
    return CalendarModel(
      date: json['date'],
      day: json['day'],
      isWeekend: json['is_weekend'],
      leaveType: json['leave_type'],
      remarks: json['remarks'],
      isToday: json['is_today'],
    );
  }

  // filter
  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    return CalendarModel(year: json['year'], month: json['month']);
  }
}
