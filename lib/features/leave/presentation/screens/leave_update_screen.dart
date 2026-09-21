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
import 'package:devsalesxpert/features/leave/data/models/leave_history_model.dart';
import 'package:devsalesxpert/features/leave/presentation/screens/leave_info_view_screen.dart';

double? curlat;
double? curlong;
String curAddress = "";

String? oldImage;

class LeaveUpdateScreen extends StatefulWidget {
  final int fromTabIndex;
  final LeaveHistoryModel item;
  final bool isReadOnly;
  const LeaveUpdateScreen({
    super.key,
    this.fromTabIndex = 0,
    required this.item,
    required this.isReadOnly,
  });

  @override
  State<LeaveUpdateScreen> createState() => _LeaveUpdateScreenState();
}

class _LeaveUpdateScreenState extends State<LeaveUpdateScreen> {
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

      if (_leavetypeList.isNotEmpty) {
        try {
          _selectedLeaveType = _leavetypeList.firstWhere(
            (leave) =>
                leave.leaveType.toString().trim() ==
                widget.item.leavetype.toString().trim(),
          );
        } catch (e) {
          _selectedLeaveType = null;
        }
      }
      setState(() {});
    }

    inprogressLeaveCategory = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _employeecontroller.text = AuthController.userModel!.nameenglish;
    _businessunitcontroller.text = AuthController.userModel!.companyName;
    _departmentcontroller.text = AuthController.userModel!.departmentname;
    _designationcontroller.text = AuthController.userModel!.designationname;
    _reasoncontroller.text = widget.item.reason;

    List<String> dates = widget.item.dateRange.split(' ');

    if (dates.length >= 2) {
      // The variable is declared here.
      DateTime fromDateObj = DateTime.parse(dates.first.trim());
      DateTime toDateObj = DateTime.parse(dates.last.trim());

      _fromdatecontroller.text = DateFormat('dd-MM-yyyy').format(fromDateObj);
      _todatecontroller.text = DateFormat('dd-MM-yyyy').format(toDateObj);

      // Values ​​assigned for API
      selectedFromDate = _fromdatecontroller.text;
      selectedYear = fromDateObj.year.toString();
    }

    image = null;
    oldImage = null;

    if (widget.item.imagedoc.isNotEmpty) {
      oldImage = widget.item.imagedoc;
    }

    _leaveCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    print("hello imagessssssssssssssssssssssssssssssssssssssssssssssss");
    // print(widget.item.imagedoc);

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
          "Leave Update",
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
                    readOnly: widget.isReadOnly,
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
                      if (widget.isReadOnly) return;
                      DateTime? selectedDate;

                      if (_fromdatecontroller.text.isNotEmpty) {
                        // Convert your text '04-02-2026' to DateTime
                        selectedDate = DateFormat(
                          'dd-MM-yyyy',
                        ).parse(_fromdatecontroller.text);
                      }
                      // Now give selectedDate as initialDate in showDatePicker
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate:
                            selectedDate, // Here, instead of DateTime.now(), selectedDate will be used.
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        String formattedDate = DateFormat(
                          'dd-MM-yyyy',
                        ).format(pickedDate);
                        setState(() {
                          _fromdatecontroller.text = formattedDate;
                          // 🔥 API call only when selecting from date
                          _leaveCategoryList();
                        });
                      }
                    },
                  ),

                  SizedBox(height: 5),

                  Text(
                    "To Date",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),

                  TextFormField(
                    controller: _todatecontroller,
                    readOnly: widget.isReadOnly,
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
                      if (widget.isReadOnly) return;
                      DateTime? selectedDate;

                      if (_todatecontroller.text.isNotEmpty) {
                        // Convert your text '04-02-2026' to DateTime
                        selectedDate = DateFormat(
                          'dd-MM-yyyy',
                        ).parse(_todatecontroller.text);
                      }
                      // Now give selectedDate as initialDate in showDatePicker
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate:
                            selectedDate, // Here, instead of DateTime.now(), selectedDate will be used.
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        String formattedDate = DateFormat(
                          'dd-MM-yyyy',
                        ).format(pickedDate);
                        setState(() {
                          _todatecontroller.text = formattedDate;
                        });
                      }
                    },
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Leave Type",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),

                  // leave type x
                  DropdownSearch<LeaveCategory>(
                    enabled: !widget.isReadOnly,
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
                    readOnly: widget.isReadOnly,
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
                      if (widget.item.StatusText != "Approved") ...[
                        GestureDetector(
                          onTap: _openGallery,
                          child: Container(
                            height: 30,
                            width: 80,
                            color: Colors.grey.shade300,
                            child: Center(child: Text("Choose File")),
                          ),
                        ),
                      ],

                      SizedBox(width: 20),

                      GestureDetector(
                        onTap: () {
                          // Function call to enlarge the image
                          _showFullImage(context, image, oldImage);
                        },
                        child: image != null
                            ? Image.file(
                                image!,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                            : oldImage != null
                            ? Image.network(
                                oldImage!,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                            : const Text('No image'),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  Visibility(
                    visible:
                        widget.item.StatusText != "Approved" &&
                        inprogrsspostleaverequest == false,
                    replacement: widget.item.StatusText == "Approved"
                        ? const SizedBox.shrink() // Hide completely if approved
                        : const Center(
                            child: CustomCircularProgressIndicator(),
                          ),
                    child: FilledButton(
                      onPressed: () async {
                        if (_fromKey.currentState!.validate()) {
                          await _fetchLocationAndAddress();
                          _updateLeaveRequest(widget.item.id.toString());
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
                          // ignore: deprecated_member_use
                          Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: const Text(
                        "Update",
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

  void _showFullImage(
    BuildContext context,
    File? localImage,
    String? networkImage,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            // Main image view
            InteractiveViewer(
              // Will provide zooming facilities.
              child: localImage != null
                  ? Image.file(localImage, fit: BoxFit.contain)
                  : Image.network(networkImage!, fit: BoxFit.contain),
            ),
            // Off Button
            IconButton(
              icon: Icon(Icons.close, color: Colors.grey, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  // post request
  Future<void> _updateLeaveRequest(String id) async {
    setState(() {
      inprogrsspostleaverequest = true;
    });

    try {
      final user = AuthController.userModel!;

      //  Creating a Multipart Request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Urls.updateleaveRequestUrl(id)),
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
          await http.MultipartFile.fromPath(
            'leave_document', // The key your API receives files with.
            image!.path,
          ),
        );
      } else {
        print("No image selected, so request number without file.");
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
        // ignore: use_build_context_synchronously
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
