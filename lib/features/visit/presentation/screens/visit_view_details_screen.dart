import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// ignore: library_prefixes

import 'package:intl/intl.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/visit/data/models/transpot_tyep_drop_dwon_model.dart';
import 'package:devsalesxpert/features/visit/data/models/visit_and_spot_visit_usermodel.dart';
import 'package:devsalesxpert/features/visit/presentation/widgets/visit_details_spot_visit_card.dart';
import 'package:devsalesxpert/features/visit/presentation/widgets/visit_details_taphold_card.dart';
import 'package:devsalesxpert/features/visit/presentation/widgets/visit_details_view_card.dart';

class VisitDetailsScreen extends StatefulWidget {
  final VisitSpotModel item;
  final int? index;
  // final int fromTabIndex;

  const VisitDetailsScreen({
    super.key,
    required this.item,
    this.index,
    // this.fromTabIndex = 3,
  });

  @override
  State<VisitDetailsScreen> createState() => _VisitDetailsScreenState();
}

class _VisitDetailsScreenState extends State<VisitDetailsScreen> {
  final TextEditingController _transportController = TextEditingController();
  final TextEditingController _conveyanceController = TextEditingController();

  Function? refreshCardData;
  Function? refreshSpotCardData;

  bool inprogresssvisitupdatestore = false;
  String? _visitType; // "Meeting" বা "Spot Visiting"
  late VisitSpotModel currentItem;

  bool showSpotVisitCard = true;

  String? selectedCustomer;

  // address location
  double? curlatStart;
  double? curlongStart;
  String startAddress = "";

  double? curlatReached;
  double? curlongReached;
  String reachedAddress = "";

  double? curlatEnd;
  double? curlongEnd;
  String endAddress = "";
  ///////////////////////////////

  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  bool showTapHoldCard = false;
  bool showButton = true; // initial state

  // bikash tab hold..........................................................
  double progress = 0.0;
  bool isHolding = false;
  bool isCompleted = false;
  Timer? _timer;

  int currentStep = 0;

  late int maxStep; // ✅ According to Visit Plan or Other Visit

  final List<String> stepTexts = ["Start", "Reached", "End"];
  final List<Color> ringColors = [
    Colors.pinkAccent,
    Colors.pinkAccent,
    Colors.pinkAccent,
  ];

  bool inprogresssTrasport = false;

  // client get api
  final List<TranspotTyepDropDwonModel> _transpotNameList = [];
  TranspotTyepDropDwonModel? selectedTransport;
  Future<void> _fetchTranspotList() async {
    inprogresssTrasport = true;
    setState(() {});
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.visittranspotUrl,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      final transpottypeData = response.responseData;
      for (Map<String, dynamic> transpottypeJson in transpottypeData['data']) {
        final transpottypeModelall = TranspotTyepDropDwonModel.fromJson(
          transpottypeJson,
        );
        _transpotNameList.add(transpottypeModelall);
      }

      setState(() {
        if (_transpotNameList.isNotEmpty) {
          // Finding the object named "Walking" from the list
          selectedTransport = _transpotNameList.firstWhere(
            (element) =>
                element.vehicleType.toString().toLowerCase() == "walking",
            orElse: () => _transpotNameList
                .first, // If not found, the first one will be shown.
          );

          // Setting values ​​in the controller
          if (selectedTransport?.vehicleType == "Walking") {
            _transportController.text = "Walking";
            _conveyanceController.text = "0";
          }
        }
      });
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
    inprogresssTrasport = false;
    setState(() {});
  }

  // init state.................................................................................
  VisitSpotModel? recentitem;
  @override
  void initState() {
    super.initState();

    currentItem = widget.item;
    _visitType = currentItem.visitType?.trim();

    // maxStep
    if (_visitType == "Meeting") {
      maxStep = 3; // Start → Reached → End
    } else if (_visitType == "Spot Visit") {
      maxStep = 2; // Start → Reached
    } else {
      maxStep = 1;
    }

    /// ✅ STATUS BASED STEP CONTROL (MAIN FIX)
    switch (currentItem.status) {
      case "Started":
        currentStep = 1;
        showButton = true;
        break;

      case "Reached":
        currentStep = (_visitType == "Meeting") ? 2 : maxStep;
        showButton = currentStep < maxStep;
        break;

      case "Completed":
        currentStep = maxStep;
        showButton = false;
        break;

      default:
        currentStep = 0;
        showButton = true;
    }

    progress = 0.0;
    isHolding = false;
    isCompleted = false;

    _fetchLocationAndAddressStart();
    _fetchLocationAndAddressReached();
    _fetchLocationAndAddressEnd();
    _fetchTranspotList();
  }
  // inite state done

  //////////////////////////////////////// bikash tap hold button.............................................................

  void _startHold() {
    if (isCompleted || currentStep >= maxStep) return;

    setState(() => isHolding = true);

    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        progress += 0.02;
      });

      if (progress >= 1.0) {
        timer.cancel();
        progress = 1.0;
        _completeCurrentStep();
      }
    });
  }

  void _stopHold() {
    if (!isCompleted && currentStep < maxStep) {
      _timer?.cancel();
      setState(() {
        isHolding = false;
        progress = 0.0;
      });
    }
  }

  // Tap-hold complete step
  void _completeCurrentStep() async {
    if (currentStep >= maxStep) return;

    // Position position = await Geolocator.getCurrentPosition(
    //   desiredAccuracy: LocationAccuracy.high,
    // );
    // curlat = position.latitude;
    // curlong = position.longitude;

    setState(() => isCompleted = true);

    // API call according to step
    if (currentStep == 0) {
      await _callStartApi();
    }
    if (currentStep == 1 && _visitType == "Meeting") {
      await _fetchLocationAndAddressReached();
      _showTransportDialog();
    }
    if (currentStep == 1 && _visitType != "Meeting") {
      await _fetchLocationAndAddressReached();
      _showTransportDialog();
    }
    if (currentStep == 2) {
      await _fetchLocationAndAddressEnd();
      await _callEndApi();
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        currentStep++;
        progress = 0.0;
        isHolding = false;
        isCompleted = false;
        showButton = currentStep < maxStep;
      });
    });
  }

  //...........................................................................................

  //...................................................................................

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back(result: true);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "Visit Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: ScreenBackground(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    //////////////////////////////////////////////////////////////////
                    VisitDetailsCard(
                      cardIndex: currentItem.id ?? 0,
                      item: currentItem,
                    ),

                    ////////////////////////////////////////..part 1..../////////////////////////
                    SizedBox(height: 10),
                    VisitDetailsTapholdCard(
                      onCreated: (refreshFunc) {
                        refreshCardData =
                            refreshFunc; // The card refresh method is saved here
                      },
                      visitItem: currentItem,
                    ),
                    SizedBox(height: 10),

                    //////////////////////////////// part 2/////////////////////////////////////
                    if (currentItem.visitType == "Spot Visit" &&
                            currentItem.status == "Reached" ||
                        currentItem.visitType != "Meeting" &&
                            currentItem.status == "Completed") ...[
                      VisitDetailsSpotVisitCard(
                        item: currentItem,
                        onVisitEnd: () {
                          setState(() {
                            currentItem.status = "Completed"; // Updating status
                          });
                          if (refreshCardData != null) {
                            refreshCardData!(); // Refreshing card
                          }
                        },
                      ),
                    ],

                    /////////////////////////////////// part 3/////////////////////////////////
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            SizedBox(height: 80),

            // Press hold button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child:
                    (showButton ==
                        true) // The button will only be shown when showButton is true.
                    ? (isCompleted
                          ? _pressHoldButton() // Success state after holding
                          : GestureDetector(
                              onLongPressStart: (_) => _startHold(),
                              onLongPressEnd: (_) => _stopHold(),
                              onLongPressCancel: _stopHold,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Main pink circle
                                  Container(
                                    height: 78,
                                    width: 78,
                                    decoration: BoxDecoration(
                                      color: Colors.pink.shade600,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.pink.shade200,
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Progress ring
                                  SizedBox(
                                    height: 110,
                                    width: 110,
                                    child: CircularProgressIndicator(
                                      value: progress,
                                      strokeWidth: 10,
                                      backgroundColor: Colors.pink.shade100,
                                      valueColor: AlwaysStoppedAnimation(
                                        // Here is the safety check for currentStep
                                        ringColors[currentStep >= maxStep
                                            ? maxStep - 1
                                            : currentStep],
                                      ),
                                    ),
                                  ),

                                  // Text
                                  Text(
                                    getButtonText(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                    : const SizedBox.shrink(), // If showButton is false, the button disappears.
              ),
            ),

            // bikash tap hold done
          ],
        ),
      ),
      //  bottomNavigationBar: CustomBottomNavigationBar(currentIndex:widget.fromTabIndex),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2), // For line gaps
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width:
                90, // A fixed width for the label (you can increase it as needed)
            child: Text(label, style: TextStyle(fontSize: 12)),
          ),
          Text(" : ", style: TextStyle(fontSize: 12)), // Clone section
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

  // Button text function
  String getButtonText() {
    switch (currentStep) {
      case 0:
        return "Start";
      case 1:
        return (_visitType == "Meeting" || _visitType == "Spot Visit")
            ? "Reached"
            : "End";
      case 2:
        return "End";
      default:
        return "";
    }
  }

  // press hold button
  Widget _pressHoldButton() {
    String text = getButtonText();
    // Color color = ringColors[currentStep];
    Color color =
        ringColors[currentStep >= ringColors.length
            ? ringColors.length - 1
            : currentStep];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: currentStep == 3
              ? const Icon(Icons.check, color: Colors.white, size: 80)
              : null,
        ),

        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  //..............................................................................

  // Visit Start API কল
  Future<void> _callStartApi() async {
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    print("hellllllllllllllllllllll");
    Map<String, dynamic> body = {
      "visit_id": widget.item.id.toString(),
      "start_address": startAddress,
      "company_id": AuthController.userModel!.companyid,
      "employee_id": AuthController.userModel!.empoloyeeid,
      "actual_visit_start_time": DateFormat('HH:mm:ss').format(DateTime.now()),
      "start_latitude": curlatStart,
      "start_longitude": curlongStart,
      "actual_visit_from": startAddress,
      "actual_visit_date": currentDate,
    };

    ApiResponse response = await NetworkCaller.postRequest(
      url: Urls.visitstartUrl(widget.item.id.toString()),
      body: body,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      setState(() {
        currentItem.status = "Started";
      });
      currentItem.actualVisitStartTime = DateFormat(
        'HH:mm:ss',
      ).format(DateTime.now());

      if (refreshCardData != null) {
        refreshCardData!();
      }

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

  // Visit Reach API কল
  Future<void> _callReachApi() async {
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    Map<String, dynamic> body = {
      "visit_id": widget.item.id.toString(),
      "company_id": AuthController.userModel!.companyid,
      "employee_id": AuthController.userModel!.empoloyeeid,
      "visit_reach_time": DateFormat('HH:mm:ss').format(DateTime.now()),
      "reach_latitude": curlatReached,
      "reach_longitude": curlongReached,
      "reach_address": reachedAddress,
      "vehicle_id": selectedTransport!.transpotid.toString(),
      "vehicle_bill": _conveyanceController.text.trim(),
      "reached_date": currentDate,
    };

    ApiResponse response = await NetworkCaller.postRequest(
      url: Urls.visitreachUrl(widget.item.id.toString()),
      body: body,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      setState(() {
        currentItem.status = "Reached";
      });

      currentItem.visitReachTime = DateFormat(
        'HH:mm:ss',
      ).format(DateTime.now());
      if (refreshCardData != null) {
        refreshCardData!();
      }

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

  // Visit End API কল
  Future<void> _callEndApi() async {
    // Date format according to server requirements
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    print("date hobeeeeeeeeeeeee,,,,,,,,,,,,,,,,,,,,,,,,${currentDate}");

    Map<String, dynamic> body = {
      "visit_id": widget.item.id.toString(),
      "company_id": AuthController.userModel!.companyid,
      "employee_id": AuthController.userModel!.empoloyeeid,
      "actual_visit_end_time": DateFormat('HH:mm:ss').format(DateTime.now()),
      "end_latitude": curlatEnd,
      "end_longitude": curlongEnd,
      "end_address": endAddress,
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
        currentItem.status = "Completed";

        currentStep = maxStep;
        showButton = false;
      });
      currentItem.visitEndTime = DateFormat('HH:mm:ss').format(DateTime.now());

      if (refreshCardData != null) {
        refreshCardData!();
      }

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
      //Receiving the message from the server

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

  void _showTransportDialog() {
    final GlobalKey<FormState> dialogFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // ✅ StatefulBuilder is used so that the UI updates instantly
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                "Transport Details",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Form(
                key: dialogFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownSearch<TranspotTyepDropDwonModel>(
                      key: ValueKey("Transport"),
                      items: _transpotNameList,
                      itemAsString: (TranspotTyepDropDwonModel d) =>
                          d.vehicleType.toString(),
                      selectedItem: selectedTransport,
                      onChanged: (TranspotTyepDropDwonModel? tst) {
                        setDialogState(() {
                          selectedTransport = tst;
                          _transportController.text = tst?.vehicleType ?? "";

                          // Check the name property of the Model with a String
                          if (tst?.vehicleType == "Walking") {
                            _conveyanceController.text = "0";
                          } else {
                            _conveyanceController.text = "";
                          }
                        });
                      },
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: "Search Transport..",
                            labelText: "Select Transport",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        showSelectedItems: false,
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Select transport",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      validator: (TranspotTyepDropDwonModel? value) {
                        if (value == null) {
                          return "Please select a transport";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),

                    TextFormField(
                      controller: _conveyanceController,
                      // If walking, the user will not be able to type (ReadOnly), otherwise they will be able to
                      readOnly: selectedTransport == "Walking",
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Conveyance(Tk)",
                        hintText: "Enter amount",
                        // If you are walking, the background will look a little gray.
                        filled: selectedTransport == "Walking",
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter the amount";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A8AA),
                  ),
                  onPressed: () async {
                    if (dialogFormKey.currentState!.validate()) {
                      Navigator.pop(context);
                      await _callReachApi();
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String formatDisplayTime(String? time) {
    if (time == null || time.isEmpty) return "N/A";
    try {
      // If the time is already in AM/PM format, we will return
      if (time.contains("AM") || time.contains("PM")) return time;

      // Otherwise it will try to parse.
      return DateFormat(
        'hh:mm a',
      ).format(DateTime.parse("2026-01-01 ${time.trim()}"));
    } catch (e) {
      return time; //  if any error, then show time
    }
  }

  // Combined function: GPS + address start
  Future<void> _fetchLocationAndAddressStart() async {
    try {
      // 1️⃣ GPS permission & service check
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => startAddress = "Location services are disabled");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => startAddress = "Location permission denied");
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => startAddress = "Location permission permanently denied");
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
        curlatStart = lat;
        curlongStart = long;
      });

      // 3️⃣ Fetch address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        curlatStart!,
        curlongStart!,
      );

      if (placemarks.isNotEmpty) {
        Placemark first = placemarks.first;
        setState(() {
          startAddress =
              "${first.street ?? ''}, ${first.subLocality ?? ''}, ${first.locality ?? ''}";
        });
      } else {
        setState(() => startAddress = "No address found");
      }
    } catch (e) {
      print("Error fetching location or address: $e");
      setState(() => startAddress = "Error fetching location");
    }
  }

  // Combined function: GPS + address  reached
  Future<void> _fetchLocationAndAddressReached() async {
    try {
      // 1️⃣ GPS permission & service check
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => reachedAddress = "Location services are disabled");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => reachedAddress = "Location permission denied");
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(
          () => reachedAddress = "Location permission permanently denied",
        );
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
        curlatReached = lat;
        curlongReached = long;
      });

      // 3️⃣ Fetch address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        curlatReached!,
        curlongReached!,
      );

      if (placemarks.isNotEmpty) {
        Placemark first = placemarks.first;
        setState(() {
          reachedAddress =
              "${first.street ?? ''}, ${first.subLocality ?? ''}, ${first.locality ?? ''}";
        });
      } else {
        setState(() => reachedAddress = "No address found");
      }
    } catch (e) {
      print("Error fetching location or address: $e");
      setState(() => reachedAddress = "Error fetching location");
    }
  }

  // Combined function: GPS + address  end
  Future<void> _fetchLocationAndAddressEnd() async {
    try {
      // 1️⃣ GPS permission & service check
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => endAddress = "Location services are disabled");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => endAddress = "Location permission denied");
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => endAddress = "Location permission permanently denied");
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
        curlatEnd = lat;
        curlongEnd = long;
      });

      // 3️⃣ Fetch address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        curlatEnd!,
        curlongEnd!,
      );

      if (placemarks.isNotEmpty) {
        Placemark first = placemarks.first;
        setState(() {
          endAddress =
              "${first.street ?? ''}, ${first.subLocality ?? ''}, ${first.locality ?? ''}";
        });
      } else {
        setState(() => endAddress = "No address found");
      }
    } catch (e) {
      print("Error fetching location or address: $e");
      setState(() => endAddress = "Error fetching location");
    }
  }
}
