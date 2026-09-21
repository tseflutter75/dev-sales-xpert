import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/screens/main_nav_holder.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/home/data/models/calendar_model.dart';

class CalendarButtonScreen extends StatefulWidget {
  final int fromTabIndex;
  const CalendarButtonScreen({super.key, this.fromTabIndex = 0});

  @override
  State<CalendarButtonScreen> createState() => _CalendarButtonScreenState();
}

class _CalendarButtonScreenState extends State<CalendarButtonScreen> {
  TextEditingController _yearTEcontroller = TextEditingController();
  TextEditingController _monthTEcontroller = TextEditingController();

  final List<CalendarModel> _calenderlist = [];

  bool inprogresscalendar = false;

  CalendarModel? summary;
  int? apiYear;
  int? apiMonth;

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

  Future<void> _getCalendarList() async {
    if (!mounted) return;
    setState(() {
      _calenderlist.clear();
      inprogresscalendar = true;
    });

    String selectedYear = _yearTEcontroller.text.trim();
    String selectedMonth = _getMonthNumber(_monthTEcontroller.text.trim());

    // Generating URL: calendarUrl?year=2026&month=1
    String url = "${Urls.calendarUrl}?year=$selectedYear&month=$selectedMonth";

    ApiResponse response = await NetworkCaller.getRequest(
      url: url,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      final calendardata = response.responseData;

      apiYear = calendardata['filters']['year'];
      apiMonth = calendardata['filters']['month'];

      _yearTEcontroller.text = apiYear.toString();
      _monthTEcontroller.text = DateFormat(
        'MMM',
      ).format(DateTime(apiYear!, apiMonth!));

      summary = CalendarModel.fromSummaryJson(calendardata['data']);

      for (final item
          in calendardata['data']['entries'] as List<dynamic>? ?? []) {
        _calenderlist.add(CalendarModel.fromEntryJson(item));
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
        inprogresscalendar = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    _yearTEcontroller.text = DateTime.now().year.toString();
    _monthTEcontroller.text = DateFormat('MMM').format(DateTime.now());
    _getCalendarList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => BottomNavControllerScreen());
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,

        title: const Text(
          "Calendar",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),

      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              summary != null
                  ? Center(
                      child: Column(
                        children: [
                          // Company Name
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),

                              children: [
                                const TextSpan(
                                  text: "Company: ",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                TextSpan(text: summary?.companyName ?? "-"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4), // to gap
                          // Period
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Period: ",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                TextSpan(text: summary?.calendarPeriod ?? "-"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Total Days
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Total Days: ",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                TextSpan(text: "${summary?.totalDays ?? 0}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(child: CustomCircularProgressIndicator()),

              SizedBox(height: 20),

              // Year and Month input section
              Row(
                children: [
                  Text(
                    "Year",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 3),

                  Expanded(
                    child: TextFormField(
                      controller: _yearTEcontroller,
                      readOnly: false,
                      keyboardType: TextInputType.number,
                      maxLength:
                          4, // It is better to fix 4 digits for the year.
                      decoration: InputDecoration(
                        counterText: "", // To hide text below maxLength

                        filled: true,
                        fillColor: Colors.white,

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),

                      onChanged: (value) {
                        if (value.length == 4) {
                          _getCalendarList();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Month",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 3),
                  Expanded(
                    child: TextField(
                      controller: _monthTEcontroller,
                      readOnly: true,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.calendar_month,
                          color: Color(0xFF8F66DC),
                        ),
                        filled: true,
                        fillColor: Colors.white,

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
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
                          _monthTEcontroller.text = pickedMonth;
                          _getCalendarList();
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Table Headers leave balance
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
                            "Date",

                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Text(
                            "Day",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 3,
                          child: Text(
                            "Leave Type",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Remarks",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
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
              ),

              Expanded(
                child: Visibility(
                  visible: inprogresscalendar == false,
                  replacement: Center(child: CustomCircularProgressIndicator()),
                  child: _calenderlist.isEmpty
                      ? Center(
                          child: GestureDetector(
                            onTap: () {
                              _getCalendarList();
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
                                    color: Color(0xFF8F66DC),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(),
                          itemCount: _calenderlist.length,
                          itemBuilder: (context, index) {
                            final item = _calenderlist[index];
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
                                          formatServerDate(item.date ?? ""),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          dayMap[item.day] ?? item.day ?? "-",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          item.leaveType ?? "-",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,

                                            color:
                                                (item.leaveType ==
                                                        "Weekly Holiday" ||
                                                    item.leaveType ==
                                                        "Govt. Holiday")
                                                ? Colors.amber
                                                : Colors.black,
                                            fontWeight:
                                                (item.leaveType ==
                                                        "Weekly Holiday" ||
                                                    item.leaveType ==
                                                        "Govt. Holiday")
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          item.remarks ?? "-",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                  child: Divider(
                                    color: Colors.grey.shade200,
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

  String formatServerDate(String dateString) {
    try {
      DateFormat inputFormat = DateFormat("dd MMM, yyyy");
      DateTime parsedDate = inputFormat.parse(dateString);

      return DateFormat("dd-MMM-yy").format(parsedDate);
    } catch (e) {
      return dateString; // If there is an error, the original date will be displayed.
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _yearTEcontroller.dispose();
    _monthTEcontroller.dispose();
    super.dispose();
  }
}
