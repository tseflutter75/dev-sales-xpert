class PhoneBookModel {
  final int id;
  final String employeename;
  final String designation;
  final String department;
  final String mobile;
  final String? whatsapp;
  final String email;
  final String image;
  final int companyId;
  final String companyname;

  PhoneBookModel({
    required this.id,
    required this.employeename,
    required this.designation,
    required this.department,
    required this.mobile,
    this.whatsapp,
    required this.email,
    required this.image,
    required this.companyId,
    required this.companyname,
  });

  factory PhoneBookModel.fromJson(Map<String, dynamic> json) {
    return PhoneBookModel(
      id: json['id'] ?? 0,
      employeename: json['emp_name'] ?? '',
      designation: json['designation'] ?? '',
      department: json['department'] ?? '',
      mobile: json['mobile'] ?? '',
      whatsapp: json['whatsapp'],
      email: json['email'] ?? '',
      // মডেলের Factory মেথডে এভাবে চেক করুন
      image: json['image'] != null
          ? json['image'].toString().replaceAll(
              "storageimages",
              "storage/images",
            )
          : '',
      companyId: json['company_id'] ?? 0,
      companyname: json['company_name'] ?? '',
    );
  }
}
