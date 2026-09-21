import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/home/data/models/notices_model.dart';

class NoticeListScreen extends StatefulWidget {
  final int fromTabIndex;
  const NoticeListScreen({super.key, this.fromTabIndex = 0});

  @override
  State<NoticeListScreen> createState() => _NoticeListScreenState();
}

class _NoticeListScreenState extends State<NoticeListScreen> {
  bool inprogresssnotice = false;

  // এটি ইনডেক্স ধরে রাখবে কোন কার্ডগুলো খোলা আছে
  final Set<int> _expandedIndices = {};

  bool isPdf(String url) {
    return url.toLowerCase().endsWith('.pdf');
  }

  final List<NoticesModel> _noticeList = [];
  Future<void> fetchNoticeList() async {
    inprogresssnotice = true;
    setState(() {});
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.noticesUrl,
      token: AuthController.accessToken,
    );
    if (response.isSuccess) {
      _noticeList.clear();

      final noticedata = response.responseData;
      for (Map<String, dynamic> noticejosn in noticedata['data']) {
        final noticegmodelall = NoticesModel.fromJson(noticejosn);
        _noticeList.add(noticegmodelall);
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
    inprogresssnotice = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchNoticeList();
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
        title: Text(
          "Notice List",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: ScreenBackground(
        child: Visibility(
          visible: inprogresssnotice == false,
          replacement: Center(child: CustomCircularProgressIndicator()),
          child: ListView.builder(
            padding: const EdgeInsets.only(
              top: 15,
              left: 16,
              right: 16,
              bottom: 90,
            ),
            itemCount: _noticeList.length,
            itemBuilder: (context, index) {
              // var item = _noticeList[index];
              var item = _noticeList[_noticeList.length - 1 - index];

              // চেক করছি এই ইনডেক্সটি আমাদের Set-এ আছে কি না
              bool isOpen = _expandedIndices.contains(index);

              return Card(
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
                      buildInfoRow(
                        "Publish Date",
                        formatDate(item.publishDate!),
                      ),

                      // ******* 1. Always Visible Content (title, describtion & Toggle Button) *******
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Title : ",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      TextSpan(
                                        text: item.title ?? '',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            icon: Icon(
                              isOpen ? Icons.visibility_off : Icons.visibility,
                              color: Colors.blue,
                            ),

                            onPressed: () {
                              setState(() {
                                if (isOpen) {
                                  _expandedIndices.remove(index); // বন্ধ করো
                                } else {
                                  _expandedIndices.add(index); // খোলো
                                }
                              });
                            },
                          ),
                        ],
                      ),

                      if (isOpen) ...[
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Description : ",

                                style: TextStyle(
                                  color: Colors.blue,

                                  fontSize: 14,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              TextSpan(
                                text: item.description ?? '',

                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),

                        if (item.attachment != null) ...[
                          const Text(
                            "Attachment",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Stack(
                            children: [
                              Container(
                                height:
                                    120, // পিডিএফ এর জন্য একটু ছোট হাইট ভালো লাগে
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: const Color(0xFFCAF9FC),
                                    width: 2,
                                  ),
                                  color: Colors.white,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: isPdf(item.attachment!)
                                      ? _buildPdfPreview(
                                          item.attachment!,
                                        ) // পিডিএফ হলে এটা দেখাবে
                                      : _buildImagePreview(
                                          item.attachment!,
                                        ), // ইমেজ হলে এটা দেখাবে
                                ),
                              ),

                              // dwonload button
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    // dwonload function call
                                    downloadFile(item.attachment!);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.download_rounded,
                                      color: Color(0xFF007AFF),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      // bottomNavigationBar:  CustomBottomNavigationBar(currentIndex: widget.fromTabIndex)

      // History tab
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
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 85,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text("     : ", style: TextStyle(fontWeight: FontWeight.bold)),
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

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "--";

    // ধাপে ধাপে পার্স করার চেষ্টা
    DateTime? dt = DateTime.tryParse(date);

    if (dt == null) {
      try {
        dt = DateFormat('dd-MM-yyyy').parse(date);
      } catch (_) {
        return "--"; // কোনোভাবেই পার্স করা না গেলে
      }
    }

    return DateFormat('dd-MM-yyyy').format(dt);
  }

  // for image
  Widget _buildImagePreview(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, color: Colors.grey),
            Text(
              "Image Not Found",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // for pdf
  Widget _buildPdfPreview(String url) {
    String fileName = url.split('/').last;
    return Container(
      color: Colors.red.withOpacity(0.05),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.picture_as_pdf, color: Colors.red, size: 40),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // image pdf dwonload function
  Future<void> downloadFile(String url) async {
    try {
      bool permissionGranted = true;

      // 🔴 অ্যান্ড্রয়েড ৯ বা তার নিচে (SDK < 29) হলে কেবল স্টোরেজ পারমিশন লাগবে
      if (Platform.isAndroid) {
        final deviceInfo = await DeviceInfoPlugin().androidInfo;
        if (deviceInfo.version.sdkInt < 29) {
          var status = await Permission.storage.request();
          permissionGranted = status.isGranted;
        }
      }

      if (!permissionGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFF00A8AA),
            content: Center(
              child: Text(
                "Storage permission denied",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
        return;
      }

      // 📥 ডাউনলোড স্টার্ট মেসেজ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF00A8AA),
          content: Center(
            child: Text(
              "Downloading...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;

      if (isPdf(url)) {
        final fileName = "Notice_${DateTime.now().millisecondsSinceEpoch}.pdf";
        Directory? directory;

        if (Platform.isAndroid) {
          directory = Directory('/storage/emulated/0/Download');
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        final filePath = "${directory.path}/$fileName";
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFF00A8AA),
            content: Center(
              child: Text(
                "PDF Saved to Downloads!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      } else {
        // 🖼️ MediaStore ব্যবহার করায় Android 10+ এ পারমিশন ছাড়াই গ্যালারিতে সেভ হবে
        final result = await ImageGallerySaverPlus.saveImage(
          Uint8List.fromList(bytes),
          quality: 100,
          name: "Notice_Img_${DateTime.now().millisecondsSinceEpoch}",
        );

        if (result['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Color(0xFF00A8AA),
              content: Center(
                child: Text(
                  "Image Saved to Gallery!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF00A8AA),
          content: Center(
            child: Text(
              "Download Failed!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }

  // Future<void> downloadFile(String url) async {
  //   try {
  //     // ১. পারমিশন চেক (Android Version অনুযায়ী)
  //     bool permissionGranted = false;

  //     if (Platform.isAndroid) {
  //       final deviceInfo = await DeviceInfoPlugin().androidInfo;

  //       if (deviceInfo.version.sdkInt >= 33) {
  //         // Android 13+ এর জন্য
  //         if (isPdf(url)) {
  //           // PDF এর জন্য সাধারণত পারমিশন লাগে না যদি আপনি getExternalStorageDirectory ব্যবহার করেন
  //           permissionGranted = true;
  //         } else {
  //           var status = await Permission.photos.request();
  //           permissionGranted = status.isGranted;
  //         }
  //       } else {
  //         // Android 12 বা তার নিচের জন্য
  //         var status = await Permission.storage.request();
  //         permissionGranted = status.isGranted;
  //       }
  //     }

  //     if (!permissionGranted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           duration: const Duration(seconds: 2),
  //           backgroundColor: Color(0xFF00A8AA),
  //           content: Center(
  //             child: Text(
  //               "Storage/Gallery permission denied",
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //       return;
  //     }

  //     // 2 dwonload start

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         duration: const Duration(seconds: 2),
  //         backgroundColor: Color(0xFF00A8AA),
  //         content: Center(
  //           child: Text(
  //             "Downloading...",
  //             style: TextStyle(
  //               fontSize: 18,
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ),
  //     );

  //     final response = await http.get(Uri.parse(url));
  //     final bytes = response.bodyBytes;

  //     if (isPdf(url)) {
  //       // ৩. PDF সেভ করার লজিক (Download ফোল্ডারে)
  //       final fileName = "Notice_${DateTime.now().millisecondsSinceEpoch}.pdf";
  //       Directory? directory;

  //       if (Platform.isAndroid) {
  //         directory = Directory('/storage/emulated/0/Download');
  //       } else {
  //         directory = await getApplicationDocumentsDirectory();
  //       }

  //       final filePath = "${directory.path}/$fileName";
  //       final file = File(filePath);
  //       await file.writeAsBytes(bytes);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           duration: const Duration(seconds: 2),
  //           backgroundColor: Color(0xFF00A8AA),
  //           content: Center(
  //             child: Text(
  //               "PDF Saved to Downloads!",
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     } else {
  //       // ৪. ইমেজ সেভ করার লজিক (গ্যালারিতে)
  //       final result = await ImageGallerySaverPlus.saveImage(
  //         Uint8List.fromList(bytes),
  //         quality: 100,
  //         name: "Notice_Img_${DateTime.now().millisecondsSinceEpoch}",
  //       );

  //       if (result['isSuccess']) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             duration: const Duration(seconds: 2),
  //             backgroundColor: Color(0xFF00A8AA),
  //             content: Center(
  //               child: Text(
  //                 "Image Saved to Gallery!",
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     print("Download Error: $e");

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         duration: const Duration(seconds: 2),
  //         backgroundColor: Color(0xFF00A8AA),
  //         content: Center(
  //           child: Text(
  //             "Download Failed!",
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
  // }
}
