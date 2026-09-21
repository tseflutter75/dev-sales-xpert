import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:ntp/ntp.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/home/presentation/screens/calendar_button.dart';
import 'package:devsalesxpert/features/home/presentation/screens/jobcard.dart';
import 'package:devsalesxpert/features/home/presentation/screens/notice_screen.dart';
import 'package:devsalesxpert/features/home/presentation/screens/phonebook_screen.dart';
import 'package:devsalesxpert/features/home/presentation/screens/report_password_screen.dart';
import 'package:devsalesxpert/features/home/presentation/screens/report_screen.dart';
import 'package:devsalesxpert/features/leave/presentation/screens/leave_info_view_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _lateInErlyoutNoteController = TextEditingController();
  bool alreadyInGiven = false;

  double? curlat;
  double? curlong;
  String address = "Loading...";
  String formattedTime = "Loading";
  bool inTimeGiven = false;
  bool inprogrssattendance = false;
  bool isHobarWifiPressed = false;
  bool isHobarGpsPressed = false;

  File? image;

  // latitude and longitude example gps
  final NetworkInfo info = NetworkInfo();

  bool _isSaving = false;
  double latitude = 0.0;
  double longitude = 0.0;

  String statusText = "Location not checked yet";

  Timer? utcTimer;

  void startUTCTimer() {
    utcTimer?.cancel(); // To stop multiple timers

    utcTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      await fetchUTCTime();
    });
  }

  Future<void> fetchUTCTime() async {
    try {
      DateTime utcTime = await NTP.now();

      if (!mounted) return;

      String newFormattedTime = DateFormat(
        'dd-MM-yy   hh:mm:ss a',
      ).format(utcTime);

      setState(() {
        formattedTime = newFormattedTime;
      });
    } catch (e) {
      if (!mounted) return;

      DateTime now = DateTime.now();

      String newFormattedTime = DateFormat('dd-MM-yy hh:mm:ss a').format(now);

      setState(() {
        formattedTime = newFormattedTime;
      });
    }
  }

  String formatDate(String date) {
    if (date.isEmpty || date.length < 10) return "No Date";

    // "YYYY-MM-DD" from the API
    // Extracting day-month-year by directly splitting
    List<String> parts = date.split('-');
    if (parts.length != 3) return "Invalid Date";

    String year = parts[0];
    String month = parts[1].padLeft(2, '0');
    String day = parts[2].padLeft(2, '0');

    return "$day-$month-$year"; // DD-MM-YYYY
  }

  bool inprogresssnotice = false;
  int totalNoticeCount = 0; // The account will be deposited here.

  Future<void> fetchNoticeNotificationList() async {
    inprogresssnotice = true;
    if (mounted) setState(() {});

    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.noticesNotificationUrl,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      final noticenotificationndata = response.responseData;

      totalNoticeCount =
          noticenotificationndata['valid_notifications_count'] ?? 0;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Center(child: Text(response.errorMessage)),
        ),
      );
    }

    inprogresssnotice = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchLocationAndAddress();
    fetchNoticeNotificationList();
    startUTCTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            children: [
              SizedBox(height: 10),
              // Text(
              //   "Smart Office Management",
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontWeight: FontWeight.bold,
              //     fontSize: 18,
              //   ),
              // ),
              // Text(
              //   "HR Time",
              //   style: TextStyle(
              //     color: Colors.purple,
              //     fontWeight: FontWeight.bold,
              //     fontSize: 18,
              //   ),
              // ),
              Image.asset("assets/images/logo.png", width: 150),
              SizedBox(height: 30),

              // home card..
              Container(
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

                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 2.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                AuthController.userModel?.image ?? "",
                                fit: BoxFit.cover,
                                // If there is an error, there will be no red text, just an icon will be shown.
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      );
                                    },
                              ),
                            ),
                          ),

                          SizedBox(width: 10),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                AuthController.userModel?.nameenglish ??
                                    "No Name",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Text(
                                AuthController.userModel?.departmentname
                                        .toString() ??
                                    "No Name",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Text(
                                AuthController.userModel?.designationname
                                        .toString() ??
                                    "No Name",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Text(
                                "Joining Date: ${formatDate(AuthController.userModel!.joiningdate)}",

                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              Text(
                                AuthController.userModel?.companyName
                                        .toString() ??
                                    "No Name",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // home card done..
              SizedBox(height: 40),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /// WIFI BUTTON  WIFI BUTTON  WIFI BUTTON WIFI BUTTON WIFI BUTTON WIFI BUTTON WIFI BUTTON WIFI BUTTON WIFI BUTTON
                      GestureDetector(
                        onTap: () async {
                          // // 1️⃣ Show confirmation dialog
                          // bool? confirm = await showDialog<bool>(
                          //   context: context,
                          //   builder: (context) => AlertDialog(
                          //     title: Text("Confirm Attendance"),
                          //     content: Text(
                          //       "Do you want to mark your attendance using WIFI?",
                          //     ),
                          //     actions: [
                          //       TextButton(
                          //         onPressed: () =>
                          //             Get.back(result: false), // No
                          //         child: Text(
                          //           "No",
                          //           style: TextStyle(
                          //             color: Colors.red,
                          //             fontSize: 22,
                          //           ),
                          //         ),
                          //       ),
                          //       TextButton(
                          //         onPressed: () =>
                          //             Get.back(result: true), // Yes
                          //         child: Text(
                          //           "Yes",
                          //           style: TextStyle(
                          //             fontSize: 18,
                          //             color: Color(0xFF8F66DC),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // );

                          // // 2️⃣ If user pressed No or dismissed dialog, return
                          // if (confirm != true) return;

                          // // image check
                          // File? capturedImage = await _openCamera();

                          // if (capturedImage == null) {
                          //   return;
                          // }

                          // String savedImageUrl =
                          //     AuthController.userModel!.image;

                          // bool isMatched = await checkImageMatch(
                          //   capturedImage,
                          //   savedImageUrl,
                          // );

                          // // 3️⃣ Continue normal attendance flow
                          // setState(() {
                          //   isHobarWifiPressed = true;
                          // });

                          // if (_isSaving) return;
                          // setState(() => _isSaving = true);

                          // await getCurrentLocation();
                          // // 1️⃣ Check location permission
                          // bool permission = await isPermissionLocation();
                          // if (!permission) {
                          //   setState(() {
                          //     _isSaving = false;
                          //     isHobarWifiPressed = false;
                          //   });
                          //   return; // Stop if permission not granted
                          // }

                          // if (isMatched) {
                          //   // 4️⃣ Attendance save api call
                          //   bool saveSuccessful = await savePostAttendance(
                          //     "WIFI",
                          //     latitude,
                          //     longitude,
                          //   );
                          //   if (!saveSuccessful) {
                          //     setState(() {
                          //       _isSaving = false;
                          //       isHobarWifiPressed = false;
                          //     });
                          //     return;
                          //   }
                          // } else {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       duration: const Duration(seconds: 2),
                          //       backgroundColor: Colors.red,
                          //       content: Center(
                          //         child: Text(
                          //           "Don't matching your face!",
                          //           style: TextStyle(
                          //             fontSize: 18,
                          //             color: Colors.white,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   );
                          // }

                          // // hobar
                          // await Future.delayed(
                          //   const Duration(milliseconds: 100),
                          // );
                          // setState(() {
                          //   // isHobarGpsPressed = false;
                          //   isHobarWifiPressed = false;
                          // });

                          // // ✅ Office network confirmed → Navigate
                          // if (mounted) {
                          //   Get.to(() => JobcardScreen());
                          // }
                          // setState(() => _isSaving = false);

                          // witout camera
                          // 1️⃣ Show confirmation dialog
                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Confirm Attendance"),
                              content: Text(
                                "Do you want to mark your attendance using WIFI?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Get.back(result: false), // No
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
                                      Get.back(result: true), // Yes
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

                          // 3️⃣ Continue normal attendance flow
                          setState(() {
                            isHobarWifiPressed = true;
                          });

                          if (_isSaving) return;
                          setState(() => _isSaving = true);

                          await getCurrentLocation();
                          // 1️⃣ Check location permission
                          bool permission = await isPermissionLocation();
                          if (!permission) {
                            setState(() {
                              _isSaving = false;
                              isHobarWifiPressed = false;
                            });
                            return; // Stop if permission not granted
                          }

                          // 4️⃣ Attendance save api call
                          bool saveSuccessful = await savePostAttendance(
                            "WIFI",
                            latitude,
                            longitude,
                          );
                          if (!saveSuccessful) {
                            setState(() {
                              _isSaving = false;
                              isHobarWifiPressed = false;
                            });
                            return;
                          }

                          await Future.delayed(
                            const Duration(milliseconds: 100),
                          );
                          setState(() {
                            // isHobarGpsPressed = false;
                            isHobarWifiPressed = false;
                          });

                          // ✅ Office network confirmed → Navigate
                          if (mounted) {
                            Get.to(() => JobcardScreen());
                          }
                          setState(() => _isSaving = false);
                        },
                        child: Container(
                          height: 45,
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
                          padding: const EdgeInsets.all(1.5),

                          child: Container(
                            decoration: BoxDecoration(
                              color: isHobarWifiPressed
                                  ? Color(0xFFCAF9FC) // 👈 only this changes
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/wifi.png",
                                  height: 20,
                                  width: 20,
                                ),
                                Text(
                                  "WIFI",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // GPS BUTTON   GPS BUTTON GPS BUTTON GPS BUTTON GPS BUTTON GPS BUTTON GPS BUTTON GPS BUTTON GPS BUTTON GPS BUTTON
                      GestureDetector(
                        onTap: () async {
                          // 1️⃣ Show confirmation dialog
                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Confirm Attendance"),
                              content: Text(
                                "Do you want to mark your attendance using GPS?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Get.back(result: false), // No
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
                                      Get.back(result: true), // Yes
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

                          setState(() {
                            isHobarGpsPressed = true;
                          });

                          await isPermissionLocation();
                          await getCurrentLocation();

                          bool saveSuccessful = await savePostAttendance(
                            "GPS",
                            latitude,
                            longitude,
                          );
                          if (!saveSuccessful) {
                            setState(() {
                              _isSaving = false;
                              isHobarGpsPressed = false;
                            });
                            return;
                          }

                          await Future.delayed(
                            const Duration(milliseconds: 100),
                          );
                          setState(() {
                            isHobarGpsPressed = false;
                          });

                          Get.to(() => JobcardScreen());
                        },

                        child: Container(
                          height: 45,
                          width: 110,
                          decoration: BoxDecoration(
                            color: isHobarGpsPressed
                                ? Color(0xFFCAF9FC) // 👈 only this changes
                                : Colors.white,
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

                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/gps.png",
                                height: 20,
                                width: 20,
                              ),
                              Text(
                                "GPS",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Jobcard button
                      GestureDetector(
                        onTap: () async {
                          Get.to(() => JobcardScreen());
                        },
                        child: Container(
                          height: 45,
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
                          padding: const EdgeInsets.all(1.5),

                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/jobcard.png",
                                height: 20,
                                width: 20,
                              ),
                              Text(
                                "Job Card",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // report buttton
                      GestureDetector(
                        onTap: () async {
                          var res = await Get.to(() => PasswordScreen());
                          if (res == true) {
                            Get.to(() => ReportScreen());
                          }
                        },
                        child: Container(
                          height: 45,
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
                          padding: const EdgeInsets.all(1.5),

                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 3),

                                Image.asset(
                                  "assets/images/report.png",
                                  height: 17,
                                  width: 17,
                                ),
                                Text(
                                  "Report",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // phonebook button
                      GestureDetector(
                        onTap: () async {
                          Get.to(() => PhonebookButton());
                        },
                        child: Container(
                          height: 45,
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
                          padding: const EdgeInsets.all(1.5),

                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 3),
                                Image.asset(
                                  "assets/images/phonebook.png",
                                  height: 17,
                                  width: 17,
                                ),
                                Text(
                                  "Phone Book",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Calendar buttton
                      GestureDetector(
                        onTap: () async {
                          Get.to(() => CalendarButtonScreen());
                        },
                        child: Container(
                          height: 45,
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
                          padding: const EdgeInsets.all(1.5),

                          child: Column(
                            children: [
                              SizedBox(height: 3),
                              Image.asset(
                                "assets/images/calendar.png",
                                height: 17,
                                width: 17,
                              ),
                              Text(
                                "Calendar",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // phonebook button
                      GestureDetector(
                        onTap: () async {
                          Get.offAll(() => LeaveInfoScreen());
                        },
                        child: Container(
                          height: 45,
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
                          padding: const EdgeInsets.all(1.5),

                          child: Column(
                            children: [
                              SizedBox(height: 3),
                              Image.asset(
                                "assets/images/leave.png",
                                height: 17,
                                width: 17,
                              ),
                              Text(
                                "Leave",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // notice button
                      GestureDetector(
                        onTap: () async {
                          Get.to(() => NoticeListScreen());
                        },
                        child: Container(
                          height: 45,
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
                          padding: const EdgeInsets.all(1.5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Image.asset(
                                      "assets/images/notice.png",
                                      height: 20,
                                      width: 20,
                                    ),

                                    if (totalNoticeCount != 0) ...[
                                      Positioned(
                                        right: -50,
                                        top: -9,
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 25,
                                            minHeight: 25,
                                          ),
                                          child: Center(
                                            child: Text(
                                              totalNoticeCount.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                height: 1.0, // text center
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),

                                const Text(
                                  "Notice",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              ///////////////////
              SizedBox(height: 25),
              Text(
                formattedTime.toString(),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),

              Container(
                height: 87,
                width: double.infinity,
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

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                        top: 5,
                        left: 30,
                      ),
                      child: Row(
                        children: [
                          Spacer(),
                          Text(
                            "Current Location",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),

                          Spacer(),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                address = "Loading...";
                                // Optional: show loading
                              });
                              await _fetchLocationAndAddress();
                            },
                            child: Icon(
                              Icons.refresh,
                              size: 25,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Center(
                      child: Container(
                        height: 1,
                        width: 120, //
                        color: const Color(0xFF8F66DC),
                      ),
                    ),

                    SizedBox(height: 5),

                    Column(
                      children: [
                        Center(
                          child: Text(
                            maxLines: 3,
                            address,

                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Verson 1.20", // Removed space for a sleeker look
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.deepPurple.shade300,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<bool> checkImageMatch(
  //   File capturedFile,
  //   String profileImageUrl,
  // ) async {
  //   try {
  //     // ১. image dwonload because its url
  //     var response = await http.get(Uri.parse(profileImageUrl));
  //     if (response.statusCode != 200) return false;

  //     // ২. ইমেজ দুটিকে কম্পেয়ার করা
  //     // PixelMatching অ্যালগরিদম ব্যবহার করে ৯৫% এর বেশি মিল আছে কিনা দেখা
  //     double difference = await compareImages(
  //       src1: capturedFile,
  //       src2: response.bodyBytes,
  //       algorithm: PixelMatching(),
  //     );

  //     // difference ০ মানে ১০০% মিল, ১ মানে কোনো মিল নেই।
  //     // আমরা ধরে নিচ্ছি ০.১৫ এর কম মানে ছবি মোটামুটি একই (৮৫% মিল)
  //     if (difference < 0.15) {
  //       return true; // Match found
  //     } else {
  //       return false; // Not a match
  //     }
  //   } catch (e) {
  //     print("Error comparing images: $e");
  //     return false;
  //   }
  // }

  // Future<File?> _openCamera() async {
  //   try {
  //     final pickedFile = await ImagePicker().pickImage(
  //       source: ImageSource.camera,
  //       preferredCameraDevice: CameraDevice.front,
  //       imageQuality: 25,
  //       maxWidth: 600,
  //       maxHeight: 600,
  //     );

  //     if (pickedFile != null) {
  //       File file = File(pickedFile.path);
  //       setState(() {
  //         image = file;
  //       });
  //       return file;
  //     }
  //   } catch (e) {
  //     print("Camera Error: $e");
  //   }
  //   return null;
  // }

  // Future<bool> savePostAttendance(
  //   String sourceType,
  //   double lat,
  //   double lng,
  // ) async {
  //   if (inprogrssattendance) return false;

  //   inprogrssattendance = true;
  //   if (mounted) setState(() {});
  //   try {
  //     String? wifiName = await info.getWifiName();
  //     String? mackaddress = await info.getWifiBSSID();
  //     DateTime utcTime = await NTP.now();
  //     String locationName = await getLocationName(lat, lng);
  //     String inTimeDisplay = DateFormat('HH:mm:ss').format(utcTime.toLocal());
  //     String cleanedWifiName = wifiName?.replaceAll('"', '') ?? '';

  //     final user = AuthController.userModel!;

  //     final Map<String, dynamic> requestBody = {
  //       "company_id": user.companyid,
  //       "emp_id": user.empoloyeeid,
  //       "source": sourceType,
  //       "latitude": lat,
  //       "longitude": lng,
  //       "attn_date": DateFormat('yyyy-MM-dd').format(utcTime),
  //       "address": locationName,
  //       "network_name": cleanedWifiName,
  //       "mac_address": mackaddress,
  //       "entry_time": inTimeDisplay,
  //     };

  //     ApiResponse response = await NetworkCaller.postRequest(
  //       url: Urls.savepostattendancetUrl,
  //       body: requestBody,
  //       token: AuthController.accessToken,
  //     );

  //     // --- EKHANE CHECK KORTE HOBE ---
  //     if (!mounted) return false;

  //     if (response.isSuccess && response.responseData["success"] == true) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           duration: const Duration(seconds: 2),
  //           backgroundColor: Color(0xFF00A8AA),

  //           content: Center(
  //             child: Text(
  //               response.errorMessage,
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //       return true; // ✅ MUST
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           duration: const Duration(seconds: 2),
  //           backgroundColor: Colors.red,
  //           content: Center(
  //             child: Text(
  //               response.errorMessage,
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //       return false; // ✅ MUST
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return false; // ✅ MUST
  //   } finally {
  //     // --- FINALLY TE O CHECK LAGBE ---
  //     if (mounted) {
  //       inprogrssattendance = false;
  //       setState(() {});
  //     }
  //   }
  // }

  // // Permisson location Function
  // Future<bool> isPermissionLocation() async {
  //   // 🔹 Ask for location permission (needed for WiFi SSID & BSSID on Android 10+)
  //   var status = await Permission.location.request();
  //   if (status.isDenied || status.isPermanentlyDenied) {
  //     print("Location Permission Denied! Cannot collect network info.");
  //   }
  //   return status.isGranted;
  // }

  // // WIFI NAME functions
  // Future<bool> isWifiName() async {
  //   final NetworkInfo info = NetworkInfo();

  //   String? wifi = await info.getWifiName();
  //   if (wifi == null) return false;
  //   print("WiFi not connected");
  //   return wifi.startsWith("TSEBD.COM");
  // }

  // // mackaddress functions
  // Future<bool> isMackAddressName() async {
  //   final NetworkInfo info = NetworkInfo();
  //   String? mac = await info.getWifiBSSID();
  //   if (mac == null) return false;
  //   return mac.startsWith(
  //     "84:d8:1b:07:0d:0e",
  //   ); //  router  d8:5d:4c:bf:60:16  // code 84:d8:1b:07:0d:0e
  // }

  // // Combined function: GPS + address
  // Future<void> _fetchLocationAndAddress() async {
  //   try {
  //     // 1️⃣ GPS permission & service check
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       setState(() => address = "Please Trun On location");
  //       return;
  //     }

  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         setState(() => address = "Location permission denied");
  //         return;
  //       }
  //     }
  //     if (permission == LocationPermission.deniedForever) {
  //       setState(() => address = "Location permission permanently denied");
  //       return;
  //     }

  //     // 2️⃣ Get GPS coordinates
  //     Position pos = await Geolocator.getCurrentPosition(
  //       // ignore: deprecated_member_use
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     double lat = pos.latitude;
  //     double long = pos.longitude;

  //     setState(() {
  //       curlat = lat;
  //       curlong = long;
  //     });

  //     // 3️⃣ Fetch address
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       curlat!,
  //       curlong!,
  //     );

  //     if (placemarks.isNotEmpty) {
  //       Placemark first = placemarks.first;
  //       setState(() {
  //         address =
  //             "${first.street ?? ''}, ${first.subLocality ?? ''}, ${first.locality ?? ''}";
  //       });
  //     } else {
  //       setState(() => address = "No address found");
  //     }
  //   } catch (e) {
  //     print("Error fetching location or address: $e");
  //     setState(() => address = "Error fetching location");
  //   }
  // }
  // // Combined function: GPS + address

  // // .................................

  // Future<String> getLocationName(double? latitude, double? longitude) async {
  //   if (latitude == null || longitude == null) {
  //     return "Invalid Coordinates";
  //   }
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       latitude,
  //       longitude,
  //     );
  //     if (placemarks.isNotEmpty) {
  //       Placemark first = placemarks.first;
  //       String address =
  //           " ${first.street},"
  //           " ${first.subLocality},"
  //           " ${first.locality}";

  //       return address;
  //     } else {
  //       return "No location found";
  //     }
  //   } catch (e) {
  //     print("Error during geocoding: $e");
  //     return "Error";
  //   }
  // }

  // // current location latitude longitude
  // Future<void> getCurrentLocation() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) return;
  //   }

  //   if (permission == LocationPermission.deniedForever) return;

  //   Position pos = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );

  //   setState(() {
  //     latitude = pos.latitude;
  //     longitude = pos.longitude;
  //   });
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   utcTimer?.cancel();
  //   super.dispose();
  // }

  Future<bool> savePostAttendance(
    String sourceType,
    double lat,
    double lng, {
    String lateNote = "",
    String earlyNote = "",
  }) async {
    if (inprogrssattendance) return false;
    inprogrssattendance = true;
    if (mounted) setState(() {});
    try {
      String? wifiName = await info.getWifiName();
      String? mackaddress = await info.getWifiBSSID();
      DateTime utcTime = await NTP.now();
      String locationName = await getLocationName(lat, lng);
      String inTimeDisplay = DateFormat('HH:mm:ss').format(utcTime.toLocal());
      String cleanedWifiName = wifiName?.replaceAll('"', '') ?? '';

      final user = AuthController.userModel!;

      final Map<String, dynamic> requestBody = {
        "company_id": user.companyid,
        "emp_id": user.empoloyeeid,
        "source": sourceType,
        "latitude": lat,
        "longitude": lng,
        "attn_date": DateFormat('yyyy-MM-dd').format(utcTime),
        "address": locationName,
        "network_name": cleanedWifiName,
        "mac_address": mackaddress,
        "entry_time": inTimeDisplay,
        "late_in_note": lateNote,
        "early_out_note": earlyNote,
      };

      ApiResponse response = await NetworkCaller.postRequest(
        url: Urls.savepostattendancetUrl,
        body: requestBody,
        token: AuthController.accessToken,
      );

      // --- EKHANE CHECK KORTE HOBE ---
      if (!mounted) return false;

      // check early or late
      final bool requiresLate =
          response.responseData["requires_late_in_note"] ?? false;

      final bool requiresEarly =
          response.responseData["requires_early_out_note"] ?? false;

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
        return true; // ✅ MUST
      }

      /// LATE NOTE REQUIRED
      if (requiresLate && lateNote.isEmpty) {
        _lateInErlyoutNoteController.clear();

        bool? confirm = await showAttendanceConfirmDialog(
          context,
          _lateInErlyoutNoteController,
          "Late In Reason",
          "Late In Reason...",
        );

        if (confirm != true) {
          return false;
        }

        inprogrssattendance = false;

        return await savePostAttendance(
          sourceType,
          lat,
          lng,
          lateNote: _lateInErlyoutNoteController.text.trim(),
          earlyNote: earlyNote,
        );
      }

      /// EARLY NOTE REQUIRED
      if (requiresEarly && earlyNote.isEmpty) {
        _lateInErlyoutNoteController.clear();

        bool? confirm = await showAttendanceConfirmDialog(
          context,
          _lateInErlyoutNoteController,
          "Early Out Reason",
          "Early Out Reason...",
        );

        if (confirm != true) {
          return false;
        }

        inprogrssattendance = false;

        return await savePostAttendance(
          sourceType,
          lat,
          lng,
          lateNote: lateNote,
          earlyNote: _lateInErlyoutNoteController.text.trim(),
        );
      }
      //  else
      else {
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
        return false; // ✅ MUST
      }
    } catch (e) {
      debugPrint(e.toString());
      return false; // ✅ MUST
    } finally {
      // --- FINALLY TE O CHECK LAGBE ---
      if (mounted) {
        inprogrssattendance = false;
        setState(() {});
      }
    }
  }

  // Permisson location Function
  Future<bool> isPermissionLocation() async {
    // 🔹 Ask for location permission (needed for WiFi SSID & BSSID on Android 10+)
    var status = await Permission.location.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      print("Location Permission Denied! Cannot collect network info.");
    }
    return status.isGranted;
  }

  // WIFI NAME functions
  Future<bool> isWifiName() async {
    final NetworkInfo info = NetworkInfo();

    String? wifi = await info.getWifiName();
    if (wifi == null) return false;
    print("WiFi not connected");
    return wifi.startsWith("TSEBD.COM");
  }

  // mackaddress functions
  Future<bool> isMackAddressName() async {
    final NetworkInfo info = NetworkInfo();
    String? mac = await info.getWifiBSSID();
    if (mac == null) return false;
    return mac.startsWith(
      "84:d8:1b:07:0d:0e",
    ); //  router  d8:5d:4c:bf:60:16  // code 84:d8:1b:07:0d:0e
  }

  // Combined function: GPS + address
  Future<void> _fetchLocationAndAddress() async {
    try {
      // 1️⃣ GPS permission & service check
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => address = "Please Turn On location");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) setState(() => address = "Location permission denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted)
          // ignore: curly_braces_in_flow_control_structures
          setState(() => address = "Location permission permanently denied");
        return;
      }

      // 2️⃣ Get GPS coordinates
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double lat = pos.latitude;
      double long = pos.longitude;

      // Check mounted before modifying state after async gap
      if (!mounted) return;
      setState(() {
        curlat = lat;
        curlong = long;
      });

      // 3️⃣ Fetch address
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      if (!mounted) return;

      if (placemarks.isNotEmpty) {
        Placemark first = placemarks.first;
        setState(() {
          address =
              "${first.street ?? ''}, ${first.subLocality ?? ''}, ${first.locality ?? ''}";
        });
      } else {
        setState(() => address = "No address found");
      }
    } catch (e) {
      if (mounted) setState(() => address = "Error fetching location");
    }
  }

  // Combined function: GPS + address

  // location name
  Future<String> getLocationName(double? latitude, double? longitude) async {
    if (latitude == null || longitude == null) {
      return "Invalid Coordinates";
    }
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark first = placemarks.first;
        String address =
            " ${first.street},"
            " ${first.subLocality},"
            " ${first.locality}";

        return address;
      } else {
        return "No location found";
      }
    } catch (e) {
      print("Error during geocoding: $e");
      return "Error";
    }
  }

  // current location latitude longitude
  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      latitude = pos.latitude;
      longitude = pos.longitude;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    utcTimer?.cancel();
    _lateInErlyoutNoteController.dispose();
    super.dispose();
  }

  // check late early
  Future<bool?> showAttendanceConfirmDialog(
    BuildContext context,
    TextEditingController explainController,
    String text,
    String hintText,
  ) async {
    // ফর্ম ভ্যালিডেশনের জন্য একটি গ্লোবাল কি
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Color(0xFF3F51B5),
            width: 1.5,
          ), // নীল আউটলাইন বর্ডার
        ),
        title: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A4A4A),
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: explainController,
                  minLines: 3, // ইমেজের মতো বক্সের হাইট দেওয়ার জন্য
                  maxLines: 5,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Colors.black26),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(12),
                    // ইমেজের মতো চারপাশের চিকন নীল বর্ডার
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        color: Color(0xFF3F51B5),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        color: Color(0xFF3F51B5),
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1.5,
                      ),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your explanation";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actionsAlignment:
            MainAxisAlignment.center, // বাটনগুলো সেন্টারে রাখার জন্য
        actionsPadding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
        actions: [
          // Submit Button (Purple)
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(
                  context,
                  true,
                ); // ভ্যালিডেশন সাকসেস হলে true রিটার্ন করবে
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C5CE7), // পার্পল কালার
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              "Submit",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8), // বাটন দুটির মাঝের গ্যাপ
          // Cancel Button (Grey)
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C757D), // গ্রে কালার
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
