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
import 'package:devsalesxpert/features/sales/data/models/pending_model.dart';
import 'package:devsalesxpert/features/visit/data/models/client_type_drop_dwon_model.dart';

class SalesOrderUpdateScreen extends StatefulWidget {
  final int fromTabIndex;
  final PendingModel item;
  final String? modelName;
  final int? index;
  const SalesOrderUpdateScreen({
    super.key,
    this.fromTabIndex = 2,
    required this.item,
    this.index,
    this.modelName,
  });

  @override
  State<SalesOrderUpdateScreen> createState() => _SalesOrderUpdateScreenState();
}

class _SalesOrderUpdateScreenState extends State<SalesOrderUpdateScreen> {
  // Controllers
  final _surfaceController = TextEditingController();
  final _totalwightkgController = TextEditingController();
  final _customerNIDController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _cashCustomerNameController = TextEditingController();
  final _cashCustomerContractController = TextEditingController();
  final _factoryLeaveDateController = TextEditingController();

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
  final _bankAccountNameController = TextEditingController();
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

  bool showShortCreditField = false; //
  bool customerListFlag = false;

  bool showCashCustomerNameContractField = false;

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

    if (response.isSuccess) {
      final clienttypeData = response.responseData;
      for (Map<String, dynamic> clienttypeJson in clienttypeData['data']) {
        final clienttypeModelall = ClientTypeModel.fromJson(clienttypeJson);
        _clientNameList.add(clienttypeModelall);
      }
      if (_clientNameList.isNotEmpty) {
        try {
          selectedClient = _clientNameList.firstWhere(
            (client) =>
                client.name.toString().trim() ==
                widget.item.partyName.toString().trim(),
          );
        } catch (e) {
          selectedClient = null;
        }
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

  // static list of customer type
  final List<String> _customerTypeList = ["Cash Customer", "Regular Customer"];
  String? selectedCustomerType;

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
    print(widget.item.id);
    _fetchclintList();

    DateFormat serverFormat = DateFormat("dd MMM, yyyy");
    DateFormat myFormat = DateFormat("dd-MM-yyyy");

    _orderdateController.text = myFormat.format(
      serverFormat.parse(widget.item.saleDate!),
    );
    _factoryLeaveDateController.text = myFormat.format(
      serverFormat.parse(widget.item.factoryLeaveDate!),
    );

    _deliverydateController.text = myFormat.format(
      serverFormat.parse(widget.item.receiveDate!),
    );

    _addressController.text = widget.item.deliveryAddress ?? "";
    _remarksController.text = widget.item.remarks ?? "";

    String? existingPayment = widget.item.paymentTypeText;
    String? existingType = widget.item.paymentTypeText;

    // customer type
    if (_customerTypeList.contains(existingType)) {
      selectedCustomerType = existingType;
      showCashCustomerNameContractField = (existingType == "cash");
      if (showCashCustomerNameContractField) {
        _cashCustomerNameController.text =
            widget.item.cashCustomerName?.toString() ?? "";
        _cashCustomerContractController.text =
            widget.item.cashCustomerNumber?.toString() ?? "";
      }
    }

    // payment mood
    if (_payementMoodList.contains(existingPayment)) {
      selectedPaymentMood = existingPayment;
      showShortCreditField = (existingPayment == "Short Credit");
      if (showShortCreditField) {
        _noOfDaysController.text = widget.item.totalDays?.toString() ?? "";
      }
    }

    ////////
    /// ---------- COLLECTION MODE ----------
    selectedCollectionMode = widget.item.collectionMood.toString();

    /// ---------- AMOUNT ----------
    _collectionamountController.text =
        widget.item.collectionAmount?.toString() ?? "";

    _grossdiscountController.text = widget.item.grossDiscount?.toString() ?? "";

    /// ---------- BANK ----------
    if (selectedCollectionMode == 'bank') {
      _banknameController.text = widget.item.bankName ?? "";
      _bankAccountNameController.text = widget.item.accName ?? "";
      _chequeNoController.text = widget.item.chequeNo ?? "";
      _chequedateController.text = myFormat.format(
        serverFormat.parse(widget.item.chequeDate!),
      );
    }

    /// ---------- MOBILE BANKING ----------
    if (selectedCollectionMode == 'bkash') {
      _bikashmobilenumberController.text = widget.item.mobile ?? "";
      _transactionIdController.text = widget.item.trxId ?? "";
    }

    if (selectedCollectionMode == 'nagad') {
      _nagadmobilenumberController.text = widget.item.mobile ?? "";
      _transactionIdController.text = widget.item.trxId ?? "";
    }

    if (selectedCollectionMode == 'rocket') {
      _rocketmobilenumberController.text = widget.item.mobile ?? "";
      _transactionIdController.text = widget.item.trxId ?? "";
    }

    print("heloooooooooooooooooooooooooooooooo");
    print(widget.item.totalDays?.toString());

    _fetchclintList();
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
          "Sales Update",
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
                if (isFieldActive('sale_date')) ...[
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
                ],

                // factory leave date
                if (isFieldActive('factory_leave_date')) ...[
                  TextFormField(
                    controller: _factoryLeaveDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      isDense: true,

                      hintText: "Factory Leave Date",
                      labelText: "Factory Leave Date",
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

                        _factoryLeaveDateController.text = formattedDate;
                      }
                    },

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a factory leave date";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                ],

                if (isFieldActive('receive_date')) ...[
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
                ],

                if (isFieldActive('party_id') && customerListFlag == false) ...[
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
                    onChanged: (ClientTypeModel? client) {
                      if (client != null) {
                        setState(() {
                          selectedClient = client;
                          _addressController.text = client.emailAddress
                              .toString();
                        });
                      }
                    },
                    validator: (ClientTypeModel? client) =>
                        client == null ? "Please select a customer" : null,
                  ),
                  SizedBox(height: 10),
                ],

                if (isFieldActive('delivery_address')) ...[
                  TextFormField(
                    controller: _addressController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'delivery address is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Delivery Address",
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

                // customer type                    ///
                if (isFieldActive('party_type'))
                  DropdownSearch<String>(
                    key: ValueKey("Customer Type"),
                    items: _customerTypeList,
                    itemAsString: (String p) => p,
                    selectedItem: selectedCustomerType,
                    onChanged: (String? tap) {
                      setState(() {
                        selectedCustomerType = tap;
                        showCashCustomerNameContractField =
                            (tap == "Cash Customer");

                        if (!showCashCustomerNameContractField) {
                          _cashCustomerContractController.clear();
                          _cashCustomerNameController.clear();
                        }

                        // customer drop down show hide
                        if (selectedCustomerType == "Cash Customer") {
                          customerListFlag = true;
                          setState(() {});
                        } else {
                          customerListFlag = false;
                          setState(() {});
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
                          hintText: "--Select Customer Type--",
                          labelText: "--Select Customer Type--",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      showSelectedItems: false,
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Customer Type",
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
                        pur == null ? "Please select a customer type" : null,
                  ),
                const SizedBox(height: 10),

                if (showCashCustomerNameContractField &&
                    isFieldActive('cash_party')) ...[
                  TextFormField(
                    controller: _cashCustomerNameController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'cash customer name is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Cash Customer Name",
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

                if (showCashCustomerNameContractField &&
                    isFieldActive('party_mobile')) ...[
                  TextFormField(
                    controller: _cashCustomerContractController,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'cash customer contract no is required'
                        : null,
                    decoration: InputDecoration(
                      labelText: "Cash Customer Contact No",
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

                if (isFieldActive('payment_type')) ...[
                  DropdownSearch<String>(
                    key: ValueKey("Payment mood"),
                    items: _payementMoodList,
                    itemAsString: (String p) => p,
                    selectedItem: selectedPaymentMood,
                    onChanged: (String? pur) {
                      setState(() {
                        selectedPaymentMood = pur;
                        showShortCreditField = (pur == "Short Credit");

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

                      showSelectedItems: false, // true দিলে compareFn লাগবে
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      // v5 এ সরাসরি decoration দিতে হবে না, বরং
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
                  const SizedBox(height: 10),
                ],

                if (showShortCreditField && isFieldActive('total_days')) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: _noOfDaysController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "No. of Days",
                        hintText: "Enter No. of Days",
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
                  ),

                  const SizedBox(height: 10),
                ],

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

                // collection mood
                if (isFieldActive('collection_mode')) ...[
                  DropdownButtonFormField<String>(
                    value: collectionModes.contains(selectedCollectionMode)
                        ? selectedCollectionMode
                        : null,
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
                ],

                if (selectedCollectionMode == 'bank' &&
                    isFieldActive('bank_name')) ...[
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
                  if (isFieldActive('acc_name')) ...[
                    TextFormField(
                      controller: _bankAccountNameController,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'account details is required'
                          : null,
                      decoration: InputDecoration(
                        labelText: "Bank Account Name",
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

                  if (isFieldActive('cheque_no')) ...[
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
                  ],

                  if (isFieldActive('cheque_date')) ...[
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
                          return "Please select a chqque date";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ],

                if (selectedCollectionMode == 'bkash' &&
                    isFieldActive('mobile')) ...[
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
                  if (isFieldActive('trx_id'))
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

                if (selectedCollectionMode == 'nagad' &&
                    isFieldActive('mobile')) ...[
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
                  if (isFieldActive('trx_id'))
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

                if (selectedCollectionMode == 'rocket' &&
                    isFieldActive('mobile')) ...[
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
                  if (isFieldActive('trx_id'))
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

                if (isFieldActive('collection_amount')) ...[
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
                ],

                if (isFieldActive('gross_discount')) ...[
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
                ],

                Visibility(
                  visible: inprogressssalesorderentry == false,
                  replacement: Center(child: CustomCircularProgressIndicator()),
                  child: FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _SalesOrderUpdate();
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      minimumSize: WidgetStateProperty.all(const Size(370, 50)),
                      overlayColor: WidgetStateProperty.all(
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
      // bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2),
    );
  }

  int getPaymentId(String? mood) {
    if (mood == "Advance Payment") return 1;
    if (mood == "Cash on Delivery") return 2;
    if (mood == "Short Credit") return 3;
    return 0;
  }

  String getCustomerType(String? type) {
    if (type == "Cash Customer") return "cash";
    if (type == "Regular Customer") return "regular";
    return " ";
  }

  Future<void> _SalesOrderUpdate() async {
    if (inprogressssalesorderentry) return;

    inprogressssalesorderentry = true;

    setState(() {});

    final Map<String, dynamic> requestBody = {
      "company_id": AuthController.userModel!.companyid,
      "employee_id": AuthController.userModel!.empoloyeeid, // sales by
      "sale_date": _orderdateController.text.trim(),
      "receive_date": _deliverydateController.text.trim(),
      "factory_leave_date": _factoryLeaveDateController.text.trim(),
      "delivery_address": _addressController.text.trim(),

      // customer type
      "party_type": getCustomerType(selectedCustomerType),
      "cash_party": showCashCustomerNameContractField
          ? _cashCustomerNameController.text.trim()
          : null,
      "party_mobile": showCashCustomerNameContractField
          ? _cashCustomerContractController.text.trim()
          : null,

      //  payment mood
      "payment_type": getPaymentId(selectedPaymentMood),
      "total_days": showShortCreditField
          ? _noOfDaysController.text.trim()
          : null,

      "remarks": _remarksController.text.trim(),
      "surface": _surfaceController.text.trim(),
      "owner_name": _ownerNameController.text.trim(),
      "nid_bin": _customerNIDController.text.trim(),

      "total_weight": _totalwightkgController.text.trim(),

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
        "acc_name": _bankAccountNameController.text.trim(),
        "cheque_no": _chequeNoController.text.trim(),
        "cheque_date": _chequedateController.text.trim(),
      });
    }

    // ================= MOBILE BANKING =================
    if (selectedCollectionMode == 'bkash' ||
        selectedCollectionMode == 'bagad' ||
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
      url: Urls.saleEdit(widget.item.id.toString()),
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
