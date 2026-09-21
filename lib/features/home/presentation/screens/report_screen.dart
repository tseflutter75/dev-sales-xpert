import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/home/data/models/attendance_report.dart';

class ReportScreen extends StatefulWidget {
  final int fromTabIndex;
  const ReportScreen({super.key, this.fromTabIndex = 0});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _fromdateController = TextEditingController();
  final TextEditingController _todateController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  bool inprogresssreport = false;
  final List<AttendanceReportModel> _reportList = [];
  AttendanceReportModel? summary;

  @override
  void initState() {
    super.initState();
    _getAttendanceList();
  }

  /// ডাইনামিক ইউআরএল বিল্ডার যা টেক্সট ফিল্ডের ভ্যালু অনুযায়ী কুইরি প্যারামস তৈরি করবে
  String _buildUrl() {
    String baseUrl = Urls.attendanceReportUrl;
    Map<String, String> queryParams = {};

    // ইউজারের ইনপুট থাকলে তা ম্যাপে যোগ হবে
    if (_fromdateController.text.isNotEmpty) {
      queryParams['from_date'] = _fromdateController.text;
    }
    if (_todateController.text.isNotEmpty) {
      queryParams['to_date'] = _todateController.text;
    }
    if (_departmentController.text.isNotEmpty) {
      queryParams['dept_id'] = _departmentController.text;
    }
    if (_statusController.text.isNotEmpty) {
      queryParams['status'] = _statusController.text;
    }

    // যদি কোনো প্যারামিটার থাকে তবে তা URL-এর সাথে যুক্ত হবে
    if (queryParams.isNotEmpty) {
      String queryString = Uri(queryParameters: queryParams).query;
      return "$baseUrl?$queryString";
    }

    return baseUrl;
  }

  Future<void> _getAttendanceList() async {
    if (!mounted) return;

    setState(() {
      inprogresssreport = true;
      _reportList.clear();
      summary = null;
    });

    // ডাইনামিক ফিল্টারসহ URL জেনারেট করা
    String finalUrl = _buildUrl();

    ApiResponse response = await NetworkCaller.getRequest(
      url: finalUrl,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      final reportdata = response.responseData;

      // সামারি ডাটা পার্স করা
      if (reportdata['summary'] != null) {
        summary = AttendanceReportModel.fromSummaryJson(reportdata['summary']);
      }

      // লিস্ট ডাটা পার্স করা
      final List<dynamic> entries = reportdata['data'] as List<dynamic>? ?? [];
      for (Map<String, dynamic> json in entries) {
        _reportList.add(AttendanceReportModel.fromEntryJson(json));
      }
    } else {
      _showErrorSnackBar(response.errorMessage);
    }

    if (mounted) {
      setState(() {
        inprogresssreport = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Center(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "Report",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              //.........
              Row(
                children: [
                  // 1st Card: Total Employees
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xFF3B82F6),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (summary?.totalEmployees ?? 0).toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Total Employees",
                            textAlign: TextAlign.center,

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  // 2nd Card: Total Present
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (summary?.totalPresent ?? 0).toString(),

                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Total \nPresent",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  // 3rd Card: Total Absent
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xFFF43F5E),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (summary?.totalAbsent ?? 0).toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Total\nAbsent",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  // 4th Card: Total On Leave
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xFFF59E0B),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (summary?.totalLeave ?? 0).toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Total \nOn Leave",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              /////............
              SizedBox(height: 16),
              // Date Filters
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(
                      _fromdateController,
                      "From Date",
                      "From Date",
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildDatePicker(
                      _todateController,
                      "To Date",
                      "To Date",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ID & Status Filters
              // Row(
              //   children: [
              //     Expanded(
              //       child: _buildSearchField(_departmentController, "Dept ID"),
              //     ),
              //     const SizedBox(width: 15),
              //     Expanded(
              //       child: _buildSearchField(_statusController, "Status"),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 12),

              // Table Header
              _buildTableHeader(),

              // Report List
              Expanded(
                child: Visibility(
                  visible: !inprogresssreport,
                  replacement: const Center(
                    child: CustomCircularProgressIndicator(),
                  ),
                  child: _reportList.isEmpty
                      ? const Center(child: Text("No Data Found"))
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: _reportList.length,
                          itemBuilder: (context, index) =>
                              _buildReportItem(_reportList[index], index),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(
      //   currentIndex: widget.fromTabIndex,
      // ),
    );
  }

  // --- UI Helper Widgets ---

  Widget _buildDatePicker(
    TextEditingController controller,
    String hint,
    String label,
  ) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        isDense: true,

        hintText: hint,
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16),
        filled: true,
        fillColor: Colors.white,

        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            controller.text = DateFormat('d-MM-yyyy').format(pickedDate);
          });
          _getAttendanceList(); // তারিখ পরিবর্তনের সাথে সাথে কল হবে
        }
      },
    );
  }

  // Widget _buildSearchField(TextEditingController controller, String label) {
  //   return TextFormField(
  //     controller: controller,
  //     keyboardType: TextInputType.text,
  //     textInputAction: TextInputAction.search,
  //     decoration: InputDecoration(
  //       labelText: label,
  //       isDense: true,
  //       contentPadding: const EdgeInsets.symmetric(
  //         horizontal: 12,
  //         vertical: 10,
  //       ),
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //     ),
  //     onFieldSubmitted: (value) =>
  //         _getAttendanceList(), // কিবোর্ড থেকে সার্চ দিলেই কল হবে
  //   );
  // }

  Widget _buildTableHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: const [
              Expanded(
                flex: 2,
                child: Text(
                  "SL",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
              Expanded(
                flex: 10,
                child: Text(
                  "Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  "In Time",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  "Out Time",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  "Source",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  "Status",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
          child: Divider(color: Colors.grey.shade200, thickness: 1),
        ),
      ],
    );
  }

  Widget _buildReportItem(AttendanceReportModel item, int index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: ${item.employeeName ?? '-'}",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Dept: ${item.department ?? '-'}",
                      style: const TextStyle(fontSize: 9),
                    ),
                    Text(
                      "Desig: ${item.designation ?? '-'}",
                      style: const TextStyle(fontSize: 9),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  item.inTime ?? '-',
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  item.outTime ?? '-',
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  item.source ?? '-',
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  item.status ?? '-',
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Color(0xFFE0E0E0), thickness: 0.5),
      ],
    );
  }
}
