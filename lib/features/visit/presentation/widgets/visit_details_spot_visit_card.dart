import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/visit/data/models/purpose_drop_dwon_model.dart';
import 'package:devsalesxpert/features/visit/data/models/visit_and_spot_visit_usermodel.dart';
import 'package:devsalesxpert/features/visit/presentation/screens/spot_visit_entry.dart';
import 'package:devsalesxpert/features/visit/presentation/screens/spot_visit_update_screen.dart';

class VisitDetailsSpotVisitCard extends StatefulWidget {
  final VisitSpotModel item;
  final VoidCallback? onVisitEnd;

  const VisitDetailsSpotVisitCard({
    super.key,
    required this.item,
    this.onVisitEnd,
  });

  @override
  State<VisitDetailsSpotVisitCard> createState() =>
      _VisitDetailsSpotVisitCardState();
}

class _VisitDetailsSpotVisitCardState extends State<VisitDetailsSpotVisitCard> {
  double? curlat;
  double? curlong;
  String curAddress = "";

  bool inprogresssvisitspotstrore = false;
  bool inprogrssspotView = false;

  bool _isButtonVisible = true;
  bool _isEditButtonVisible = true;

  @override
  void initState() {
    super.initState();

    // If the main visit is already complete, there is no need to show the button.
    if (widget.item.status == "Completed") {
      _isButtonVisible = false;
      _isEditButtonVisible = false;
    }
    _fetchpurposeList();
    _fetchSpotList();
    _fetchLocationAndAddress();
  }

  // purpose get api
  final List<PurposeModel> _purposeNameList = [];
  PurposeModel? selectedPurpose;
  Future<void> _fetchpurposeList() async {
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.purposefromUrl,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      final purposeData = response.responseData;
      for (Map<String, dynamic> purposeJson in purposeData['data']) {
        final purposeModelall = PurposeModel.fromJson(purposeJson);
        _purposeNameList.add(purposeModelall);
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
  }

  // spot get api
  final List<VisitSpotModel> _spotList = [];
  VisitSpotModel? selectedSpotVisit;
  Future<void> _fetchSpotList() async {
    inprogrssspotView = true;
    setState(() {});

    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.visitSpotGetUrl(widget.item.id.toString()),
      token: AuthController.accessToken,
    );

    if (response.isSuccess == true &&
        response.responseData['success'] == true) {
      final data = response.responseData['data'];

      final List spotsdata = data['spots'] ?? [];

      _spotList.clear(); // 🔴 MUST

      for (final spotJson in spotsdata) {
        _spotList.add(
          VisitSpotModel.fromSpotJson(spotJson as Map<String, dynamic>),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Center(
            child: Text(
              response.errorMessage,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    if (!mounted) return;

    inprogrssspotView = false;
    setState(() {});
  }

  Future<void> _callEndApi() async {
    // Date format according to server requirements
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    Map<String, dynamic> body = {
      "visit_id": widget.item.id.toString(),
      "company_id": AuthController.userModel!.companyid,
      "employee_id": AuthController.userModel!.empoloyeeid,
      "actual_visit_date": currentDate,
      "actual_visit_end_time": DateFormat('HH:mm:ss').format(DateTime.now()),
      "end_latitude": curlat,
      "end_longitude": curlong,
      "end_address": curAddress,
      "actual_visit_end_date": currentDate,
    };

    ApiResponse response = await NetworkCaller.postRequest(
      url: Urls.visitcompleteUrl(
        widget.item.id.toString(),
      ), // Make sure it's in the Urls file.
      body: body,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      setState(() {
        _isButtonVisible = false;
        _isEditButtonVisible = false; // Hide the button
      });

      if (response.isSuccess) {
        if (widget.onVisitEnd != null) {
          widget.onVisitEnd!();
        }

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF00A8AA),
            content: Center(
              child: Text(
                "Visit Ended Successfully!",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.9),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Spot Visit Details",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.pink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.expand_less, color: Colors.grey[600]),
              ],
            ),

            // -------- Visit History Time Section --------
            const SizedBox(height: 10),

            Visibility(
              visible: inprogrssspotView == false,
              replacement: Center(child: CustomCircularProgressIndicator()),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _spotList.length,
                itemBuilder: (context, index) {
                  var item = _spotList[index];

                  return _buildSpotVisitContainer(item);
                },
              ),
            ),

            const SizedBox(height: 10),

            (_isButtonVisible && widget.item.status != "Completed")
                ? // button spt close
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 35,
                          width: 150,
                          child: FilledButton(
                            onPressed: () async {
                              var result = await Get.to(
                                () => SpotVisitEntry(item: widget.item),
                              );

                              if (result == true) {
                                _fetchSpotList();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>((
                                    states,
                                  ) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors.orange;
                                    }
                                    return const Color(0xFF7F2AFF);
                                  }),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              minimumSize: WidgetStateProperty.all(
                                const Size(370, 50),
                              ),
                              overlayColor: WidgetStateProperty.all(
                                Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              "Spot Visit",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 4),

                      Expanded(
                        child: SizedBox(
                          height: 35,
                          width: 150,
                          child: FilledButton(
                            onPressed: () async {
                              bool? confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Close Spot Visit"),
                                  content: Text(
                                    "Are you sure you want to close this spot visit?",
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

                              _callEndApi();
                              setState(() {
                                _isButtonVisible = false;
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color>((
                                    states,
                                  ) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors.orange;
                                    }
                                    return const Color(0xFF7F2AFF);
                                  }),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              minimumSize: WidgetStateProperty.all(
                                const Size(370, 50),
                              ),
                              overlayColor: WidgetStateProperty.all(
                                Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              "Close",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotVisitContainer(VisitSpotModel data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), // প্রতিটি কার্ডের মাঝে গ্যাপ
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Spacer(),

                // image
                GestureDetector(
                  onTap: () {
                    // A dialog will open to enlarge the image.
                    if (data.spotImage != null && data.spotImage!.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              // big iamge
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  data.spotImage!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              // colse button
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 60,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 2.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: data.spotImage!.isEmpty
                          ? const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 40,
                              ),
                            )
                          : Image.network(
                              data.spotImage ?? "",
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ),

                Spacer(),
                if (_isEditButtonVisible)
                  InkWell(
                    onTap: () async {
                      debugPrint("Navigating to update with ID: ${data.id}");
                      var result = await Get.to(
                        () => SpotVisitUpdate(item: data, iD: widget.item),
                      );

                      if (result == true) {
                        _fetchSpotList();
                      }
                    },
                    child: Icon(Icons.edit, color: Colors.deepPurpleAccent),
                  ),
              ],
            ),
            buildInfoRow("Time", formatTimeAmPm(data.spotCreatedAt ?? " ")),
            buildInfoRow("Customer", data.spotClientName ?? ''),
            buildInfoRow("Contact", data.spotContactPerson ?? ''),
            buildInfoRow("Mobile No.", data.spotContactPersonMobile ?? ''),
            buildInfoRow("Address", data.spotVisitTo ?? ''),
            buildInfoRow("Transport", data.spotVehicleType ?? ''),
            buildInfoRow("Conveyance", "${data.spotVehicleBill ?? ''} Tk"),
            buildInfoRow("Purpose", data.spotVisitPurpose ?? ''),
            buildInfoRow("Feedback", data.spotremarks ?? ''),
          ],
        ),
      ),
    );
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "N/A";
    try {
      DateTime inputDate = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(inputDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  String formatTimeAmPm(String rawDateTime) {
    DateTime dateTime = DateTime.parse(rawDateTime);
    return DateFormat('hh:mm a').format(dateTime);
  }

  // widget
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: TextStyle(fontSize: 12)),
          ),
          Text(
            " : ",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Combined function: GPS + address
  Future<void> _fetchLocationAndAddress() async {
    try {
      // 1️⃣ GPS permission & service check
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => curAddress = "Location services are disabled");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => curAddress = "Location permission denied");
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => curAddress = "Location permission permanently denied");
        return;
      }

      // 2️⃣ Get GPS coordinates
      Position pos = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );

      double lat = pos.latitude;
      double long = pos.longitude;

      setState(() {
        curlat = lat;
        curlong = long;
      });

      // 3️⃣ Fetch address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        curlat!,
        curlong!,
      );

      if (placemarks.isNotEmpty) {
        Placemark first = placemarks.first;
        setState(() {
          curAddress =
              "${first.street ?? ''}, ${first.subLocality ?? ''}, ${first.locality ?? ''}";
        });
      } else {
        setState(() => curAddress = "No address found");
      }
    } catch (e) {
      print("Error fetching location or address: $e");
      setState(() => curAddress = "Error fetching location");
    }
  }
}
