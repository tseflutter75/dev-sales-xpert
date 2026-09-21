import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/visit/data/models/client_type_drop_dwon_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerListScreen extends StatefulWidget {
  final int fromTabIndex;
  const CustomerListScreen({super.key, this.fromTabIndex = 3});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  bool inprogresssClient = false;

  // client get api
  final List<ClientTypeModel> _clientNameList = [];
  ClientTypeModel? selectedClient;
  Future<void> _fetchclintList() async {
    inprogresssClient = true;
    setState(() {});
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.clientfromUrl,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      final clienttypeData = response.responseData;
      for (Map<String, dynamic> clienttypeJson in clienttypeData['data']) {
        final clienttypeModelall = ClientTypeModel.fromJson(clienttypeJson);
        _clientNameList.add(clienttypeModelall);
      }
      setState(() {});
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
  void initState() {
    _fetchclintList();
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
        title: Text("Customer List", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: ScreenBackground(
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
                        flex: 1,
                        child: Text(
                          "SL",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 5,
                        child: Text(
                          "Customer Name",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          "Contact Person",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 4,
                        child: Text(
                          "Mobile",

                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          "Action",
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
                  child: Divider(color: Colors.grey.shade200, thickness: 1),
                ),
              ],
            ),

            Expanded(
              child: Visibility(
                visible: inprogresssClient == false,
                replacement: Center(child: CustomCircularProgressIndicator()),
                child: ListView.builder(
                  itemCount: _clientNameList.length,
                  itemBuilder: (context, index) {
                    // final reverseIndex = _datalist.length - 1 - index;
                    var item = _clientNameList[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  (index + 1).toString(),

                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),

                              Expanded(
                                flex: 5,
                                child: Text(
                                  item.name!,

                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),

                              Expanded(
                                flex: 4,
                                child: Text(
                                  item.ownerName!,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),

                              Expanded(
                                flex: 4,
                                child: Text(
                                  item.mobileNo!,

                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),

                              Expanded(
                                flex: 5,
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () => _sendSMS(item.mobileNo!),
                                      child: Icon(
                                        Icons.message,
                                        size: 20,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    InkWell(
                                      onTap: () => _makeCall(item.mobileNo!),
                                      child: Icon(
                                        Icons.call,
                                        size: 20,
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(width: 10),

                                    InkWell(
                                      onTap: () =>
                                          _launchWhatsApp(item.mobileNo!),
                                      child: Image.asset(
                                        "assets/images/whatsapp.png",
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ],
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

      //  bottomNavigationBar: CustomBottomNavigationBar(
      //     currentIndex: widget.fromTabIndex,
      //   ),
    );
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
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          const Text(" : ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
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
