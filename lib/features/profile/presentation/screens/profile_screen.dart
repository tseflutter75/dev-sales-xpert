import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/auth/presentation/screens/change_password.dart';
import 'package:devsalesxpert/features/auth/presentation/screens/login_screen.dart';
import 'package:devsalesxpert/features/common/presentation/screens/main_nav_holder.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/profile/presentation/screens/track_employee_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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

        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: ScreenBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 👤 Profile section
              Row(
                children: [
                  // --- Instagram Style Gradient Frame ---
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          Color(0xFF9161FF),
                          Color(0xFFFFF9D0),
                          Color(0xFFFFF9D0),
                          Colors.pinkAccent,
                          Colors.blue,
                          Color(0xFF9161FF),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: Offset(
                            0,
                            6,
                          ), // Shadow-ke niche namiye 3D effect dey (x, y)
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(
                            0xFF81E9FF,
                          ), // Apnar blue background code
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            Uri.encodeFull(
                              AuthController.userModel?.image ?? "",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 16),

                  // --- User Info ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AuthController.userModel?.nameenglish ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        AuthController.userModel?.email ?? "",
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),

              // Row(
              //   children: [
              //     CircleAvatar(
              //       radius: 30,
              //       backgroundImage: NetworkImage(
              //         Uri.encodeFull(AuthController.userModel?.image ?? ""),
              //       ),
              //     ),
              //     SizedBox(width: 16),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         //  AuthController.userModel?.fullName ?? ''
              //         Text(
              //           AuthController.userModel?.username ?? "",
              //           style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         Text(
              //           AuthController.userModel?.email ?? "",
              //           style: TextStyle(color: Colors.black54),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              const Divider(height: 32, color: Color(0xFF8F66DC)),

              // 🔹 Other options
              // ListTile(
              //   leading: const Icon(
              //     Icons.qr_code_scanner,
              //     color:  Color(0xFF9161FF),
              //   ),
              //   title: const Text(
              //     "Qr Scanner",
              //     style: TextStyle(color: Colors.black),
              //   ),
              //   trailing: const Icon(
              //     Icons.arrow_forward_ios,
              //     size: 18,
              //     color: Colors.black54,
              //   ),
              //   onTap: () {
              //     // Navigate to about page
              //     Get.to(() => QrcodeScannerScreen());
              //   },
              // ),
              // ListTile(
              //   leading: const Icon(Icons.history, color:  Color(0xFF9161FF),),
              //   title: const Text(
              //     "Qr History",
              //     style: TextStyle(color: Colors.black),
              //   ),
              //   trailing: const Icon(
              //     Icons.arrow_forward_ios,
              //     size: 18,
              //     color: Colors.black54,
              //   ),
              //   onTap: () {
              //     // Navigate to about page
              //     Get.to(() => QRHistoryScreen());
              //   },
              // ),
              ListTile(
                leading: const Icon(
                  Icons.track_changes,
                  color: Color(0xFF9161FF),
                ),
                title: const Text(
                  "Track Employee",
                  style: TextStyle(color: Colors.black),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.black54,
                ),
                onTap: () {
                  // Navigate to about page
                  Get.to(() => TrackingScreen());
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFF8F66DC),
                ),
                title: const Text(
                  "Change Password",
                  style: TextStyle(color: Colors.black),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.black54,
                ),
                onTap: () {
                  // Navigate to change password page
                  Get.to(() => ChangePassword());
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: _signOut,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _signOut() async {
  //   await AuthController.clearUserData();
  //   Get.offAll(() => LoginScreen());
  // }

  Future<void> _signOut() async {
    await Future.delayed(const Duration(seconds: 1));

    await AuthController.clearUserData();

    Get.offAll(() => LoginScreen());
  }
}
