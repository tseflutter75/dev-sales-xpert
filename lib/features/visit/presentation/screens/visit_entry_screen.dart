import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/screens/main_nav_holder.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/visit/data/models/client_type_drop_dwon_model.dart';
import 'package:devsalesxpert/features/visit/data/models/purpose_drop_dwon_model.dart';

class VisitEntryScreen extends StatefulWidget {
  // final int fromTabIndex;
  const VisitEntryScreen({
    super.key,
    //  this.fromTabIndex = 3
  });

  @override
  State<VisitEntryScreen> createState() => _VisitEntryScreenState();
}

class _VisitEntryScreenState extends State<VisitEntryScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _visitdateController = TextEditingController();
  final TextEditingController _clientnameController = TextEditingController();

  final TextEditingController _contactpersonController =
      TextEditingController();
  final TextEditingController _contactpersonMobileController =
      TextEditingController();
  final TextEditingController _fromlocationController = TextEditingController();
  final TextEditingController _tolocationController = TextEditingController();
  final TextEditingController _fromtimeController = TextEditingController();
  final TextEditingController _totimeController = TextEditingController();
  final TextEditingController _visitfromlocationController =
      TextEditingController();
  final TextEditingController _visittolocationController =
      TextEditingController();
  final TextEditingController _visitfromtimeController =
      TextEditingController();
  final TextEditingController _visittotimeController = TextEditingController();
  final TextEditingController _meetingpurposeController =
      TextEditingController();
  final TextEditingController _visitpurposeController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _remarksVisitController = TextEditingController();

  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();

  bool inprogresssvisitstore = false;
  String selectedVisitType = "Spot Visit";

  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  // client get api
  final List<ClientTypeModel> _clientNameList = [];
  ClientTypeModel? selectedClient;
  Future<void> _fetchclintList() async {
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
  }

  // purpose get api
  final List<PurposeModel> _purposeNameList = [];
  PurposeModel? selectedPurpose;
  Future<void> _fetchpurposeMeetingList() async {
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

  // purpose get visit api
  final List<PurposeModel> _visitpurposeNameList = [];
  PurposeModel? selectedVisitPurpose;
  Future<void> _fetchvisitpurposeList() async {
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.purposefromUrl,
      token: AuthController.accessToken,
    );

    if (response.isSuccess) {
      final purposeData = response.responseData;
      for (Map<String, dynamic> purposeJson in purposeData['data']) {
        final purposeModelall = PurposeModel.fromJson(purposeJson);
        _visitpurposeNameList.add(purposeModelall);
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

  @override
  void initState() {
    super.initState();

    _fetchclintList();
    _fetchpurposeMeetingList();
    _fetchvisitpurposeList();

    _dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _visitdateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => const BottomNavControllerScreen(initialIndex: 3));
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,
        title: Text(
          "Visit Entry",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Form(
            key: _fromKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  /////
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                shape: CircleBorder(),
                                value: selectedVisitType == "Spot Visit",
                                onChanged: (_) {
                                  setState(() {
                                    selectedVisitType = "Spot Visit";
                                  });
                                },
                              ),
                              Text(
                                "Visit",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                shape: const CircleBorder(),
                                value: selectedVisitType == "Meeting",
                                onChanged: (_) {
                                  setState(() {
                                    selectedVisitType = "Meeting";
                                  });
                                },
                              ),
                              const Text(
                                "Meeting",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  // meeting ...............................................................................
                  if (selectedVisitType == "Meeting") ...[
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        isDense: true,

                        hintText: "Visit Date",
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

                          _dateController.text = formattedDate;
                        }
                      },

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select a visit date";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // drop dwon customer name
                    // clint type x
                    DropdownSearch<ClientTypeModel>(
                      items: _clientNameList,
                      itemAsString: (ClientTypeModel t) => t.name.toString(),
                      selectedItem: selectedClient,
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search), // এখানে search icon

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        showSelectedItems: false,
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          isDense: true,

                          hintText: "Select Customer",
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
                      onChanged: (ClientTypeModel? client) {
                        if (client != null) {
                          setState(() {
                            selectedClient = client;
                            _contactpersonController.text =
                                client.ownerName ?? '';
                            _contactpersonMobileController.text =
                                client.mobileNo ?? '';
                          });
                        }
                      },
                      validator: (ClientTypeModel? client) =>
                          client == null ? "Please select a customer" : null,
                    ),
                    SizedBox(height: 10),

                    // contact person
                    TextFormField(
                      maxLines: null,
                      controller: _contactpersonController,
                      keyboardType:
                          TextInputType.text, // Changed to text for description
                      decoration: InputDecoration(
                        isDense: true,

                        labelText: "Contact Person",
                        hintText: "Contact Person", // Corrected hintText
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
                          return "Please enter the contact person"; // Corrected error message
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),

                    // contact person mobile
                    TextFormField(
                      maxLines: null,
                      controller: _contactpersonMobileController,
                      keyboardType: TextInputType
                          .number, // Changed to text for description
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                        FilteringTextInputFormatter
                            .digitsOnly, // শুধু নাম্বার ইনপুট নিতে
                      ],
                      decoration: InputDecoration(
                        isDense: true,

                        labelText: "Contact Person Mobile",
                        hintText: "Contact Person Mobile", // Corrected hintText
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
                          return "Please enter the mobile"; // Corrected error message
                        } else if (value.length != 11) {
                          return "Enter valid mobile num. (11 digit)";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),

                    // 3. location Field
                    TextFormField(
                      maxLines: null,
                      controller: _fromlocationController,
                      keyboardType:
                          TextInputType.text, // Changed to text for description
                      decoration: InputDecoration(
                        isDense: true,

                        labelText: "From Location",
                        hintText: "From Location", // Corrected hintText
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
                          return "Please enter the location"; // Corrected error message
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      maxLines: null,
                      controller: _tolocationController,

                      keyboardType:
                          TextInputType.text, // Changed to text for description
                      decoration: InputDecoration(
                        isDense: true,

                        labelText: "To Location",
                        hintText: "To Location", // Corrected hintText
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
                          return "Please enter the location"; // Corrected error message
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),

                    // time (from)
                    TextFormField(
                      controller: _fromtimeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        isDense: true,

                        hintText: "From Time",
                        labelText: "From Time",
                        suffixIcon: Icon(Icons.access_time),
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
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialEntryMode: TimePickerEntryMode.dialOnly,
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          final now = DateTime.now();
                          final from = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );

                          setState(() {
                            fromTime = pickedTime; // ⭐ MUST
                            _fromtimeController.text = DateFormat(
                              'hh:mm a',
                            ).format(from);
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select time";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // time (to)
                    TextFormField(
                      controller: _totimeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        isDense: true,

                        labelText: "To Time",
                        hintText: "To Time",
                        suffixIcon: Icon(Icons.access_time),
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
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialEntryMode: TimePickerEntryMode.dialOnly,
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          final now = DateTime.now();
                          final to = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );

                          setState(() {
                            toTime = pickedTime; // ⭐ MUST
                            _totimeController.text = DateFormat(
                              'hh:mm a',
                            ).format(to);
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select time";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 10),
                    DropdownSearch<PurposeModel>(
                      key: ValueKey("Meeting purpose"),
                      items: _purposeNameList,
                      itemAsString: (PurposeModel p) =>
                          p.visitPurpose.toString(),
                      selectedItem: selectedPurpose,
                      onChanged: (PurposeModel? pur) {
                        setState(() {
                          selectedPurpose = pur;
                        });
                      },
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.search,
                            ), // এখানে search icon
                            hintText: "Search purpose..",
                            labelText: "Select purpose",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        showSelectedItems: false, // true দিলে compareFn লাগবে
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        // v5 এ সরাসরি decoration দিতে হবে না, বরং
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Select purpose",
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
                      validator: (PurposeModel? pur) =>
                          pur == null ? "Please select a purpose" : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      maxLines: null,
                      controller: _remarksController,
                      keyboardType:
                          TextInputType.text, // Changed to text as it's a name
                      decoration: InputDecoration(
                        labelText: "Note",
                        hintText: "Note",
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
                          return "Please enter your Note";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                  ],

                  // visit/////////////////////////////////////////////////////////
                  if (selectedVisitType == "Spot Visit") ...[
                    TextFormField(
                      controller: _visitdateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        isDense: true,

                        hintText: "Visit Date",
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

                          _visitdateController.text = formattedDate;
                        }
                      },

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select a visit date";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // 3. location Field
                    TextFormField(
                      maxLines: null,
                      controller: _visitfromlocationController,
                      keyboardType:
                          TextInputType.text, // Changed to text for description
                      decoration: InputDecoration(
                        isDense: true,

                        labelText: "From Location",
                        hintText: "From Location", // Corrected hintText
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
                          return "Please enter the location"; // Corrected error message
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      maxLines: null,
                      controller: _visittolocationController,
                      keyboardType:
                          TextInputType.text, // Changed to text for description
                      decoration: InputDecoration(
                        isDense: true,

                        labelText: "To Location",
                        hintText: "To Location", // Corrected hintText
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
                          return "Please enter the location"; // Corrected error message
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),

                    // time (from)
                    TextFormField(
                      controller: _visitfromtimeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        isDense: true,

                        hintText: "From Time",
                        labelText: "From Time",
                        suffixIcon: Icon(Icons.access_time),
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
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialEntryMode: TimePickerEntryMode.dialOnly,
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          final now = DateTime.now();
                          final from = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );

                          setState(() {
                            fromTime = pickedTime; // ⭐ MUST
                            _visitfromtimeController.text = DateFormat(
                              'hh:mm a',
                            ).format(from);
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select time";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // time (to)
                    TextFormField(
                      controller: _visittotimeController,
                      readOnly: true,
                      decoration: InputDecoration(
                        isDense: true,

                        labelText: "To Time",
                        hintText: "To Time",
                        suffixIcon: Icon(Icons.access_time),
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
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialEntryMode: TimePickerEntryMode.dialOnly,
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          final now = DateTime.now();
                          final to = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );

                          setState(() {
                            toTime = pickedTime; // ⭐ MUST
                            _visittotimeController.text = DateFormat(
                              'hh:mm a',
                            ).format(to);
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select time";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    DropdownSearch<PurposeModel>(
                      key: ValueKey("visit purpose"),
                      items: _visitpurposeNameList,
                      itemAsString: (PurposeModel p) =>
                          p.visitPurpose.toString(),
                      selectedItem: selectedVisitPurpose,
                      onChanged: (PurposeModel? pur) {
                        setState(() {
                          selectedVisitPurpose = pur;
                        });
                      },
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.search,
                            ), // এখানে search icon
                            hintText: "Search purpose..",
                            labelText: "Select purpose",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        showSelectedItems: false, // true দিলে compareFn লাগবে
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        // v5 এ সরাসরি decoration দিতে হবে না, বরং
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Select purpose",
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
                      validator: (PurposeModel? pur) =>
                          pur == null ? "Please select a purpose" : null,
                    ),

                    SizedBox(height: 10),
                    TextFormField(
                      maxLines: null,
                      controller: _remarksVisitController,
                      keyboardType:
                          TextInputType.text, // Changed to text as it's a name
                      decoration: InputDecoration(
                        labelText: "Note",
                        hintText: "Note",
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
                          return "Please enter your Note";
                        }
                        return null;
                      },
                    ),
                  ],

                  SizedBox(height: 10),

                  Visibility(
                    visible: inprogresssvisitstore == false,
                    replacement: Center(
                      child: CustomCircularProgressIndicator(),
                    ),

                    child: FilledButton(
                      onPressed: () {
                        if (_fromKey.currentState!.validate()) {
                          _visitStore();
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
      // bottomNavigationBar: CustomBottomNavigationBar(
      //   // currentIndex: widget.fromTabIndex,
      // ),
    );
  }

  String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

  Future<void> _visitStore() async {
    if (inprogresssvisitstore) return;

    inprogresssvisitstore = true;
    final bool isMeeting = selectedVisitType == "Meeting";
    setState(() {});
    final Map<String, dynamic> requestBody = {
      "visit_type": isMeeting ? 1 : 2,
      "company_id": AuthController.userModel!.companyid,
      "employee_id": AuthController.userModel!.empoloyeeid,
      "visit_date": isMeeting
          ? _dateController.text.trim()
          : _visitdateController.text.trim(),

      "visit_start_time": isMeeting
          ? convertTo24Hour(_fromtimeController.text.trim())
          : convertTo24Hour(_visitfromtimeController.text.trim()),

      // এন্ড টাইম কনভার্ট
      "visit_end_time": isMeeting
          ? convertTo24Hour(_totimeController.text.trim())
          : convertTo24Hour(_visittotimeController.text.trim()),

      "visit_purpose_id": isMeeting
          ? selectedPurpose!.id
          : selectedVisitPurpose!.id,
      "visit_from": isMeeting
          ? _fromlocationController.text.trim()
          : _visitfromlocationController.text.trim(),
      "visit_to": isMeeting
          ? _tolocationController.text.trim()
          : _visittolocationController.text.trim(),
      "contact_person": _contactpersonController.text.trim(),
      "visit_end_date": isMeeting
          ? _dateController.text.trim()
          : _visitdateController.text.trim(),
      "contact_person_mobile": _contactpersonMobileController.text.trim(),
      "remarks": isMeeting
          ? _remarksController.text.trim()
          : _remarksVisitController.text.trim(),
      // "client_id": selectedClient!.clientid,
    };
    if (selectedClient != null) {
      requestBody["client_id"] = selectedClient!.clientid;
    }

    ApiResponse response = await NetworkCaller.postRequest(
      url: Urls.visitstoreUrl,
      body: requestBody,
      token: AuthController.accessToken,
    );

    print(response.responseData);
    print(response.responseCode);

    if (response.isSuccess && response.responseData["success"] == true) {
      _clearText();

      Get.back(result: true);
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
      inprogresssvisitstore = false;
      setState(() {});
    }
  }

  String convertTo24Hour(String time12h) {
    if (time12h.isEmpty) return "";
    try {
      // এটি '08:20 PM' কে Parse করে ২৪ ঘণ্টায় নিয়ে যাবে
      DateTime date = DateFormat("hh:mm a").parse(time12h);
      return DateFormat("HH:mm").format(date);
    } catch (e) {
      return ""; // যদি এরর হয় তবে খালি স্ট্রিং পাঠাবে
    }
  }

  void _clearText() {
    _dateController.clear();
    _visitdateController.clear();
    _clientnameController.clear();
    _contactpersonController.clear();
    _contactpersonMobileController.clear();
    _fromlocationController.clear();
    _tolocationController.clear();
    _fromtimeController.clear();
    _totimeController.clear();
    _visitfromlocationController.clear();
    _visittolocationController.clear();
    _visitfromtimeController.clear();
    _visittotimeController.clear();
    _meetingpurposeController.clear();
    _visitpurposeController.clear();
  }

  void dispose() {
    _dateController.dispose();
    _visitdateController.dispose();
    _clientnameController.dispose();
    _contactpersonController.dispose();
    _contactpersonMobileController.dispose();
    _fromlocationController.dispose();
    _tolocationController.dispose();
    _fromtimeController.dispose();
    _totimeController.dispose();
    _visitfromlocationController.dispose();
    _visittolocationController.dispose();
    _visitfromtimeController.dispose();
    _visittotimeController.dispose();
    _meetingpurposeController.dispose();
    _visitpurposeController.dispose();
    super.dispose();
  }
}
