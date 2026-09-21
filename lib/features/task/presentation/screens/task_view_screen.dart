import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:devsalesxpert/features/common/presentation/screens/main_nav_holder.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';

class TaskViewScreen extends StatefulWidget {
  const TaskViewScreen({super.key});

  @override
  State<TaskViewScreen> createState() => _TaskViewScreenState();
}

class _TaskViewScreenState extends State<TaskViewScreen> {
  // final List<LeaveBalance> _leaveBalanceList = [];
  // bool inprogrssleavebalance = false;

  // bool inprogressconvenyance = false;
  // bool inprogresscsentbill = false;
  // int sentBill = 0;

  // // convenyance list
  // final List<ConveyanceModel> _convenyanceList = [];
  // Future<void> _convenyanceGetApiList() async {
  //   inprogressconvenyance = true;
  //   setState(() {});
  //   ApiResponse response = await NetworkCaller.getRequest(
  //     url: Urls.conveyanceUrl,
  //     token: AuthController.accessToken,
  //   );
  //   if (response.isSuccess) {
  //     final convenyancedata = response.responseData;
  //     _convenyanceList.clear();
  //     for (Map<String, dynamic> convenyancejson in convenyancedata['data']) {
  //       final convenyancemodelall = ConveyanceModel.fromJson(convenyancejson);
  //       _convenyanceList.add(convenyancemodelall);
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         duration: const Duration(seconds: 2),
  //         backgroundColor: Colors.red,
  //         content: Center(
  //           child: Text(
  //             response.errorMessage,
  //             style: TextStyle(
  //               fontSize: 18,
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   }

  //   inprogressconvenyance = false;
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();

    // _convenyanceGetApiList();
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
          "Task Info",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: ScreenBackground(
        child: Column(
          children: [
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                // Get.to(() => TaskEntry());
              },
              child: Container(
                height: 40,
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Soft shadow color
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
                      "Add Task",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "This module is coming soon...",
                      style: TextTheme.of(context).bodyLarge,
                    ),
                  ),
                ],
              ),
            ),

            ///
            // Conveyence Bill .....................................................................
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Column(
            //       children: [
            //         SizedBox(height: 10),
            //         // Table Headers
            //         Column(
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.symmetric(horizontal: 10),
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: const [
            //                   Expanded(
            //                     flex: 3,
            //                     child: Text(
            //                       "Date",
            //                       style: TextStyle(
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 10,
            //                       ),
            //                     ),
            //                   ),

            //                   Expanded(
            //                     flex: 4,
            //                     child: Text(
            //                       "Assign By",
            //                       style: TextStyle(
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 10,
            //                       ),
            //                     ),
            //                   ),
            //                   Expanded(
            //                     flex: 3,
            //                     child: Text(
            //                       "Assignee",

            //                       style: TextStyle(
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 10,
            //                       ),
            //                     ),
            //                   ),

            //                   Expanded(
            //                     flex: 2,
            //                     child: Text(
            //                       "Project",

            //                       style: TextStyle(
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 10,
            //                       ),
            //                     ),
            //                   ),
            //                   Expanded(
            //                     flex: 2,
            //                     child: Text(
            //                       "Category",

            //                       style: TextStyle(
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 10,
            //                       ),
            //                     ),
            //                   ),

            //                   Expanded(
            //                     flex: 2,
            //                     child: Text(
            //                       "Action",

            //                       style: TextStyle(
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 10,
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             SizedBox(
            //               height: 5,
            //               child: Divider(
            //                 color: Color(0xFF57F1FF),
            //                 thickness: 1,
            //               ),
            //             ),
            //           ],
            //         ),

            //         Expanded(
            //           child: Visibility(
            //             visible: inprogressconvenyance == false,
            //             replacement: Center(
            //               child: CustomCircularProgressIndicator(),
            //             ),
            //             child: ListView.builder(
            //               itemCount: _convenyanceList.length,
            //               itemBuilder: (context, index) {
            //                 // final reverseIndex = _datalist.length - 1 - index;
            //                 var item = _convenyanceList[index];

            //                 return Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Padding(
            //                       padding: const EdgeInsets.symmetric(
            //                         horizontal: 10,
            //                       ),
            //                       child: Row(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceBetween,
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           Expanded(
            //                             flex: 3,
            //                             child: Text(
            //                               item.visitDate!,

            //                               style: const TextStyle(fontSize: 10),
            //                             ),
            //                           ),

            //                           Expanded(
            //                             flex: 4,
            //                             child: Text(
            //                               item.clientName!,

            //                               style: const TextStyle(fontSize: 10),
            //                             ),
            //                           ),

            //                           Expanded(
            //                             flex: 3,
            //                             child: Text(
            //                               item.originalAmount.toString(),

            //                               style: const TextStyle(fontSize: 10),
            //                             ),
            //                           ),
            //                           Expanded(
            //                             flex: 2,
            //                             child: Text(
            //                               item.approvedAmount.toString(),

            //                               style: const TextStyle(fontSize: 10),
            //                             ),
            //                           ),

            //                           Expanded(
            //                             flex: 2,
            //                             child: Text(
            //                               item.billstatus.toString(),

            //                               style: const TextStyle(fontSize: 10),
            //                             ),
            //                           ),

            //                           Expanded(
            //                             flex: 2,
            //                             child: InkWell(
            //                               onTap: () async {
            //                                 // 1️⃣ Show confirmation dialog
            //                                 bool?
            //                                 confirm = await showDialog<bool>(
            //                                   context: context,
            //                                   builder: (context) => AlertDialog(
            //                                     title: Text("Confirm Approval"),
            //                                     content: Text(
            //                                       "Are you want to sent for approval?",
            //                                     ),
            //                                     actions: [
            //                                       TextButton(
            //                                         onPressed: () => Get.back(
            //                                           result: false,
            //                                         ), // No
            //                                         child: Text(
            //                                           "No",
            //                                           style: TextStyle(
            //                                             color: Colors.red,
            //                                             fontSize: 22,
            //                                           ),
            //                                         ),
            //                                       ),
            //                                       TextButton(
            //                                         onPressed: () => Get.back(
            //                                           result: true,
            //                                         ), // Yes
            //                                         child: Text(
            //                                           "Yes",
            //                                           style: TextStyle(
            //                                             fontSize: 18,
            //                                             color: Color(
            //                                               0xFF8F66DC,
            //                                             ),
            //                                           ),
            //                                         ),
            //                                       ),
            //                                     ],
            //                                   ),
            //                                 );

            //                                 // 2️⃣ If user pressed No or dismissed dialog, return
            //                                 if (confirm != true) return;
            //                                 if (item.paymentStatus == 0) {
            //                                   _sentApprovalBill(
            //                                     item.conveyanceId!,
            //                                     item.paymentStatus!,
            //                                   );
            //                                 }
            //                               },
            //                               child: Icon(
            //                                 Icons.telegram,
            //                                 size: 20,
            //                                 color: Colors.blueAccent,
            //                               ),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                     SizedBox(
            //                       height: 5,
            //                       child: Divider(
            //                         color: Color(0xFF57F1FF),
            //                         thickness: 1,
            //                       ),
            //                     ),
            //                     SizedBox(height: 5),
            //                   ],
            //                 );
            //               },
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Future<void> _sentApprovalBill(int id, int status) async {
  //   inprogresscsentbill = true;
  //   setState(() {});

  //   final Map<String, dynamic> requestBody = {
  //     "conveyance_id": id, // Your backend ID is requested.
  //     "payment_status_code": status, //  You are sending status from here.
  //   };

  //   ApiResponse response = await NetworkCaller.postRequest(
  //     url: Urls.sentbillApprovalUrl,
  //     body: requestBody,
  //     token: AuthController.accessToken,
  //   );

  //   if (response.isSuccess && response.responseData["success"] == true) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         duration: const Duration(seconds: 2),
  //         backgroundColor: Color(0xFF00A8AA),

  //         content: Center(
  //           child: Text(
  //             response.errorMessage,
  //             style: TextStyle(
  //               fontSize: 18,
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         duration: const Duration(seconds: 2),
  //         backgroundColor: Colors.red,

  //         content: Center(
  //           child: Text(
  //             response.errorMessage,
  //             style: TextStyle(
  //               fontSize: 18,
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //   }

  //   inprogresscsentbill = false;
  //   setState(() {});
  // }
}
