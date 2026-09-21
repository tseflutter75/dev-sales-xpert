class NoticesModel {
  int? id;
  String? publishDate;
  String? expireDate;
  String? title;
  String? description;
  String? attachment;

  NoticesModel({
    this.id,
    this.publishDate,
    this.expireDate,
    this.title,
    this.description,
    this.attachment,
  });

  factory NoticesModel.fromJson(Map<String, dynamic> json) => NoticesModel(
    id: json["id"],
    publishDate: json["publish_date"],
    expireDate: json["expire_date"],
    title: json["title"],
    description: json["description"],
    attachment: json["attachment"],
  );
}
