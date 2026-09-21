class EmployeeModel {
  final int id;
  final String employeename;
  final String department;
  final String designation;
  final int businessUnit;
  final String businessUnitname ;

  EmployeeModel({
    required this.id,
    required this.employeename,
    required this.department,
    required this.designation,
    required this.businessUnit,
    required this.businessUnitname,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      employeename: json['emp_name'] ?? '',
      department: json['department'] ?? '',
      designation: json['designation'] ?? '',
      businessUnit: json['company_id'] ?? 0,
       businessUnitname: json['company_name'] ?? '',
    );
  }
}
