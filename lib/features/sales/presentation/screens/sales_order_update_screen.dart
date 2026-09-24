import 'dart:io';
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
  final int? index;
  const SalesOrderUpdateScreen({
    super.key,
    this.fromTabIndex = 2,
    required this.item,
    this.index,
  });

  @override
  State<SalesOrderUpdateScreen> createState() => _SalesOrderUpdateScreenState();
}

class _SalesOrderUpdateScreenState extends State<SalesOrderUpdateScreen> {
  // Controllers
  final _surfaceController = TextEditingController();
  final _totalwightkgController = TextEditingController();
  final _customerNIDController = TextEditingController();

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

  List<Map<String, String>> salesList = [];
  bool inprogressssalesorderentry = false;

  File? image;

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
    print(widget.item.id);
    _fetchclintList();

    DateFormat serverFormat = DateFormat("dd MMM, yyyy");
    DateFormat myFormat = DateFormat("dd-MM-yyyy");

    _orderdateController.text = myFormat.format(
      serverFormat.parse(widget.item.saleDate!),
    );
    _deliverydateController.text = myFormat.format(
      serverFormat.parse(widget.item.receiveDate!),
    );

    _addressController.text = widget.item.deliveryAddress ?? "";
    _remarksController.text = widget.item.remarks ?? "";

    String? existingPayment = widget.item.paymentTypeText;

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

                if (showShortCreditField)
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

                // // collection mood
                DropdownButtonFormField<String>(
                  // value: selectedCollectionMode,
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
                        return "Please select a chqque date";
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

  Future<void> _SalesOrderUpdate() async {
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
