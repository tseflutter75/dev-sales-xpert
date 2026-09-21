import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/screens/main_nav_holder.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/visit/data/models/client_type_drop_dwon_model.dart';
import 'package:devsalesxpert/features/visit/data/models/conveyance_model.dart';
import 'package:devsalesxpert/features/visit/data/models/visit_and_spot_visit_usermodel.dart';
import 'package:devsalesxpert/features/visit/presentation/screens/customer_button_entry_screen.dart';
import 'package:devsalesxpert/features/visit/presentation/screens/customer_list_screen.dart';
import 'package:devsalesxpert/features/visit/presentation/screens/visit_entry_screen.dart';
import 'package:devsalesxpert/features/visit/presentation/screens/visit_update_screen.dart';
import 'package:devsalesxpert/features/visit/presentation/screens/visit_view_details_screen.dart';

class VisitScreen extends StatefulWidget {
  const VisitScreen({super.key});

  @override
  State<VisitScreen> createState() => _VisitScreeState();
}

class _VisitScreeState extends State<VisitScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  bool inprogresssvisitpending = false;
  bool inprogresssvisithistroy = false;
  bool inprogressconvenyance = false;
  bool inprogresscsentbill = false;
  int sentBill = 0;

  // pending get api
  final List<VisitSpotModel> _visitpendingList = [];
  Future<void> getvisitpending() async {
    inprogresssvisitpending = true;
    setState(() {});
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.visitpendingUrl,
      token: AuthController.accessToken,
    );
    if (!mounted) return;
    if (response.isSuccess) {
      _visitpendingList.clear();
      final visitpendingdata = response.responseData;
      for (Map<String, dynamic> visitpendingjosn in visitpendingdata['data']) {
        final visitpendingmodelall = VisitSpotModel.fromVisitJson(
          visitpendingjosn,
        );
        _visitpendingList.add(visitpendingmodelall);
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
    inprogresssvisitpending = false;
    setState(() {});
  }

  // history get api
  final List<VisitSpotModel> _visithistoryList = [];
  Future<void> getvisithistory() async {
    inprogresssvisithistroy = true;
    setState(() {});
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.visithistoryUrl,
      token: AuthController.accessToken,
    );
    if (!mounted) return;
    if (response.isSuccess) {
      final visithistorydata = response.responseData;
      _visithistoryList.clear();
      for (Map<String, dynamic> visihistoryjosn in visithistorydata['data']) {
        final visithistorymodelall = VisitSpotModel.fromVisitJson(
          visihistoryjosn,
        );
        _visithistoryList.add(visithistorymodelall);
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

    inprogresssvisithistroy = false;
    setState(() {});
  }

  // client get api
  bool inprogresssClient = false;
  final List<ClientTypeModel> _clientNameList = [];
  ClientTypeModel? selectedClient;
  Future<void> _fetchclintList() async {
    inprogresssClient = true;
    setState(() {});
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.clientfromUrl,
      token: AuthController.accessToken,
    );
    if (!mounted) return;
    if (response.isSuccess) {
      final clienttypeData = response.responseData;
      for (Map<String, dynamic> clienttypeJson in clienttypeData['data']) {
        final clienttypeModelall = ClientTypeModel.fromJson(clienttypeJson);
        _clientNameList.add(clienttypeModelall);
      }
      // setState(() {});
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
    inprogresssClient = false;
    setState(() {});
  }

  // convenyance list
  final List<ConveyanceModel> _convenyanceList = [];
  Future<void> _convenyanceGetApiList() async {
    inprogressconvenyance = true;
    setState(() {});
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.conveyanceUrl,
      token: AuthController.accessToken,
    );

    if (!mounted) return;
    if (response.isSuccess) {
      final convenyancedata = response.responseData;
      _convenyanceList.clear();
      for (Map<String, dynamic> convenyancejson in convenyancedata['data']) {
        final convenyancemodelall = ConveyanceModel.fromJson(convenyancejson);
        _convenyanceList.add(convenyancemodelall);
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

    setState(() {
      inprogressconvenyance = false;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    // Open Hive box and load data
    getvisitpending();
    getvisithistory();
    _fetchclintList();
    _convenyanceGetApiList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: AppBar(
          leading: IconButton(
            padding: EdgeInsets.only(bottom: 51),
            onPressed: () {
              Get.offAll(() => BottomNavControllerScreen());
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
          title: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Text(
                  "Visit",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Get.to(() => VisitCustomerButtonScreen());
                      },
                      child: Container(
                        height: 35,
                        width: 90,
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
                        padding: const EdgeInsets.all(1.5),

                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Center(
                            child: Text(
                              "Customer",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    ///
                    GestureDetector(
                      onTap: () async {
                        Get.to(() => CustomerListScreen());
                      },
                      child: Container(
                        height: 35,
                        width: 90,
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
                        padding: const EdgeInsets.all(1.5),

                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Center(
                            child: Text(
                              "Customer List",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),
            ],
          ),
          centerTitle: true,
          toolbarHeight: 100,

          bottom: TabBar(
            controller: tabController,
            dividerColor: Color(0xFF8F66DC),
            labelColor: const Color(0xFF7F2AFF),
            unselectedLabelColor: Colors.black54,
            indicatorColor: const Color(0xFF7F2AFF),
            tabs: const [
              Tab(text: "Pending"),
              Tab(text: "History"),
              Tab(text: "Conveyance"),
            ],
          ),
        ),
      ),
      body: ScreenBackground(
        child: TabBarView(
          controller: tabController,
          children: [
            // pending..............................................................................
            Visibility(
              visible: inprogresssvisitpending == false,
              replacement: Center(child: CustomCircularProgressIndicator()),
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  top: 15,
                  left: 16,
                  right: 16,
                  bottom: 90,
                ),
                itemCount: _visitpendingList.length,
                itemBuilder: (context, index) {
                  var item = _visitpendingList[index];
                  return GestureDetector(
                    onTap: () async {
                      var refreshNeeded = await Get.to(
                        () => VisitDetailsScreen(
                          item: _visitpendingList[index],
                          index: index,
                        ),
                      );

                      if (refreshNeeded == true) {
                        // Will refresh data by calling API
                        await getvisitpending();
                        await getvisithistory();
                        await _convenyanceGetApiList();
                      }
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.9),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// ---------- HEADER ----------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.visitType ?? "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink,
                                  ),
                                ),

                                InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => VisitUpdateScreen(
                                        item: _visitpendingList[index],
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    size: 27,
                                    color: Color(0xFF7F2AFF),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            /// ---------- DATE ----------
                            buildInfoRow(
                              "Visit Date",
                              formatDate(item.visitDate),
                            ),

                            /// ---------- PURPOSE ----------
                            buildInfoRow(
                              "Purpose",
                              item.visitPurpose ?? "--",
                              fontWeight: FontWeight.w500,
                            ),

                            /// ---------- MEETING ONLY ----------
                            if (item.visitType == "Meeting") ...[
                              buildInfoRow(
                                "Client Name",
                                item.clientName ?? "--",
                              ),
                              buildInfoRow(
                                "Contact Person",
                                item.contactPerson ?? "--",
                              ),
                              buildInfoRow(
                                "Mobile",
                                item.contactPersonMobile ?? "--",
                              ),
                            ],

                            /// ---------- TIME ----------
                            buildInfoRow(
                              "Time (From)",
                              formatTime(item.visitStartTime),
                            ),
                            buildInfoRow(
                              "Time (To)",
                              formatTime(item.visitEndTime),
                            ),

                            /// ---------- LOCATION ----------
                            buildInfoRow(
                              "Location (From)",
                              item.visitFrom ?? "--",
                            ),
                            buildInfoRow("Location (To)", item.visitTo ?? "--"),

                            buildInfoRow("Note", item.remarks ?? ""),

                            /// ---------- STATUS ----------
                            if (item.status != null)
                              buildInfoRow(
                                "Status",
                                item.status ?? "Pending",
                                valueColor: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // History tab.....................................................................
            Visibility(
              visible: inprogresssvisithistroy == false,
              replacement: Center(child: CustomCircularProgressIndicator()),
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  top: 15,
                  left: 16,
                  right: 16,
                  bottom: 90,
                ),
                itemCount: _visithistoryList.length,
                itemBuilder: (context, index) {
                  // final reverseIndex = _datalist.length - 1 - index;
                  var item = _visithistoryList[index];

                  return GestureDetector(
                    onTap: () async {
                      var refreshNeeded = await Get.to(
                        () => VisitDetailsScreen(
                          item: _visithistoryList[index],
                          index: index,
                        ),
                      );

                      if (refreshNeeded == true) {
                        getvisithistory(); // This will be called when Get.back(result: true) is returned from the details page.
                      }
                    },

                    child: Card(
                      color: Colors.white,
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.9),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.visitType ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),

                            /// ---------- HEADER ----------
                            const SizedBox(height: 6),

                            /// ---------- DATE ----------
                            buildInfoRow(
                              "Visit Date",
                              formatDate(item.visitDate),
                            ),

                            /// ---------- PURPOSE ----------
                            buildInfoRow(
                              "Purpose",
                              item.visitPurpose ?? "--",
                              fontWeight: FontWeight.w500,
                            ),

                            /// ---------- MEETING ONLY ----------
                            if (item.visitType == "Meeting") ...[
                              buildInfoRow(
                                "Client Name",
                                item.clientName ?? "--",
                              ),
                              buildInfoRow(
                                "Contact Person",
                                item.contactPerson ?? "--",
                              ),
                              buildInfoRow(
                                "Mobile",
                                item.contactPersonMobile ?? "--",
                              ),
                            ],

                            /// ---------- TIME ----------
                            buildInfoRow(
                              "Time (From)",
                              formatTime(item.visitStartTime),
                            ),
                            buildInfoRow(
                              "Time (To)",
                              formatTime(item.visitEndTime),
                            ),

                            /// ---------- LOCATION ----------
                            buildInfoRow(
                              "Location (From)",
                              item.visitFrom ?? "--",
                            ),
                            buildInfoRow("Location (To)", item.visitTo ?? "--"),
                            buildInfoRow("Note", item.remarks ?? ""),

                            /// ---------- STATUS ----------
                            if (item.status != null)
                              buildInfoRow(
                                "Status",
                                item.status ?? "Pending",
                                valueColor: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Conveyence Bill .....................................................................
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  // Table Headers
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Expanded(
                              flex: 3,
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
                                "Customer",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Bill Amount",

                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Text(
                                "Approve Amount",

                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Status",

                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Text(
                                "Action",

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
                        child: Divider(
                          color: Colors.grey.shade200,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: Visibility(
                      visible: inprogressconvenyance == false,
                      replacement: Center(
                        child: CustomCircularProgressIndicator(),
                      ),
                      child: ListView.builder(
                        itemCount: _convenyanceList.length,
                        itemBuilder: (context, index) {
                          // final reverseIndex = _datalist.length - 1 - index;
                          var item = _convenyanceList[index];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        item.visitDate!,

                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),

                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        item.clientName!,

                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),

                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        item.originalAmount.toString(),

                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        item.approvedAmount.toString(),

                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),

                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        item.billstatus.toString(),

                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),

                                    Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: () async {
                                          // 1️⃣ Show confirmation dialog
                                          bool?
                                          confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text("Confirm Approval"),
                                              content: Text(
                                                "Are you want to sent for approval?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Get.back(
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
                                                  onPressed: () => Get.back(
                                                    result: true,
                                                  ), // Yes
                                                  child: Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Color(0xFF8F66DC),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );

                                          // 2️⃣ If user pressed No or dismissed dialog, return
                                          if (confirm != true) return;
                                          if (item.paymentStatus == 0) {
                                            await _sentApprovalBill(
                                              item.conveyanceId!,
                                              item.paymentStatus!,
                                            );

                                            await _convenyanceGetApiList();
                                            setState(() {});
                                          }
                                        },
                                        child: Icon(
                                          Icons.telegram,
                                          size: 20,
                                          color: Colors.blueAccent,
                                        ),
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
                              SizedBox(height: 5),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await Get.to(() => VisitEntryScreen());
          if (res == true) {
            getvisitpending();
            setState(() {});
          }
        },
        backgroundColor: const Color(0xFF7F2AFF),

        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _sentApprovalBill(int id, int status) async {
    inprogresscsentbill = true;
    setState(() {});

    final Map<String, dynamic> requestBody = {
      "conveyance_id": id, // Your backend ID is requested.
      "payment_status_code": status, //  You are sending status from here.
    };

    ApiResponse response = await NetworkCaller.postRequest(
      url: Urls.sentbillApprovalUrl,
      body: requestBody,
      token: AuthController.accessToken,
    );

    if (response.isSuccess && response.responseData["success"] == true) {
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

    inprogresscsentbill = false;
    setState(() {});
  }

  /// ---------- SAFE DATE ----------
  String formatDate(String? date) {
    try {
      if (date == null || date.isEmpty) {
        return "--";
      }
      DateTime dt;
      // Try ISO parse first, then common 'dd-MM-yyyy' format
      try {
        dt = DateTime.parse(date);
      } catch (e) {
        try {
          dt = DateFormat('dd-MM-yyyy').parse(date);
        } catch (e) {
          return "--";
        }
      }

      return DateFormat('dd-MM-yyyy').format(dt);
    } catch (e) {
      return "--";
    }
  }

  /// ---------- SAFE TIME ----------
  String formatTime(String? time) {
    try {
      if (time == null || time.isEmpty) {
        return "--";
      }

      DateTime dt;
      // If already in AM/PM format
      if (time.contains("AM") || time.contains("PM")) {
        try {
          dt = DateFormat('hh:mm a').parse(time);
        } catch (e) {
          return "--";
        }
      } else {
        // Try to parse as HH:mm:ss or HH:mm
        try {
          dt = DateTime.parse("2026-01-01 $time");
        } catch (e) {
          try {
            dt = DateFormat('HH:mm').parse(time);
          } catch (e) {
            return "--";
          }
        }
      }

      return DateFormat('hh:mm a').format(dt);
    } catch (e) {
      return "--";
    }
  }

  /// ---------- COMMON ROW ----------
  Widget buildInfoRow(
    String label,
    String value, {
    Color valueColor = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          const Text(" : ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: valueColor,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
