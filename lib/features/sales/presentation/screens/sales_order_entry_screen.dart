import 'dart:io';
import 'package:devsalesxpert/features/sales/data/models/from_filter_feild.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:devsalesxpert/app/urls.dart';
import 'package:devsalesxpert/core/services/network_caller.dart';
import 'package:devsalesxpert/features/auth/presentation/AuthController.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/circular_progress_indicator.dart';
import 'package:devsalesxpert/features/common/presentation/widgets/screen_background.dart';
import 'package:devsalesxpert/features/sales/data/models/customer_details_model.dart';
import 'package:devsalesxpert/features/visit/data/models/client_type_drop_dwon_model.dart';

class SalesOrderEntryScreen extends StatefulWidget {
  final int fromTabIndex;
  final String? modelName;
  const SalesOrderEntryScreen({
    super.key,
    this.fromTabIndex = 2,
    this.modelName,
  });

  @override
  State<SalesOrderEntryScreen> createState() => _SalesOrderEntryScreenState();
}

class _SalesOrderEntryScreenState extends State<SalesOrderEntryScreen> {
  // Controllers
  // new
  final _surfaceController = TextEditingController();
  final _totalwightkgController = TextEditingController();
  final _customerNIDController = TextEditingController();
  final _ownerNameController = TextEditingController();
  // new

  final _invoiceNoController = TextEditingController();
  final _orderdateController = TextEditingController();
  final _deliverydateController = TextEditingController();
  final _paymentmodeController = TextEditingController();
  final _customerController = TextEditingController();
  final _salesbyController = TextEditingController();
  final _addressController = TextEditingController();
  final _orderStatusController = TextEditingController();
  final _remarksController = TextEditingController();
  final _noOfDaysController = TextEditingController();

  final _collectionmodeController = TextEditingController();
  final _collectionamountController = TextEditingController();
  final _grossdiscountController = TextEditingController();

  // colelction mood bank
  final _banknameController = TextEditingController();
  final _accountDetailsController = TextEditingController();
  final _chequeNoController = TextEditingController();
  final _chequedateController = TextEditingController();

  // colelction mood  Bikash
  final _bikashmobilenumberController = TextEditingController();
  // colelction mood Nagad
  final _nagadmobilenumberController = TextEditingController();
  // colelction mood rocket
  final _rocketmobilenumberController = TextEditingController();

  final _transactionIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool showShortCreditField = false; // ফিল্ড দেখানো বা হাইড করার জন্য

  List<Map<String, String>> salesList = [];
  bool inprogressssalesorderentry = false;

  File? image;

  // from value
  final List<FormFilterField> fromFilterFeildList = [];
  FormFilterField? selectedFromFilterFeild;
  Future<void> _fetchFromFilterFeildList() async {
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.fromValueUrl(widget.modelName.toString()),
      token: AuthController.accessToken,
    );
    fromFilterFeildList.clear();
    if (!mounted) return;
    if (response.isSuccess) {
      final fromFilterFeildData = response.responseData;
      for (Map<String, dynamic> fromFilterFeildJson
          in fromFilterFeildData['data']['form_fields']) {
        final fromFilterFeildModel = FormFilterField.fromJson(
          fromFilterFeildJson,
        );
        fromFilterFeildList.add(fromFilterFeildModel);
      }

      setState(() {});
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
  }

  bool isFieldActive(String column) {
    return fromFilterFeildList.any(
      (f) => f.column == column && f.active == true,
    );
  }

  // client get api
  final List<ClientTypeModel> _clientNameList = [];
  ClientTypeModel? selectedClient;
  Future<void> _fetchclintList() async {
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.clientfromUrl,
      token: AuthController.accessToken,
    );
    if (!mounted) return;
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

  // customer details get api
  CustomerDetails? selectedCustomerDetails;
  Future<void> _fetchCustomerDetailsList(String id) async {
    ApiResponse response = await NetworkCaller.getRequest(
      url: Urls.customerDetailsa(id),
      token: AuthController.accessToken,
    );
    if (!mounted) return;
    if (response.isSuccess) {
      final customerDeatilsData = response.responseData;
      if (customerDeatilsData['data'] != null &&
          customerDeatilsData['data']['sale'] != null) {
        setState(() {
          selectedCustomerDetails = CustomerDetails.fromJson(
            customerDeatilsData['data']['sale'],
          );
        });
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

  // payment mood get api
  final List<String> _payementMoodList = [
    "Advance Payment",
    "Cash on Delivery",
    "Short Credit",
  ];
  String? selectedPaymentMood;

  final List<String> collectionModes = [
    'due',
    'cash',
    'bank',
    'bkash',
    'nagad',
    'rocket',
  ];
  String? selectedCollectionMode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchFromFilterFeildList();
    _fetchclintList();
    _orderdateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _deliverydateController.text = DateFormat(
      'dd-MM-yyyy',
    ).format(DateTime.now());

    // ১. ডিফল্ট ভ্যালু সেট করা
    selectedCollectionMode = 'due';
    _collectionmodeController.text = 'due';
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
        title: Text(
          "Sales Entry",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: ScreenBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// start
                TextFormField(
                  controller: _orderdateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    isDense: true,

                    hintText: "Order Date",
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                    labelText: "Order Date",
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

                      _orderdateController.text = formattedDate;
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

                TextFormField(
                  controller: _deliverydateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    isDense: true,

                    hintText: "Delivery Date",
                    labelText: "Delivery Date",
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

                      _deliverydateController.text = formattedDate;
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

                DropdownSearch<String>(
                  key: ValueKey("Payment mood"),
                  items: _payementMoodList,
                  itemAsString: (String p) => p,
                  selectedItem: selectedPaymentMood,
                  onChanged: (String? pur) {
                    setState(() {
                      selectedPaymentMood = pur;
                      showShortCreditField = (pur == "Short Credit");

                      // যদি অন্য কিছু সিলেক্ট করে তবে আগের লেখা ক্লিয়ার করে দেওয়া ভালো
                      if (!showShortCreditField) {
                        _noOfDaysController.clear();
                      }
                    });
                  },
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                        ), // এখানে search icon
                        hintText: "Search payment mood..",
                        labelText: "Select Payment Mood",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    showSelectedItems: false,
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Payment Mood",
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
                  validator: (String? pur) =>
                      pur == null ? "Please select a payment mood" : null,
                ),

                if (showShortCreditField)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: _noOfDaysController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "No. of Days",
                        hintText: "Enter No. of Days",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

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
                      labelText: "Customer",
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
                  onChanged: (ClientTypeModel? client) async {
                    if (client != null) {
                      setState(() {
                        selectedClient = client;
                      });
                      await _fetchCustomerDetailsList(
                        client.clientid.toString(),
                      );
                      if (selectedCustomerDetails != null) {
                        setState(() {
                          _addressController.text =
                              selectedCustomerDetails!.presentAddress ??
                              "No Address Found";
                          _grossdiscountController.text =
                              selectedCustomerDetails!.discount.toString();
                        });
                      }
                    }
                  },
                  validator: (ClientTypeModel? client) =>
                      client == null ? "Please select a customer" : null,
                ),
                SizedBox(height: 10),

                TextFormField(
                  controller: _addressController,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'address is required'
                      : null,
                  decoration: InputDecoration(
                    labelText: "Address",
                    isDense: true,
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
                const SizedBox(height: 10),

                if (isFieldActive("remarks")) ...[
                  TextFormField(
                    controller: _remarksController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'remarks is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Remarks",
                      isDense: true,
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
                  const SizedBox(height: 10),
                ],

                if (isFieldActive("surface")) ...[
                  TextFormField(
                    controller: _surfaceController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'surface is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Surface",
                      isDense: true,
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
                  const SizedBox(height: 10),
                ],
                if (isFieldActive("owner_name")) ...[
                  TextFormField(
                    controller: _ownerNameController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'owner name is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Owner Name",
                      isDense: true,
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

                  const SizedBox(height: 10),
                ],

                if (isFieldActive("nid_bin")) ...[
                  TextFormField(
                    controller: _customerNIDController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'customer nid is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Customer Nid",
                      isDense: true,
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
                  const SizedBox(height: 10),
                ],
                if (isFieldActive("total_weight")) ...[
                  TextFormField(
                    controller: _totalwightkgController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'totalweight kg is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Total Weight (Kg)",
                      isDense: true,
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
                  const SizedBox(height: 10),
                ],

                // // collection mood
                DropdownButtonFormField<String>(
                  value: selectedCollectionMode,
                  items: collectionModes
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCollectionMode = value;
                      _collectionmodeController.text = value ?? '';
                    });
                  },
                  validator: (value) =>
                      value == null ? 'collection mode is required' : null,
                  decoration: InputDecoration(
                    labelText: 'Collection Mode',
                    isDense: true,
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
                const SizedBox(height: 12),

                if (selectedCollectionMode == 'bank') ...[
                  // if mood bank
                  TextFormField(
                    controller: _banknameController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'bank name & branch name is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Bank Name & Branch Name",
                      isDense: true,
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
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _accountDetailsController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'account details is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Account Details",
                      isDense: true,
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
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _chequeNoController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'cheque no is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Cheque No",
                      isDense: true,
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
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _chequedateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      isDense: true,

                      hintText: "Cheque Date",
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
                        _chequedateController.text = formattedDate;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a cheque date";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                ],
                if (selectedCollectionMode == 'bkash') ...[
                  // if mood BKASH
                  TextFormField(
                    controller: _bikashmobilenumberController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'bikash mobile is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Bikash Mobile No",
                      isDense: true,
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
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _transactionIdController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'transaction id is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Transaction Id",
                      isDense: true,
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
                  const SizedBox(height: 10),
                ],
                if (selectedCollectionMode == 'nagad') ...[
                  // if mood NAGAD
                  TextFormField(
                    controller: _nagadmobilenumberController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'nagad mobile is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Nagad Mobile No",
                      isDense: true,
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
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _transactionIdController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'transaction id is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Transaction Id",
                      isDense: true,
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
                  const SizedBox(height: 10),
                ],
                if (selectedCollectionMode == 'rocket') ...[
                  // if mood Rocket
                  TextFormField(
                    controller: _rocketmobilenumberController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'rocket mobile is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Rocket Mobile No",
                      isDense: true,
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
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _transactionIdController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'transaction id is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Transaction Id",
                      isDense: true,
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
                  const SizedBox(height: 10),
                ],

                TextFormField(
                  controller: _collectionamountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Collection Amount",
                    hintText: "Collection Amount",
                    isDense: true,
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

                SizedBox(height: 10),

                TextFormField(
                  controller: _grossdiscountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Gross Discount (%)",
                    hintText: "Gross Discount (%)",
                    isDense: true,
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

                SizedBox(height: 10),

                Visibility(
                  visible: inprogressssalesorderentry == false,
                  replacement: Center(child: CustomCircularProgressIndicator()),
                  child: FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _SalesOrderEntry();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>((
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
                      minimumSize: WidgetStateProperty.all(const Size(370, 50)),
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
      // bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2),
    );
  }

  int getPaymentId(String? mood) {
    if (mood == "Advance Payment") return 1;
    if (mood == "Cash on Delivery") return 2;
    if (mood == "Short Credit") return 3;
    return 0;
  }

  Future<void> _SalesOrderEntry() async {
    if (inprogressssalesorderentry) return;

    inprogressssalesorderentry = true;

    setState(() {});

    final Map<String, dynamic> requestBody = {
      "company_id": AuthController.userModel!.companyid,
      "employee_id": AuthController.userModel!.empoloyeeid, // sales by
      "sale_date": _orderdateController.text.trim(),
      "receive_date": _deliverydateController.text.trim(),
      "payment_type": getPaymentId(selectedPaymentMood),
      "delivery_address": _addressController.text.trim(),
      "remarks": _remarksController.text.trim(),
      "total_days": showShortCreditField
          ? _noOfDaysController.text.trim()
          : null,

      // amount
      "gross_discount": _grossdiscountController.text.trim(),
      "collection_amount": _collectionamountController.text.trim(),

      // collection
      "collection_mode": selectedCollectionMode,
    };

    // ================= BANK =================
    if (selectedCollectionMode == 'bank') {
      requestBody.addAll({
        "bank_name": _banknameController.text.trim(),
        "acc_name": _accountDetailsController.text.trim(),
        "cheque_no": _chequeNoController.text.trim(),
        "cheque_date": _chequedateController.text.trim(),
      });
    }

    // ================= MOBILE BANKING =================
    if (selectedCollectionMode == 'bkash' ||
        selectedCollectionMode == 'nagad' ||
        selectedCollectionMode == 'rocket') {
      requestBody.addAll({
        "mobile": selectedCollectionMode == 'bkash'
            ? _bikashmobilenumberController.text.trim()
            : selectedCollectionMode == 'nagad'
            ? _nagadmobilenumberController.text.trim()
            : _rocketmobilenumberController.text.trim(),
        "trx_id": _transactionIdController.text.trim(),
      });
    }

    if (selectedClient != null) {
      requestBody["party_id"] = selectedClient!.clientid;
    }

    ApiResponse response = await NetworkCaller.postRequest(
      url: Urls.salesorderEntryUrl,
      body: requestBody,
      token: AuthController.accessToken,
    );

    print(response.responseData);
    print(response.responseCode);

    if (response.isSuccess && response.responseData["success"] == true) {
      _clearText();

      Get.back(result: true);

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
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
      inprogressssalesorderentry = false;
      setState(() {});
    }
  }

  void _clearText() {
    _invoiceNoController.clear();
    _orderdateController.clear();
    _deliverydateController.clear();
    _paymentmodeController.clear();
    _customerController.clear();
    _salesbyController.clear();
    _addressController.clear();
    _orderStatusController.clear();
    _remarksController.clear();
  }

  @override
  void dispose() {
    _invoiceNoController.dispose();
    _orderdateController.dispose();
    _deliverydateController.dispose();
    _paymentmodeController.dispose();
    _customerController.dispose();
    _salesbyController.dispose();
    _addressController.dispose();
    _orderStatusController.dispose();
    _remarksController.dispose();
    super.dispose();
  }
}
