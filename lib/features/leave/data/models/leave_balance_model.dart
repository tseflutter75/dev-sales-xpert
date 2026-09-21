class LeaveBalance {
  final int leaveTypeId;
  final String leaveType;
  final int allotment;
  final int taken;
  final int remaining;

  LeaveBalance({
    required this.leaveTypeId,
    required this.leaveType,
    required this.allotment,
    required this.taken,
    required this.remaining,
  });

  factory LeaveBalance.fromJson(Map<String, dynamic> json) {
    return LeaveBalance(
      leaveTypeId: json['leave_type_id'],
      leaveType: json['leave_type'] ,
      allotment: json['allotment'],
      taken: json['taken'],
      remaining: json['remaining'],
    );
  }
}