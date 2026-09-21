import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/home/data/models/jobcard_model.dart';

class EmployeeJobcardScreen extends StatefulWidget {
  final int fromTabIndex;
  final int? employeeID;
  const EmployeeJobcardScreen({
    super.key,
    this.fromTabIndex = 0,
    this.employeeID,
  });

  @override
  State<EmployeeJobcardScreen> createState() => _EmployeeJobcardScreenState();
}

class _EmployeeJobcardScreenState extends State<EmployeeJobcardScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  final List<JobCardModel> _jobcardList = [];

  JobCardModel? summary;

  bool inProgressGetJobCard = false;

  // Optional: day short form map
  final dayMap = {
    "Monday": "Mon",
    "Tuesday": "Tue",
    "Wednesday": "Wed",
    "Thursday": "Thu",
    "Friday": "Fri",
    "Saturday": "Sat",
    "Sunday": "Sun",
  };

  String _getMonthNumber(String monthName) {
    Map<String, String> months = {
      "Jan": "1",
      "Feb": "2",
      "Mar": "3",
      "Apr": "4",
      "May": "5",
      "Jun": "6",
      "Jul": "7",
      "Aug": "8",
      "Sep": "9",
      "Oct": "10",
      "Nov": "11",
      "Dec": "12",
    };
    return months[monthName] ?? "";
  }

  // get api
  Future<void> _getJobCardList(int id) async {
    if (!mounted) return;

    setState(() {
      inProgressGetJobCard = true;
      _jobcardList.clear();
      summary = null;
    });

    String selectedYear = _yearController.text.trim();
    String selectedMonth = _getMonthNumber(_monthController.text.trim());

    print("---------- DEBUG INFO ----------");
    print("Passing ID to API: $id");
    print(
      "Full URL: ${Urls.jobcardUrl}?emp_id=$id&year=$selectedYear&month=$selectedMonth",
    );
    print("--------------------------------");

    String url =
        "${Urls.jobcardUrl}?emp_id=$id&year=$selectedYear&month=$selectedMonth";

    print("Request URL: $url");

    ApiResponse response = await NetworkCaller.getRequest(
      url: url,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      final jobcarddata = response.responseData;

      if (jobcarddata['summary'] != null) {
        summary = JobCardModel.fromJson(jobcarddata['summary']);
      }

      final List<dynamic> entries = jobcarddata['data'] as List<dynamic>? ?? [];
      for (Map<String, dynamic> json in entries) {
        _jobcardList.add(JobCardModel.fromJson(json));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Center(
            child: Text(
              response.errorMessage,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {
        inProgressGetJobCard = false;
      });
    }
  }

  @override
  void initState() {
    // এখন define করা হলো

    // DateTime now = DateTime.now();
    // _dateController.text = now.day.toString();

    _monthController.text = DateFormat('MMM').format(DateTime.now());
    _yearController.text = DateTime.now().year.toString();
    if (widget.employeeID != null) {
      _getJobCardList(widget.employeeID!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,

        title: const Text(
          "Job Card",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),

      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info Section
              summary != null
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Name: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500, // Bold part
                                  ),
                                ),
                                TextSpan(
                                  text: summary!.employeeName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400, // Normal part
                                  ),
                                ),
                              ],
                            ),
                          ),

                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Month: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: summary!.month,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Total Days: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: summary!.totalDays.toString(),

                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Total Late: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: summary!.totalLate.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Total Early Leave: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: summary!.totalEarly.toString(),

                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(child: CustomCircularProgressIndicator()),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.only(left: 4, right: 12),
                child: Row(
                  children: [
                    SizedBox(width: 10),

                    Expanded(
                      child: TextFormField(
                        controller: _yearController,
                        readOnly: false,
                        keyboardType: TextInputType.number,
                        maxLength: 4, //
                        decoration: InputDecoration(
                          counterText: "",
                          labelText: "Year", // To hide text below maxLength

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        onChanged: (value) {
                          if (value.length == 4) {
                            _getJobCardList(
                              widget.employeeID!,
                            ); // Direct API call if 4 digits
                          }
                        },
                      ),
                    ),

                    SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: _monthController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Month",
                          suffixIcon: Icon(
                            Icons.calendar_month,
                            color: Color(0xFF8F66DC),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onTap: () async {
                          // List of months from 1-12
                          List<String> months = [
                            "Jan",
                            "Feb",
                            "Mar",
                            "Apr",
                            "May",
                            "Jun",
                            "Jul",
                            "Aug",
                            "Sep",
                            "Oct",
                            "Nov",
                            "Dec",
                          ];

                          String? pickedMonth = await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return SimpleDialog(
                                title: Text("Select Month"),
                                children: months.map((month) {
                                  return SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.pop(context, month);
                                    },
                                    child: Text(month),
                                  );
                                }).toList(),
                              );
                            },
                          );

                          if (pickedMonth != null) {
                            _monthController.text = pickedMonth;
                            _getJobCardList(widget.employeeID!); // filter call
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // search box done
              SizedBox(height: 16),
              // Table Headers
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Day",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            "Date",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 4,
                          child: Text(
                            "Intime",

                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            "Outtime",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 3,
                          child: Text(
                            "Status",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "Source",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                    child: Divider(color: Color(0xFF57F1FF), thickness: 1),
                  ),
                ],
              ),

              // Attendance List
              Expanded(
                child: Visibility(
                  visible: inProgressGetJobCard == false,
                  replacement: const Center(
                    child: CustomCircularProgressIndicator(),
                  ),
                  child: _jobcardList.isEmpty
                      ? Center(
                          child: GestureDetector(
                            onTap: () {
                              _getJobCardList(widget.employeeID!);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                // Icon(
                                //   Icons.refresh,
                                //   size: 40,
                                //   color: Color(0xFF8F66DC),
                                // ),
                                SizedBox(height: 10),
                                Text(
                                  "No data found\n",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(),
                          itemCount: _jobcardList.length,
                          itemBuilder: (context, index) {
                            final item = _jobcardList[index];
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          dayMap[item.day] ?? item.day ?? "-",
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Builder(
                                          builder: (context) {
                                            // Todasys date  (Year, Month, Day)
                                            final now = DateTime.now();
                                            final today = DateTime(
                                              now.year,
                                              now.month,
                                              now.day,
                                            );

                                            // 2. Apnar item-er date k parse kora
                                            final itemDate = DateTime.parse(
                                              item.date.toString(),
                                            );
                                            final compareDate = DateTime(
                                              itemDate.year,
                                              itemDate.month,
                                              itemDate.day,
                                            );

                                            // 3. Condition check
                                            bool isToday = compareDate
                                                .isAtSameMomentAs(today);

                                            return Text(
                                              formatDate(item.date),
                                              style: TextStyle(
                                                fontSize: 10,
                                                // IF TODAYS tahole Yellow, nahole Black
                                                color: isToday
                                                    ? Colors.blue
                                                    : Colors.black,
                                                fontWeight: isToday
                                                    ? FontWeight.bold
                                                    : FontWeight
                                                          .normal, // Optional: Bold
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          item.inTime!,

                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          item.outTime!,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          (item.source != null &&
                                                  item.source!.isNotEmpty)
                                              ? item.status!
                                              : (item.remarks ?? ''),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          item.source!,

                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                  child: Divider(
                                    color: Color(0xFF57F1FF),
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            );
                          },
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

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    try {
      DateTime inputDate = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yy').format(inputDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  // void _clearText() {
  //   _dateController.clear();
  //   _monthController.clear();
  //   _yearController.clear();

  //   setState(() {
  //     _yearController.text = DateTime.now().year.toString();
  //     _monthController.text = DateFormat('MMM').format(DateTime.now());
  //   });
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dateController.dispose();
    _monthController.dispose();
    _yearController.dispose();
  }
}
