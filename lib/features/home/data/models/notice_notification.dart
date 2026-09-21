class NoticeNotificationModel {
  final int validNotificationsCount;
  final String asOfDate;
  final String message;
  final List<dynamic> filters;

  NoticeNotificationModel({
    required this.validNotificationsCount,
    required this.asOfDate,
    required this.message,
    required this.filters,
  });

  factory NoticeNotificationModel.fromJson(Map<String, dynamic> json) {
    return NoticeNotificationModel(
      validNotificationsCount: json['valid_notifications_count'] ?? 0,
      asOfDate: json['as_of_date'] ?? '',
      message: json['message'] ?? '',
      filters: json['filters'] ?? [],
    );
  }
}
