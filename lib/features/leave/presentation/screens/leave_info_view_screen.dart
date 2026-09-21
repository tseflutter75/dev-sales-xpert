import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/screens/main_nav_holder.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/leave/data/models/leave_balance_model.dart';
import 'package:devsalesxpert/features/leave/data/models/leave_history_model.dart';
import 'package:devsalesxpert/features/leave/presentation/screens/leave_entry_screen.dart';
import 'package:devsalesxpert/features/leave/presentation/screens/leave_update_screen.dart';

class LeaveInfoScreen extends StatefulWidget {
  const LeaveInfoScreen({super.key});

  @override
  State<LeaveInfoScreen> createState() => _LeaveInfoScreenState();
}

class _LeaveInfoScreenState extends State<LeaveInfoScreen> {
  final List<LeaveHistoryModel> _leaveHistoryList = [];
  final List<LeaveBalance> _leaveBalanceList = [];

  bool inprogrssleavehistroy = false;
  bool inprogrssleavebalance = false;
  bool deleteleaveinprogresss = false;

  // get api leave balance
  Future<void> _getapiLeaveBalance() async {
    inprogrssleavebalance = true;
    setState(() {});

    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.leaveBalanceUrl,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      final leavebalancedata = response.responseData;
      for (Map<String, dynamic> leavebalancejson
          in leavebalancedata['data']['leaves']) {
        final leavebalancemodelall = LeaveBalance.fromJson(leavebalancejson);

        _leaveBalanceList.add(leavebalancemodelall);
      }
    } else {
      // ignore: use_build_context_synchronously
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
      inprogrssleavebalance = false;
      setState(() {});
    }
  }

  // get api leave history
  Future<void> _getapiLeavehistory() async {
    inprogrssleavehistroy = true;
    setState(() {});

    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.leaveHistoryUrl,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      final leavehistorydata = response.responseData;

      for (Map<String, dynamic> leavehistryjson
          in leavehistorydata['data']['leaves']) {
        final leavehistroymodelall = LeaveHistoryModel.fromJson(
          leavehistryjson,
        );

        _leaveHistoryList.add(leavehistroymodelall);
      }
    } else {
      // ignore: use_build_context_synchronously
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
      inprogrssleavehistroy = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getapiLeaveBalance();
    _getapiLeavehistory();

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
        title: Text(
          "Leave Info",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: ScreenBackground(
        child: RefreshIndicator(
          onRefresh: () async {
            _leaveBalanceList.clear();
            _leaveHistoryList.clear();
            await Future.wait([_getapiLeaveBalance(), _getapiLeavehistory()]);
          },
          child: Column(
            children: [
              SizedBox(height: 15),
              GestureDetector(
                onTap: () async {
                  Get.to(() => LeaveRequestScreen());
                },
                child: Container(
                  height: 40,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          0.1,
                        ), // Soft shadow color
                        spreadRadius: 2, // How far the shadow spreads
                        blurRadius: 4, // How soft the shadow looks
                        offset: const Offset(
                          0,
                          4,
                        ), // Shifts shadow down (X, Y) to look raised
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Center(
                      child: Text(
                        "Leave Request",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              ///////////////////////////////////////////////////////////////////////
              Container(
                padding: EdgeInsets.only(bottom: 3),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                ),
                child: Text(
                  "Leave Balance",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 10),

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
                            "Type",

                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 2,
                          child: Text(
                            "Allotment",
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
                            "Taken",
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
                            "Balance",
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

              SizedBox(
                height: _leaveBalanceList.length * 40.0,
                child: Visibility(
                  replacement: Center(child: CustomCircularProgressIndicator()),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(),
                    itemCount: _leaveBalanceList.length,
                    itemBuilder: (context, index) {
                      final item = _leaveBalanceList[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,

                                  child: Text(
                                    item.leaveType,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    item.allotment.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),

                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item.taken.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    item.remaining.toString(),
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

              // leave histroy
              ///////////////////////////////////////////////////////////////////////////////////
              Container(
                padding: EdgeInsets.only(bottom: 3),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                ),
                child: Text(
                  "Leave History",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Table Headers
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Type",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 4,
                          child: Text(
                            "Date Range",
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
                            "Days",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 5,
                          child: Text(
                            "Status",
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
                            "Action",
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

              SizedBox(height: 3),

              // Attendance List leave history
              Expanded(
                child: Visibility(
                  visible: inprogrssleavehistroy == false,
                  replacement: const Center(
                    child: CustomCircularProgressIndicator(),
                  ),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(),
                    itemCount: _leaveHistoryList.length,
                    itemBuilder: (context, index) {
                      final item = _leaveHistoryList[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    item.leavetype,

                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),

                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    formatDateRange(item.dateRange),

                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),

                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item.totalDays.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    item.StatusText,
                                    textAlign: TextAlign.center,

                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),

                                ////////////////
                                item.StatusText != "Approved"
                                    ? Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(
                                                    () => LeaveUpdateScreen(
                                                      item: item,
                                                      isReadOnly: false,
                                                    ),
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                ),
                                              ),
                                              SizedBox(width: 5),

                                              GestureDetector(
                                                onTap: () async {
                                                  // 1️⃣ Show confirmation dialog
                                                  bool?
                                                  confirm = await showDialog<bool>(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: Text(
                                                        "Confirm deletion?",
                                                      ),
                                                      content: Text(
                                                        "Are you sure you want to delete this?",
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Get.back(
                                                                result: false,
                                                              ), // No
                                                          child: Text(
                                                            "No",
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 22,
                                                            ),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Get.back(
                                                                result: true,
                                                              ), // Yes
                                                          child: Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Color(
                                                                0xFF8F66DC,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );

                                                  // 2️⃣ If user pressed No or dismissed dialog, return
                                                  if (confirm != true) return;

                                                  await _leaveDelete(
                                                    item.id.toString(),
                                                  );
                                                },

                                                child: Icon(
                                                  Icons.delete,
                                                  size: 20,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        // This is the fix for the "Approved" row alignment
                                        flex: 3,
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () => Get.to(
                                              () => LeaveUpdateScreen(
                                                item: item,
                                                isReadOnly: true,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.visibility,
                                              color: Colors.blue,
                                              size: 20.0,
                                              semanticLabel:
                                                  'View content', // For accessibility/screen readers
                                            ),
                                          ),
                                        ),
                                      ),

                                //////////////////////
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
      // bottomNavigationBar:  CustomBottomNavigationBar(currentIndex: widget.fromTabIndex)
    );
  }

  Future<void> _leaveDelete(String id) async {
    deleteleaveinprogresss = true;
    setState(() {});

    ApiResponse response = await NetworkCaller.postRequest(
      url: Urls.deleteleaveRequestUrl(id),
      token: AuthController.accessToken,
    );

    if (response.isSuccess && response.responseData["success"] == true) {
      setState(() {
        _leaveHistoryList.removeWhere((e) => e.id.toString() == id);
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Color(0xFF00A8AA),

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
    } else {
      // ignore: use_build_context_synchronously
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

    deleteleaveinprogresss = false;
    setState(() {});
  }

  String formatDateRange(String dateRange) {
    try {
      // split by " To "
      List<String> dates = dateRange.split(" To ");
      if (dates.length != 2) return dateRange;

      final DateTime start = DateTime.parse(dates[0]);
      final DateTime end = DateTime.parse(dates[1]);

      String formattedStart = DateFormat('dd-MM-yy').format(start);
      String formattedEnd = DateFormat('dd-MM-yy').format(end);

      return "$formattedStart To $formattedEnd";
    } catch (e) {
      return dateRange; // parse fail হলে original string return
    }
  }

  /// date + time : dd--MM--yyyy hh:mm a
  String formatDateTime(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('dd--MM--yy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
