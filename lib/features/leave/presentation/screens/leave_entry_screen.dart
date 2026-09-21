import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/leave/data/models/leave_category_list.dart';
import 'package:devsalesxpert/features/leave/presentation/screens/leave_info_view_screen.dart';

double? curlat;
double? curlong;
String curAddress = "";

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final TextEditingController _employeecontroller = TextEditingController();
  final TextEditingController _businessunitcontroller = TextEditingController();
  final TextEditingController _departmentcontroller = TextEditingController();
  final TextEditingController _designationcontroller = TextEditingController();

  final TextEditingController _fromdatecontroller = TextEditingController();
  final TextEditingController _todatecontroller = TextEditingController();
  final TextEditingController _joindatecontroller = TextEditingController();
  final TextEditingController _reasoncontroller = TextEditingController();

  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();

  bool inprogrsspostleaverequest = false;
  bool inprogressLeaveCategory = false;

  File? image;
  String? imageName;

  //  leave category list...
  String? selectedFromDate;
  String? selectedYear;

  final List<LeaveCategory> _leavetypeList = [];
  LeaveCategory? _selectedLeaveType;

  Future<void> _leaveCategoryList() async {
    if (selectedFromDate == null || selectedYear == null) return;

    inprogressLeaveCategory = true;
    _leavetypeList.clear();
    _selectedLeaveType = null;
    setState(() {});

    final Map<String, dynamic> requestBody = {
      "company_id": AuthController.userModel!.companyid,
      "employee_id": AuthController.userModel!.empoloyeeid,
      "year": selectedYear,
      "employee_type": AuthController.userModel!.employeeType.toString(),
      "from_date": selectedFromDate,
    };

    ApiResponse response = await NetworkCaller.postRequest(
      url: Urls.leaveCategoryUrl,
      body: requestBody,
      token: AuthController.accessToken,
    );

    if (response.isSuccess && response.responseData["success"] == true) {
      final List list = response.responseData["data"];
      _leavetypeList.addAll(
        list.map((e) => LeaveCategory.fromJson(e)).toList(),
      );
    }

    inprogressLeaveCategory = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    _employeecontroller.text = AuthController.userModel!.nameenglish;
    _businessunitcontroller.text = AuthController.userModel!.companyName;
    _departmentcontroller.text = AuthController.userModel!.departmentname;
    _designationcontroller.text = AuthController.userModel!.designationname;
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
        centerTitle: true,

        title: const Text(
          "Leave Request",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),

      body: ScreenBackground(
        child: Form(
          key: _fromKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              const TextSpan(
                                text: "Name : ",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text:
                                    AuthController.userModel?.nameenglish ??
                                    "No Name",
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),

                              const TextSpan(text: "\n"),

                              const TextSpan(
                                text: "Department : ",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text:
                                    AuthController.userModel?.departmentname
                                        .toString() ??
                                    "No Department",
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),

                              TextSpan(text: "\n"),

                              TextSpan(
                                text: "Designation : ",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text:
                                    AuthController.userModel?.designationname
                                        .toString() ??
                                    "No Designation",
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),

                              const TextSpan(text: "\n"),

                              TextSpan(
                                text: "Employee Type : ",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text:
                                    AuthController.userModel?.employeeTypeName
                                        .toString() ??
                                    "No emplyeetype",
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),

                              const TextSpan(text: "\n"),

                              const TextSpan(
                                text: "Company Name : ",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              TextSpan(
                                text:
                                    AuthController.userModel?.companyName
                                        .toString() ??
                                    "No Company",
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "From Date",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),

                  TextFormField(
                    controller: _fromdatecontroller,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "From Date",
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
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
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        selectedFromDate = DateFormat(
                          'dd-MM-yyyy',
                        ).format(pickedDate);
                        selectedYear = pickedDate.year.toString();

                        _fromdatecontroller.text = selectedFromDate!;

                        // 🔥API call only when selecting from date
                        _leaveCategoryList();
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select from date";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 5),

                  Text(
                    "To Date",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),

                  TextFormField(
                    controller: _todatecontroller,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "To Date",
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
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
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        String formattedDate = DateFormat(
                          'dd-MM-yyyy',
                        ).format(pickedDate);

                        _todatecontroller.text = formattedDate;
                      }
                    },

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a visit date";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Leave Type",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),

                  // leave type x
                  DropdownSearch<LeaveCategory>(
                    items: _leavetypeList,
                    itemAsString: (LeaveCategory t) => t.leaveType.toString(),
                    selectedItem: _selectedLeaveType,
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      showSelectedItems: false,
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: "Select Leave",
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
                      ),
                    ),
                    onChanged: (LeaveCategory? leave) {
                      if (leave != null) {
                        setState(() {
                          _selectedLeaveType = leave;
                        });
                      }
                    },
                    validator: (LeaveCategory? leave) =>
                        leave == null ? "Please select a leave type" : null,
                  ),

                  // total leave days
                  SizedBox(height: 5),
                  Text(
                    "Reason",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),

                  TextFormField(
                    maxLines: null,
                    controller: _reasoncontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Enter reason",
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
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "enter the email";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _openGallery();
                          print(image!.path);
                        },

                        child: Container(
                          height: 30,
                          width: 95,
                          color: Colors.grey.shade300,
                          child: Center(child: Text("Choose File")),
                        ),
                      ),
                      SizedBox(width: 20),

                      image == null ? Text('No image taken') : Text(imageName!),
                    ],
                  ),

                  SizedBox(height: 20),

                  Visibility(
                    visible: inprogrsspostleaverequest == false,
                    replacement: Center(
                      child: CustomCircularProgressIndicator(),
                    ),
                    child: FilledButton(
                      onPressed: () async {
                        if (_fromKey.currentState!.validate()) {
                          await _fetchLocationAndAddress();
                          _postLeaveRequest();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (states) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.orange;
                            }
                            return const Color(0xFF7F2AFF);
                          },
                        ),
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
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 22,
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
        ),
      ),
      //  bottomNavigationBar:  CustomBottomNavigationBar(currentIndex: widget.fromTabIndex)
    );
  }

  // post request
  Future<void> _postLeaveRequest() async {
    if (inprogrsspostleaverequest) return;
    setState(() {
      inprogrsspostleaverequest = true;
    });

    try {
      final user = AuthController.userModel!;

      // Creating a Multipart Request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Urls.leaveRequestUrl),
      );

      // Setting headers (including tokens)
      request.headers.addAll({
        'Authorization': 'Bearer ${AuthController.accessToken}',
        'Accept': 'application/json',
      });

      // map body
      request.fields['company_id'] = user.companyid.toString();
      request.fields['employee_id'] = user.empoloyeeid.toString();
      request.fields['from_date'] = _fromdatecontroller.text.trim();
      request.fields['to_date'] = _todatecontroller.text.trim();

      request.fields['leave_type_id'] = _selectedLeaveType?.id.toString() ?? "";
      request.fields['leave_category_id'] =
          _selectedLeaveType?.leaveCategoryId.toString() ?? "";
      request.fields['reason'] = _reasoncontroller.text.trim();
      request.fields['leave_latitude'] = curlat.toString();
      request.fields['leave_longitude'] = curlong.toString();

      // Adding the image file (if any)
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('leave_document', image!.path),
        );
      }

      // Sending a request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      final Map<String, dynamic> decodedData = jsonDecode(response.body);

      String serverMessage =
          decodedData['message']?.toString() ?? "Request failed";

      print(decodedData['success'].runtimeType);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          decodedData['success'] == true) {
        Get.offAll(() => LeaveInfoScreen());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFF00A8AA),
            content: Center(
              child: Text(
                serverMessage,
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
                serverMessage,
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
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        inprogrsspostleaverequest = false;
      });
    }
  }

  //
  Future<void> _openGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;

    setState(() {
      image = File(pickedFile.path);
      imageName = pickedFile.name;
    });
    // Safe print
    print("Image Path: ${image!.path}");
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

  void cleartext() {
    _employeecontroller.clear();
    _businessunitcontroller.clear();
    _departmentcontroller.clear();
    _designationcontroller.clear();
    _fromdatecontroller.clear();
    _todatecontroller.clear();
    _joindatecontroller.clear();
    _reasoncontroller.clear();
  }
}
