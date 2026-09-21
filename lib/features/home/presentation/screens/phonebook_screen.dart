import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/screens/main_nav_holder.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/home/data/models/phone_book_model.dart';
import 'package:devsalesxpert/features/home/presentation/screens/employee_jobcard.dart';
import 'package:url_launcher/url_launcher.dart';

// Date Formatting
class PhonebookButton extends StatefulWidget {
  final int fromTabIndex;
  const PhonebookButton({super.key, this.fromTabIndex = 0});

  @override
  State<PhonebookButton> createState() => _PhonebookButtonState();
}

class _PhonebookButtonState extends State<PhonebookButton> {
  List<PhoneBookModel> _phonebooklist = [];
  bool inprogresssphonebook = false;

  // phone book get api
  Future<void> _getPhonebook() async {
    inprogresssphonebook = true;
    setState(() {});

    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.phonebookUrl,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      final phonebookdata = response.responseData;

      for (Map<String, dynamic> phonebookjson in phonebookdata['data']) {
        final phonemodelall = PhoneBookModel.fromJson(phonebookjson);
        _phonebooklist.add(phonemodelall);
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
      inprogresssphonebook = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _getPhonebook();
    super.initState();
  }

  // for sms function
  Future<void> _sendSMS(String phoneNumber) async {
    final Uri smsLaunchUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(smsLaunchUri)) {
      await launchUrl(smsLaunchUri);
    }
  }

  // for call function
  Future<void> _makeCall(String phoneNumber) async {
    final Uri callLaunchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callLaunchUri)) {
      await launchUrl(callLaunchUri);
    }
  }

  // for whatsapp function
  Future<void> _launchWhatsApp(String phoneNumber) async {
    String formattedNumber = phoneNumber.startsWith('+88')
        ? phoneNumber
        : '+88$phoneNumber';
    // formate for whatspp
    var whatsappUrl = "whatsapp://send?phone=$formattedNumber&text";
    final Uri whatsappUri = Uri.parse(whatsappUrl);

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      print("WhatsApp not installed");
    }
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
          "Phone Book",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: ScreenBackground(
        child: Visibility(
          visible: inprogresssphonebook == false,
          replacement: Center(child: CustomCircularProgressIndicator()),
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(),
            itemCount: _phonebooklist.length,
            itemBuilder: (context, index) {
              var item = _phonebooklist[index];

              return GestureDetector(
                onTap: () {
                  Get.to(() => EmployeeJobcardScreen(employeeID: item.id));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Card(
                    color: Colors.white,
                    elevation: 6,
                    shadowColor: Colors.black.withOpacity(0.9),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 12,
                      ),
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Row(
                            children: [
                              Container(
                                height: 100,
                                width: 100,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    // Example: Fully opaque blue (#007AFF)
                                    color: Colors.grey.shade200,
                                    width: 2.0,
                                  ),

                                  image: DecorationImage(
                                    image: NetworkImage(
                                      Uri.encodeFull(item.image),
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),

                              SizedBox(width: 10),

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        item.employeename,
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        item.designation,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),

                                      Text(
                                        item.department,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        item.companyname,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: 2),

                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          children: [
                                            TextSpan(text: "Mobile: "),

                                            TextSpan(
                                              text: item.mobile,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 2),

                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          children: [
                                            TextSpan(text: "WhatsApp: "),

                                            TextSpan(
                                              text:
                                                  item.whatsapp ??
                                                  "Not Available",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Text(
                                        item.email,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              Colors.blue, // লাইনের কালার
                                          decorationThickness: 2,

                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),

                                      SizedBox(height: 5),

                                      ///////////////////////////////////////////////
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () => _sendSMS(item.mobile),
                                            child: Icon(
                                              Icons.message,
                                              size: 30,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          InkWell(
                                            onTap: () => _makeCall(item.mobile),
                                            child: Icon(
                                              Icons.call,
                                              size: 30,
                                              color: Colors.green,
                                            ),
                                          ),
                                          SizedBox(width: 20),

                                          InkWell(
                                            onTap: () => _launchWhatsApp(
                                              item.whatsapp ?? item.mobile,
                                            ),
                                            child: Image.asset(
                                              "assets/images/whatsapp.png",
                                              height: 25,
                                              width: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      // bottomNavigationBar:  CustomBottomNavigationBar(currentIndex: widget.fromTabIndex)
    );
  }
}
