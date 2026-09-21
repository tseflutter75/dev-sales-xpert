import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/leave/data/models/leave_type_drop_dwon_model.dart';

class VisitCustomerButtonScreen extends StatefulWidget {
  final int fromTabIndex;
  const VisitCustomerButtonScreen({super.key, this.fromTabIndex = 1});

  @override
  State<VisitCustomerButtonScreen> createState() =>
      _VisitCustomerButtonScreenState();
}

class _VisitCustomerButtonScreenState extends State<VisitCustomerButtonScreen> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _openingDateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // final TextEditingController _nidBinController = TextEditingController();
  // final TextEditingController _openBalanceController = TextEditingController();
  // final TextEditingController _discountController = TextEditingController();
  // final TextEditingController _deliveryController = TextEditingController();

  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();

  bool inprogrsssCustomer = false;
  int isActive = 1;

  // for leave type
  final List<LeaveTypeModel> _leavetypeList = [];

  File? image;
  String? imageName;

  Future<void> _fetchLeaveTypeList() async {
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.leavetypefromUrl,
      token: AuthController.accessToken,
    );
    if (response.isSuccess) {
      final leavetypeData = response.responseData;

      for (Map<String, dynamic> leavetypeJson in leavetypeData['data']) {
        final leavetypeModelall = LeaveTypeModel.fromJson(leavetypeJson);
        _leavetypeList.add(leavetypeModelall);
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    _fetchLeaveTypeList();
    super.initState();
  }

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
        centerTitle: true,

        title: const Text(
          "Customer",
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
                  Text(
                    "Customer Name *",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),

                  TextFormField(
                    maxLines: null,
                    controller: _customerNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      isDense: true,

                      hintText: "customer name",
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
                        return "enter the customer name";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 5),
                  Text(
                    "Contact Person *",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),

                  TextFormField(
                    maxLines: null,
                    controller: _ownerNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      isDense: true,

                      hintText: "contact person",
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
                        return "enter the owner name";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Mobile Number *",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),

                  TextFormField(
                    maxLines: null,
                    controller: _mobileController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                      FilteringTextInputFormatter
                          .digitsOnly, // শুধু নাম্বার ইনপুট নিতে
                    ],
                    decoration: InputDecoration(
                      isDense: true,

                      hintText: "mobile number",
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
                        return "enter the mobile number";
                      } else if (value.length != 11) {
                        return "valid mobile num. (11 digit)";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 5),

                  Text(
                    "Email Address",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),

                  TextFormField(
                    maxLines: null,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      isDense: true,

                      hintText: "email address",
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
                    // validator: (String? value) {
                    //   if (value == null || value.isEmpty) {
                    //     return "enter the email";
                    //   }
                    //   return null;
                    // },
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Address *",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),

                  TextFormField(
                    maxLines: null,
                    controller: _locationController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      isDense: true,

                      hintText: "address",
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
                        return "enter the address";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 5),

                  // Text(
                  //   "Opening Date",
                  //   style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  // ),

                  // TextFormField(
                  //   controller: _openingDateController,
                  //   readOnly: true,
                  //   decoration: InputDecoration(
                  //     isDense: true,
                  //     contentPadding: EdgeInsets.symmetric(
                  //       horizontal: 12,
                  //       vertical: 12,
                  //     ),
                  //     hintText: "opening date",
                  //     suffixIcon: const Icon(Icons.calendar_today_outlined),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(15),
                  //     ),
                  //   ),
                  //   onTap: () async {
                  //     DateTime? pickedDate = await showDatePicker(
                  //       context: context,
                  //       initialDate: DateTime.now(),
                  //       firstDate: DateTime(2020),
                  //       lastDate: DateTime(2100),
                  //     );

                  //     if (pickedDate != null) {
                  //       String formattedDate = DateFormat(
                  //         'dd-MM-yyyy',
                  //       ).format(pickedDate);

                  //       _openingDateController.text = formattedDate;
                  //     }
                  //   },

                  //   // validator: (value) {
                  //   //   if (value == null || value.isEmpty) {
                  //   //     return "Please select a open date";
                  //   //   }
                  //   //   return null;
                  //   // },
                  // ),
                  SizedBox(height: 5),

                  SizedBox(height: 15),

                  Visibility(
                    visible: inprogrsssCustomer == false,
                    replacement: Center(
                      child: CustomCircularProgressIndicator(),
                    ),
                    child: FilledButton(
                      onPressed: () {
                        if (_fromKey.currentState!.validate()) {
                          _customerVisitStore();
                        }
                      },
                      style: ButtonStyle(
                        // ১. সাধারণ অবস্থায় কালার
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (states) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.orange; //
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
      // bottomNavigationBar: CustomBottomNavigationBar(
      //   currentIndex: widget.fromTabIndex,
      // ),
    );
  }

  Future<void> _customerVisitStore() async {
    if (inprogrsssCustomer) return;

    inprogrsssCustomer = true;
    setState(() {});

    final Map<String, dynamic> requestBody = {
      "company_id": AuthController.userModel!.companyid,
      "emp_id": AuthController.userModel!.empoloyeeid,
      "party_name": _customerNameController.text.trim(),
      "owner_name": _ownerNameController.text.trim(),
      "mobile_no": _mobileController.text.trim(),
      "email_address": _emailController.text.trim(),
      "present_address": _locationController.text.trim(),
      "status": isActive,
    };

    ApiResponse response = await NetworkCaller.postRequest(
      url: Urls.visitcustomerUrl,
      body: requestBody,
      token: AuthController.accessToken,
    );

    print(response.responseData);
    print(response.responseCode);

    if (response.isSuccess && response.responseData["success"] == true) {
      print(response.responseData["opening_date"]);
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
      cleartext();
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
      inprogrsssCustomer = false;
      setState(() {});
    }
  }

  void cleartext() {
    _customerNameController.clear();
    _ownerNameController.clear();
    _mobileController.clear();
    _emailController.clear();
    _openingDateController.clear();
    _locationController.clear();
  }
}
