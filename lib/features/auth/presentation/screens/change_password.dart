import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/screens/main_nav_holder.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/profile/presentation/screens/profile_screen.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldpasswordcontroller = TextEditingController();
  final TextEditingController _newpasswordcontroller = TextEditingController();
  final TextEditingController _confirmpasswordcontroller =
      TextEditingController();

  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool inprogressUpdatepassword = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.back(result: () => ProfileScreen());
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),

        title: Text(
          "Change Password",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: ScreenBackground(
        child: Form(
          key: _fromKey,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.15),

                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "Sales Xpert",
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xFF7F2AFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  ///    /////////////////////////////////////////////////
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 18,
                        right: 18,
                        bottom: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Old Password",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          SizedBox(height: 3),

                          TextFormField(
                            controller: _oldpasswordcontroller,
                            obscureText: _obscurePassword,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              isDense: true,

                              hintText: "Enter Old Password",
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
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

                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "enter the old password";
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 10),

                          Text(
                            "New Password",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          SizedBox(height: 3),

                          TextFormField(
                            controller: _newpasswordcontroller,
                            obscureText: _obscurePassword,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              isDense: true,

                              hintText: "Enter New Password",
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
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

                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "enter the new password";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          Text(
                            "Confirm Password",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          SizedBox(height: 3),

                          TextFormField(
                            controller: _confirmpasswordcontroller,
                            obscureText: _obscurePassword,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              isDense: true,

                              hintText: "Confirm Password",
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
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

                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return "enter the confirm password";
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 10),

                          Visibility(
                            visible: inprogressUpdatepassword == false,
                            replacement: Center(
                              child: CustomCircularProgressIndicator(),
                            ),
                            child: FilledButton(
                              onPressed: () {
                                if (_fromKey.currentState!.validate()) {
                                  _UpdatePassword();
                                }
                              },
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Color(0xFF7F2AFF),
                                minimumSize: const Size(370, 40), //
                              ),
                              child: const Text(
                                "Update Password",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _UpdatePassword() async {
    inprogressUpdatepassword = true;
    setState(() {});

    final Map<String, dynamic> requestBody = {
      "old_password": _oldpasswordcontroller.text.trim(),
      "new_password": _newpasswordcontroller.text.trim(),
      "confirm_password": _confirmpasswordcontroller.text.trim(),
    };

    ApiResponse response = await NetworkCaller.postRequest(
      url: Urls.updatePasswordUrl,
      body: requestBody,
      token: AuthController.accessToken,
    );

    if (response.isSuccess && response.responseData["success"] == true) {
      Get.offAll(() => BottomNavControllerScreen());
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
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

      inprogressUpdatepassword = false;
      setState(() {});
    }
  }
}
